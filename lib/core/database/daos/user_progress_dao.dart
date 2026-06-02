import 'package:drift/drift.dart';
import '../app_database.dart';

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
    final query = db.select(db.questions).join([
      innerJoin(
        db.wrongQuestions,
        db.wrongQuestions.questionId.equalsExp(db.questions.id),
      ),
    ])..orderBy([OrderingTerm.desc(db.wrongQuestions.lastWrongAt)]);

    final rows = await query.get();
    return rows.map((row) => row.readTable(db.questions)).toList();
  }

  Future<int> countWrongQuestions() async {
    final rows = await db.select(db.wrongQuestions).get();
    return rows.length;
  }

  Future<void> logWrongAnswer(int questionId) async {
    final existing = await (db.select(
      db.wrongQuestions,
    )..where((t) => t.questionId.equals(questionId))).getSingleOrNull();
    if (existing != null) {
      await (db.update(
        db.wrongQuestions,
      )..where((t) => t.questionId.equals(questionId))).write(
        WrongQuestionsCompanion(
          wrongCount: Value(existing.wrongCount + 1),
          lastWrongAt: Value(DateTime.now()),
        ),
      );
    } else {
      await db
          .into(db.wrongQuestions)
          .insert(
            WrongQuestionsCompanion.insert(questionId: Value(questionId)),
          );
    }
  }

  Future<void> removeWrongQuestion(int questionId) async {
    await (db.delete(
      db.wrongQuestions,
    )..where((t) => t.questionId.equals(questionId))).go();
  }

  // 3. User Answers (Câu trả lời để tính tiến độ)
  Future<void> logAnswer(
    int questionId,
    String selectedAnswer,
    bool isCorrect,
  ) async {
    final rankId = await _currentRankId();
    final existing =
        await (db.select(db.userAnswers)..where(
              (t) => t.questionId.equals(questionId) & t.rankId.equals(rankId),
            ))
            .getSingleOrNull();
    if (existing != null) {
      await (db.update(db.userAnswers)..where(
            (t) => t.questionId.equals(questionId) & t.rankId.equals(rankId),
          ))
          .write(
            UserAnswersCompanion(
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
              questionId: Value(questionId),
              rankId: Value(rankId),
              selectedAnswer: Value(selectedAnswer),
              isCorrect: Value(isCorrect ? 1 : 0),
            ),
          );
    }
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
    final rankAnswers = userAnswersResult
        .where((answer) => rankQuestionIds.contains(answer.questionId))
        .toList();
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
