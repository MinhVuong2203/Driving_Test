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
}