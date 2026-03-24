import 'package:driving_test_prep/core/database/app_database.dart';

class RanksDao{
  final AppDatabase db;
  RanksDao(this.db);

  // Lấy rank thông qua rankId
  Future<Rank> getRankById(String rankId){
    return (db.select(db.ranks)..where((r) => r.rankId.equals(rankId))).getSingle();
  }

}