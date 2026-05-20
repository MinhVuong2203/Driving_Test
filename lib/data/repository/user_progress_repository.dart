import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/user_progress_dao.dart';

class UserProgressRepository {
  final UserProgressDao dao;
  UserProgressRepository(this.dao);

  Future<List<Question>> getSavedQuestions() => dao.getSavedQuestions();
  Future<bool> isQuestionSaved(int questionId) => dao.isQuestionSaved(questionId);
  Future<void> toggleSavedQuestion(int questionId) => dao.toggleSavedQuestion(questionId);

  Future<List<Question>> getWrongQuestions() => dao.getWrongQuestions();
  Future<void> logWrongAnswer(int questionId) => dao.logWrongAnswer(questionId);
  Future<void> removeWrongQuestion(int questionId) => dao.removeWrongQuestion(questionId);

  Future<void> logAnswer(int questionId, String selectedAnswer, bool isCorrect) {
    return dao.logAnswer(questionId, selectedAnswer, isCorrect);
  }

  Future<Map<String, int>> getProgressStats() => dao.getProgressStats();
}
