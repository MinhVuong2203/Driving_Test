import 'package:drift/drift.dart';
import '../app_database.dart';

class ExamSetResultSummary {
  final int examSetId;
  final int totalQuestions;
  final int correctAnswers;
  final bool isPassed;
  final DateTime? submittedAt;

  const ExamSetResultSummary({
    required this.examSetId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.isPassed,
    this.submittedAt,
  });
}

class UserProgressDao {
  final AppDatabase db;
  UserProgressDao(this.db);

  Future<String> _currentRankId() async {
    final setting = await (db.select(
      db.setting,
    )..where((s) => s.SettingId.equals(1))).getSingleOrNull();

    return (setting?.rankId ?? 'B').trim().toUpperCase();
  }

  bool _questionMatchesRank(Question question, String rankId) {
    switch (rankId) {
      case 'A1':
      case 'A':
        return question.ofRankA == 1;
      case 'B1':
        return question.ofRankB1 == 1;
      default:
        return true;
    }
  }

  // 1. Saved Questions (Câu đã lưu)
  Future<List<Question>> getSavedQuestions() async {
    final query = db.select(db.questions).join([
      innerJoin(
        db.savedQuestions,
        db.savedQuestions.questionId.equalsExp(db.questions.id),
      ),
    ])..orderBy([OrderingTerm.desc(db.savedQuestions.savedAt)]);

    final rows = await query.get();
    return rows.map((row) => row.readTable(db.questions)).toList();
  }

  Future<bool> isQuestionSaved(int questionId) async {
    final result = await (db.select(
      db.savedQuestions,
    )..where((t) => t.questionId.equals(questionId))).getSingleOrNull();
    return result != null;
  }

  Future<void> toggleSavedQuestion(int questionId) async {
    final existing = await (db.select(
      db.savedQuestions,
    )..where((t) => t.questionId.equals(questionId))).getSingleOrNull();
    if (existing != null) {
      await (db.delete(
        db.savedQuestions,
      )..where((t) => t.questionId.equals(questionId))).go();
    } else {
      await db
          .into(db.savedQuestions)
          .insert(
            SavedQuestionsCompanion.insert(questionId: Value(questionId)),
          );
    }
  }

  // 2. Wrong Questions (Câu sai)
  Future<List<Question>> getWrongQuestions() async {
    final rankId = await _currentRankId();
    final query =
        db.select(db.questions).join([
            innerJoin(
              db.wrongQuestions,
              db.wrongQuestions.questionId.equalsExp(db.questions.id),
            ),
          ])
          ..where(db.wrongQuestions.rankId.equals(rankId))
          ..orderBy([OrderingTerm.desc(db.wrongQuestions.lastWrongAt)]);

    final rows = await query.get();
    return rows.map((row) => row.readTable(db.questions)).toList();
  }

  Future<int> countWrongQuestions() async {
    final rankId = await _currentRankId();
    final rows = await (db.select(
      db.wrongQuestions,
    )..where((t) => t.rankId.equals(rankId))).get();
    return rows.length;
  }

  Future<void> logWrongAnswer(int questionId) async {
    final rankId = await _currentRankId();
    final existing =
        await (db.select(db.wrongQuestions)..where(
              (t) => t.questionId.equals(questionId) & t.rankId.equals(rankId),
            ))
            .getSingleOrNull();
    if (existing != null) {
      await (db.update(db.wrongQuestions)..where(
            (t) => t.questionId.equals(questionId) & t.rankId.equals(rankId),
          ))
          .write(
            WrongQuestionsCompanion(
              rankId: Value(rankId),
              wrongCount: Value(existing.wrongCount + 1),
              lastWrongAt: Value(DateTime.now()),
            ),
          );
    } else {
      await db
          .into(db.wrongQuestions)
          .insert(
            WrongQuestionsCompanion.insert(
              questionId: Value(questionId),
              rankId: Value(rankId),
            ),
          );
    }
  }

  Future<void> removeWrongQuestion(int questionId) async {
    final rankId = await _currentRankId();
    await (db.delete(db.wrongQuestions)..where(
          (t) => t.questionId.equals(questionId) & t.rankId.equals(rankId),
        ))
        .go();
  }

