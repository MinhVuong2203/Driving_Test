import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/user_progress_dao.dart';

class UserProgressRepository {
  final UserProgressDao dao;
  UserProgressRepository(this.dao);

  Future<List<Question>> getSavedQuestions() => dao.getSavedQuestions();
  Future<bool> isQuestionSaved(int questionId) =>
      dao.isQuestionSaved(questionId);
  Future<void> toggleSavedQuestion(int questionId) =>
      dao.toggleSavedQuestion(questionId);

  Future<List<Question>> getWrongQuestions() => dao.getWrongQuestions();
  Future<int> countWrongQuestions() => dao.countWrongQuestions();
  Future<void> logWrongAnswer(int questionId) => dao.logWrongAnswer(questionId);
  Future<void> removeWrongQuestion(int questionId) =>
      dao.removeWrongQuestion(questionId);

  Future<void> logAnswer(
    int questionId,
    String selectedAnswer,
    bool isCorrect, {
    int? examSetId,
  }) {
    return dao.logAnswer(
      questionId,
      selectedAnswer,
      isCorrect,
      examSetId: examSetId,
    );
  }

  Future<Map<String, int>> getProgressStats() => dao.getProgressStats();
  Future<Map<int, Map<String, int>>> getTopicProgressStats() =>
      dao.getTopicProgressStats();
  Future<Map<int, String>> getExamSetSavedAnswers(int examSetId) =>
      dao.getExamSetSavedAnswers(examSetId);
  Future<int?> getExamSetRemainingSeconds(int examSetId) =>
      dao.getExamSetRemainingSeconds(examSetId);
  Future<void> saveExamSetRemainingSeconds(
    int examSetId,
    int remainingSeconds,
  ) => dao.saveExamSetRemainingSeconds(examSetId, remainingSeconds);
  Future<void> saveExamSetResult({
    required int examSetId,
    required int totalQuestions,
    required int correctAnswers,
    required bool isPassed,
    required int remainingSeconds,
  }) => dao.saveExamSetResult(
    examSetId: examSetId,
    totalQuestions: totalQuestions,
    correctAnswers: correctAnswers,
    isPassed: isPassed,
    remainingSeconds: remainingSeconds,
  );
  Future<ExamSetResultSummary?> getExamSetResultSummary(int examSetId) =>
      dao.getExamSetResultSummary(examSetId);
  Future<Map<int, ExamSetResultSummary>> getExamSetResultSummaries(
    List<int> examSetIds,
  ) => dao.getExamSetResultSummaries(examSetIds);
  Future<Map<int, Map<String, int>>> getExamSetProgressStats(
    List<int> examSetIds,
  ) => dao.getExamSetProgressStats(examSetIds);
  Future<Map<String, int>> getExamSetProgressStatsById(int examSetId) =>
      dao.getExamSetProgressStatsById(examSetId);
  Future<void> resetExamSetProgress(int examSetId) =>
      dao.resetExamSetProgress(examSetId);
  Future<Map<String, int>> getCriticalProgressStats() =>
      dao.getCriticalProgressStats();
}
