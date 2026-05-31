import 'package:drift/drift.dart';
import '../app_database.dart';

class UserProgressDao {
  final AppDatabase db;
  UserProgressDao(this.db);

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
    final existing = await (db.select(
      db.userAnswers,
    )..where((t) => t.questionId.equals(questionId))).getSingleOrNull();
    if (existing != null) {
      await (db.update(
        db.userAnswers,
      )..where((t) => t.questionId.equals(questionId))).write(
        UserAnswersCompanion(
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
              selectedAnswer: Value(selectedAnswer),
              isCorrect: Value(isCorrect ? 1 : 0),
            ),
          );
    }
  }

  // 4. Progress Stats
  Future<Map<String, int>> getProgressStats() async {
    final totalQuestionsResult = await db.select(db.questions).get();
    final totalQuestions = totalQuestionsResult.length;

    final userAnswersResult = await db.select(db.userAnswers).get();
    final answeredQuestions = userAnswersResult.length;
    final correctAnswers = userAnswersResult
        .where((a) => a.isCorrect == 1)
        .length;
    final wrongAnswers = answeredQuestions - correctAnswers;

    return {
      'total': totalQuestions,
      'answered': answeredQuestions,
      'correct': correctAnswers,
      'wrong': wrongAnswers,
    };
  }
}
