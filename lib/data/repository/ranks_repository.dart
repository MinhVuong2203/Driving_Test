import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/ranks_dao.dart';

class RanksRepository {
  final RanksDao dao;
  RanksRepository(this.dao);

  // Lấy tất cả topics (từ DB)
  Future<Rank> getRankById(String rankId) {
    return dao.getRankById(rankId);
  }
}