import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';

class SettingDao{
  final AppDatabase db;
  SettingDao(this.db);

  Future<SettingData?> getSetting(){
    return (db.select(db.setting)..where((s) => s.SettingId.equals(1))).getSingleOrNull();
  }
  /// Insert setting mặc định
  Future<void> insertDefault() async {
    await db.into(db.setting).insert(
      SettingCompanion.insert(SettingId: 1));
  }
}