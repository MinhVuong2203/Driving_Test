import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/exam_sets_dao.dart';


class ExamSetsRepository {
  final ExamSetsDao dao;
  ExamSetsRepository(this.dao);

  // Lấy tất cả exam dựa trên groupId (từ DB)
  Future<List<ExamSet>> getExamByGroup(int groupId) {
    return dao.getExamByGroup(groupId);
  }


}