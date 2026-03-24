import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/exam_sets_quest_dao.dart';

class ExamSetsQuestRepository {
  final ExamSetsQuestDao dao;
  ExamSetsQuestRepository(this.dao);

  // Lấy tất cả câu hỏi dựa trên examSetId (từ DB)
  Future<List<ExamQuestionView>> getQuestionsByExamSet(int examSetId) {
    return dao.getExamQuestions(examSetId);
  }
}