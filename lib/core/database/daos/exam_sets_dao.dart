import 'package:driving_test_prep/core/database/app_database.dart';

class ExamSetsDao{
  final AppDatabase db;
  ExamSetsDao(this.db);

  // Lấy tất cả exam set dựa trên groupId
  Future<List<ExamSet>> getExamByGroup(int groupId){
    return (db.select(db.examSets)..where((t) => t.examGroupsId.equals(groupId))).get();
  }


}