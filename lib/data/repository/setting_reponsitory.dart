import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/setting_dao.dart';

class SettingRepository {
  final SettingDao dao;
  SettingRepository(this.dao);

  // Lấy tất cả topics (từ DB)
  Future<SettingData?> getSetting() {
    return dao.getSetting();
  }

  /// Insert setting mặc định
  Future<void> insertDefault() async {
    await dao.insertDefault();
  }

}