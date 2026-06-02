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

  Future<bool> isWrongReminderEnabled() {
    return dao.isWrongReminderEnabled();
  }

  Future<void> updateWrongReminderEnabled(bool enabled) {
    return dao.updateWrongReminderEnabled(enabled);
  }

  Future<void> markReminderSyncDirty() {
    return dao.markReminderSyncDirty();
  }

  Future<void> markReminderSyncClean() {
    return dao.markReminderSyncClean();
  }

  Future<void> markReminderSyncCleanWithValue(bool reminderWrong) {
    return dao.markReminderSyncCleanWithValue(reminderWrong);
  }
}
