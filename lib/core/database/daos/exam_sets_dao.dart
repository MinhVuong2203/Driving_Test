import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/app_database.dart';

class ExamSetsDao{
  final AppDatabase db;
  ExamSetsDao(this.db);

  // Lấy tất cả exam set dựa trên groupId
  Future<List<ExamSet>> getExamByGroup(int groupId){
    return (db.select(db.examSets)..where((t) => t.examGroupsId.equals(groupId))).get();
  }

  Future<List<ExamSet>> getExamByRank(String rankId) async {
    // B1: lấy examGroupId từ rank
    final rank = await (db.select(db.ranks)
      ..where((tbl) => tbl.rankId.equals(rankId)))
        .getSingleOrNull();
    if (rank == null) return [];
    return getExamByGroup(rank.examGroupsId!);
  }

}