import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/exam_sets_quest_dao.dart';

class ExamSetsQuestRepository {
  final ExamSetsQuestDao dao;
  ExamSetsQuestRepository(this.dao);

  // Lấy tất cả câu hỏi dựa trên examSetId (từ DB)
  Future<List<ExamQuestionView>> getQuestionsByExamSet(int examSetId) {
    return dao.getExamQuestions(examSetId);
  }

  // Lấy tất cả câu hỏi dựa trên topicId (từ DB)
  // Future<List<ExamQuestionView>> getQuestionsByTopic(int topicId) {
  //   return dao.getExamQuestionsByTopic(topicId);
  // }
  Future<List<Question>> getQuestionsByTopic(int topicId) {
    return dao.getQuestionsByTopic(topicId);
  }


  // Lấy thông tin của topic dựa trên topicId (từ DB)
  Future<Topic?> getTopicInfo(int topicId) {
    return dao.getTopicById(topicId);
  }
}