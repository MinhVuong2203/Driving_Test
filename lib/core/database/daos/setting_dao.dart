import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:drift/drift.dart';

class SettingDao {
  final AppDatabase db;
  SettingDao(this.db);

  Future<SettingData?> getSetting() {
    return (db.select(db.setting)..where((s) => s.SettingId.equals(1)))
        .getSingleOrNull();
  }

  Future<void> insertDefault() async {
    await db.into(db.setting).insert(
      SettingCompanion.insert(
        SettingId: 1,
        rankId: const Value('B'),
        models: const Value(0),
        vibration: const Value(1),
        mode: const Value(1),
        wrongReminderEnabled: const Value(1),
        reminderSyncDirty: const Value(1),
        lastSyncedReminderWrong: const Value(0),
      ),
      mode: InsertMode.insertOrIgnore, // ✅ Không ghi đè nếu đã tồn tại
    );
  }

  Future<void> updateMode(int mode) async {
    await (db.update(db.setting)..where((s) => s.SettingId.equals(1)))
        .write(SettingCompanion(mode: Value(mode)));
  }

  Future<void> updateModels(int models) async {
    await (db.update(db.setting)..where((s) => s.SettingId.equals(1)))
        .write(SettingCompanion(models: Value(models)));
  }

  Future<void> updateVibration(int vibration) async {
    await (db.update(db.setting)..where((s) => s.SettingId.equals(1)))
        .write(SettingCompanion(vibration: Value(vibration)));
  }

  Future<void> updateRankId(String rankId) async {
    await (db.update(db.setting)..where((s) => s.SettingId.equals(1)))
        .write(SettingCompanion(rankId: Value(rankId)));
  }

  Future<bool> isWrongReminderEnabled() async {
    final setting = await getSetting();
    return (setting?.wrongReminderEnabled ?? 1) == 1;
  }

  Future<void> updateWrongReminderEnabled(bool enabled) async {
    await (db.update(db.setting)..where((s) => s.SettingId.equals(1))).write(
      SettingCompanion(
        wrongReminderEnabled: Value(enabled ? 1 : 0),
        reminderSyncDirty: const Value(1),
      ),
    );
  }

  Future<void> markReminderSyncDirty() async {
    await (db.update(db.setting)..where((s) => s.SettingId.equals(1))).write(
      const SettingCompanion(reminderSyncDirty: Value(1)),
    );
  }

  Future<void> markReminderSyncClean() async {
    await (db.update(db.setting)..where((s) => s.SettingId.equals(1))).write(
      const SettingCompanion(reminderSyncDirty: Value(0)),
    );
  }

  Future<void> markReminderSyncCleanWithValue(bool reminderWrong) async {
    await (db.update(db.setting)..where((s) => s.SettingId.equals(1))).write(
      SettingCompanion(
        reminderSyncDirty: const Value(0),
        lastSyncedReminderWrong: Value(reminderWrong ? 1 : 0),
      ),
    );
  }
}