  // 3. User Answers (Câu trả lời để tính tiến độ)
  Future<void> logAnswer(
    int questionId,
    String selectedAnswer,
    bool isCorrect, {
    int? examSetId,
  }) async {
    final rankId = await _currentRankId();
    final existing =
        await (db.select(db.userAnswers)..where(
              (t) =>
                  t.questionId.equals(questionId) &
                  t.rankId.equals(rankId) &
                  (examSetId == null
                      ? t.examSetId.isNull()
                      : t.examSetId.equals(examSetId)),
            ))
            .getSingleOrNull();
    if (existing != null) {
      await (db.update(db.userAnswers)..where(
            (t) =>
                t.questionId.equals(questionId) &
                t.rankId.equals(rankId) &
                (examSetId == null
                    ? t.examSetId.isNull()
                    : t.examSetId.equals(examSetId)),
          ))
          .write(
            UserAnswersCompanion(
              examSetId: Value(examSetId),
              rankId: Value(rankId),
              selectedAnswer: Value(selectedAnswer),
              isCorrect: Value(isCorrect ? 1 : 0),
            ),
          );
    } else {
      await db
          .into(db.userAnswers)
          .insert(
            UserAnswersCompanion.insert(
              examSetId: Value(examSetId),
              questionId: Value(questionId),
              rankId: Value(rankId),
              selectedAnswer: Value(selectedAnswer),
              isCorrect: Value(isCorrect ? 1 : 0),
            ),
          );
    }
  }

  Future<Map<int, String>> getExamSetSavedAnswers(int examSetId) async {
    final rankId = await _currentRankId();
    final answers =
        await (db.select(db.userAnswers)..where(
              (t) => t.rankId.equals(rankId) & t.examSetId.equals(examSetId),
            ))
            .get();

    final savedAnswers = <int, String>{};
    for (final answer in answers) {
      final questionId = answer.questionId;
      final selectedAnswer = answer.selectedAnswer;
      if (questionId == null || selectedAnswer == null) continue;
      savedAnswers[questionId] = selectedAnswer;
    }
    return savedAnswers;
  }

  Future<int?> getExamSetRemainingSeconds(int examSetId) async {
    final rankId = await _currentRankId();
    final progress =
        await (db.select(db.examSetProgress)..where(
              (t) => t.examSetId.equals(examSetId) & t.rankId.equals(rankId),
            ))
            .getSingleOrNull();
    return progress?.remainingSeconds;
  }

