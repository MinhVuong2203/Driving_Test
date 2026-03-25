import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/setting_dao.dart';

class SettingRepository {
  final SettingDao dao;
  SettingRepository(this.dao);

  Future<SettingData?> getSetting() {
    return dao.getSetting();
  }

  Future<void> insertDefault() async {
    await dao.insertDefault();
  }

  Future<void> updateMode(int mode) async {
    await dao.updateMode(mode);
  }

  Future<void> updateModels(int models) async {
    await dao.updateModels(models);
  }

  Future<void> updateVibration(int vibration) async {
    await dao.updateVibration(vibration);
  }

  Future<void> updateRankId(String rankId) async {
    await dao.updateRankId(rankId);
  }
}