  Future<void> saveExamSetRemainingSeconds(
    int examSetId,
    int remainingSeconds,
  ) async {
    final rankId = await _currentRankId();
    final existing =
        await (db.select(db.examSetProgress)..where(
              (t) => t.examSetId.equals(examSetId) & t.rankId.equals(rankId),
            ))
            .getSingleOrNull();

    final normalizedSeconds = remainingSeconds < 0 ? 0 : remainingSeconds;
    if (existing != null) {
      await (db.update(db.examSetProgress)..where(
            (t) => t.examSetId.equals(examSetId) & t.rankId.equals(rankId),
          ))
          .write(
            ExamSetProgressCompanion(
              remainingSeconds: Value(normalizedSeconds),
              updatedAt: Value(DateTime.now()),
            ),
          );
      return;
    }

    await db
        .into(db.examSetProgress)
        .insert(
          ExamSetProgressCompanion.insert(
            examSetId: examSetId,
            rankId: Value(rankId),
            remainingSeconds: Value(normalizedSeconds),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<void> saveExamSetResult({
    required int examSetId,
    required int totalQuestions,
    required int correctAnswers,
    required bool isPassed,
    required int remainingSeconds,
  }) async {
    final rankId = await _currentRankId();
    final existing =
        await (db.select(db.examSetProgress)..where(
              (t) => t.examSetId.equals(examSetId) & t.rankId.equals(rankId),
            ))
            .getSingleOrNull();
    final now = DateTime.now();
    final companion = ExamSetProgressCompanion(
      remainingSeconds: Value(remainingSeconds < 0 ? 0 : remainingSeconds),
      totalQuestions: Value(totalQuestions),
      correctAnswers: Value(correctAnswers),
      isPassed: Value(isPassed ? 1 : 0),
      submittedAt: Value(now),
      updatedAt: Value(now),
    );

    if (existing != null) {
      await (db.update(db.examSetProgress)..where(
            (t) => t.examSetId.equals(examSetId) & t.rankId.equals(rankId),
          ))
          .write(companion);
      return;
    }

    await db
        .into(db.examSetProgress)
        .insert(
          ExamSetProgressCompanion.insert(
            examSetId: examSetId,
            rankId: Value(rankId),
            remainingSeconds: companion.remainingSeconds,
            totalQuestions: companion.totalQuestions,
            correctAnswers: companion.correctAnswers,
            isPassed: companion.isPassed,
            submittedAt: companion.submittedAt,
            updatedAt: companion.updatedAt,
          ),
        );
  }

  Future<ExamSetResultSummary?> getExamSetResultSummary(int examSetId) async {
    final rankId = await _currentRankId();
    final progress =
        await (db.select(db.examSetProgress)..where(
              (t) => t.examSetId.equals(examSetId) & t.rankId.equals(rankId),
            ))
            .getSingleOrNull();
    if (progress == null || progress.submittedAt == null) return null;
    return ExamSetResultSummary(
      examSetId: examSetId,
      totalQuestions: progress.totalQuestions ?? 0,
      correctAnswers: progress.correctAnswers ?? 0,
      isPassed: progress.isPassed == 1,
      submittedAt: progress.submittedAt,
    );
  }

  Future<Map<int, ExamSetResultSummary>> getExamSetResultSummaries(
    List<int> examSetIds,
  ) async {
    if (examSetIds.isEmpty) return {};

    final rankId = await _currentRankId();
    final rows =
        await (db.select(db.examSetProgress)..where(
              (t) =>
                  t.rankId.equals(rankId) &
                  t.examSetId.isIn(examSetIds) &
                  t.submittedAt.isNotNull(),
            ))
            .get();

    final result = <int, ExamSetResultSummary>{};
    for (final progress in rows) {
      result[progress.examSetId] = ExamSetResultSummary(
        examSetId: progress.examSetId,
        totalQuestions: progress.totalQuestions ?? 0,
        correctAnswers: progress.correctAnswers ?? 0,
        isPassed: progress.isPassed == 1,
        submittedAt: progress.submittedAt,
      );
    }
    return result;
  }

  // 4. Progress Stats
  Future<Map<String, int>> getProgressStats() async {
    final rankId = await _currentRankId();
    final totalQuestionsResult = await db.select(db.questions).get();
    final rankQuestions = totalQuestionsResult
        .where((q) => _questionMatchesRank(q, rankId))
        .toList();
    final rankQuestionIds = rankQuestions.map((q) => q.id).toSet();
    final totalQuestions = rankQuestions.length;

    final userAnswersResult = await (db.select(
      db.userAnswers,
    )..where((t) => t.rankId.equals(rankId))).get();
    final answersByQuestionId = <int, UserAnswer>{};
    for (final answer in userAnswersResult) {
      final questionId = answer.questionId;
      if (questionId != null && rankQuestionIds.contains(questionId)) {
        answersByQuestionId[questionId] = answer;
      }
    }
    final rankAnswers = answersByQuestionId.values.toList();
    final answeredQuestions = rankAnswers.length;
    final correctAnswers = rankAnswers.where((a) => a.isCorrect == 1).length;
    final wrongAnswers = answeredQuestions - correctAnswers;

    return {
      'total': totalQuestions,
      'answered': answeredQuestions,
      'correct': correctAnswers,
      'wrong': wrongAnswers,
    };
  }

  Future<Map<int, Map<String, int>>> getTopicProgressStats() async {
    final rankId = await _currentRankId();
    final questionsResult = await db.select(db.questions).get();
    final userAnswersResult = await (db.select(
      db.userAnswers,
    )..where((t) => t.rankId.equals(rankId))).get();

    final answersByQuestionId = <int, UserAnswer>{};
    for (final answer in userAnswersResult) {
      final questionId = answer.questionId;
      if (questionId != null) {
        answersByQuestionId[questionId] = answer;
      }
    }

    final statsByTopic = <int, Map<String, int>>{};

    for (final question in questionsResult) {
      if (!_questionMatchesRank(question, rankId)) continue;
      final topicId = question.topicId;
      if (topicId == null) continue;

      final stats = statsByTopic.putIfAbsent(
        topicId,
        () => {'total': 0, 'answered': 0, 'correct': 0, 'wrong': 0},
      );

      stats['total'] = stats['total']! + 1;

      final answer = answersByQuestionId[question.id];
      if (answer == null) continue;

      stats['answered'] = stats['answered']! + 1;
      if (answer.isCorrect == 1) {
        stats['correct'] = stats['correct']! + 1;
      } else {
        stats['wrong'] = stats['wrong']! + 1;
      }
    }

    return statsByTopic;
  }

  Future<Map<int, Map<String, int>>> getExamSetProgressStats(
    List<int> examSetIds,
  ) async {
    if (examSetIds.isEmpty) return {};

    final rankId = await _currentRankId();
    final links = await (db.select(
      db.examSetQuestions,
    )..where((t) => t.examSetId.isIn(examSetIds))).get();

    final answers =
        await (db.select(db.userAnswers)..where(
              (t) => t.rankId.equals(rankId) & t.examSetId.isIn(examSetIds),
            ))
            .get();
    final answeredQuestionIdsByExam = <int, Set<int>>{};
    for (final answer in answers) {
      final examSetId = answer.examSetId;
      final questionId = answer.questionId;
      if (examSetId == null || questionId == null) continue;
      answeredQuestionIdsByExam
          .putIfAbsent(examSetId, () => <int>{})
          .add(questionId);
    }

    final statsByExam = <int, Map<String, int>>{};

    for (final examSetId in examSetIds) {
      statsByExam[examSetId] = {'total': 0, 'answered': 0};
    }

    for (final link in links) {
      final examSetId = link.examSetId;
      final questionId = link.questionId;
      if (examSetId == null || questionId == null) continue;

      final stats = statsByExam.putIfAbsent(
        examSetId,
        () => {'total': 0, 'answered': 0},
      );
      stats['total'] = stats['total']! + 1;

      if (answeredQuestionIdsByExam[examSetId]?.contains(questionId) == true) {
        stats['answered'] = stats['answered']! + 1;
      }
    }

    return statsByExam;
  }

  Future<Map<String, int>> getExamSetProgressStatsById(int examSetId) async {
    final stats = await getExamSetProgressStats([examSetId]);
    return stats[examSetId] ?? {'total': 0, 'answered': 0};
  }

  Future<void> resetExamSetProgress(int examSetId) async {
    final rankId = await _currentRankId();

    await (db.delete(db.userAnswers)..where(
          (t) => t.rankId.equals(rankId) & t.examSetId.equals(examSetId),
        ))
        .go();
    await (db.delete(db.examSetProgress)..where(
          (t) => t.rankId.equals(rankId) & t.examSetId.equals(examSetId),
        ))
        .go();
  }

  Future<Map<String, int>> getCriticalProgressStats() async {
    final rankId = await _currentRankId();
    final questionsResult = await db.select(db.questions).get();
    final userAnswersResult = await (db.select(
      db.userAnswers,
    )..where((t) => t.rankId.equals(rankId))).get();

    final answersByQuestionId = <int, UserAnswer>{};
    for (final answer in userAnswersResult) {
      final questionId = answer.questionId;
      if (questionId != null) {
        answersByQuestionId[questionId] = answer;
      }
    }

    final stats = {'total': 0, 'answered': 0, 'correct': 0, 'wrong': 0};

    for (final question in questionsResult) {
      if (!_questionMatchesRank(question, rankId)) continue;
      if (question.isCritical != 1) continue;

      stats['total'] = stats['total']! + 1;

      final answer = answersByQuestionId[question.id];
      if (answer == null) continue;

      stats['answered'] = stats['answered']! + 1;
      if (answer.isCorrect == 1) {
        stats['correct'] = stats['correct']! + 1;
      } else {
        stats['wrong'] = stats['wrong']! + 1;
      }
    }

    return stats;
  }
}
