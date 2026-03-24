import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/app_database.dart';


class SeedsSetting {
  static Future<void> seedsSetting(AppDatabase db) async {
    await db.into(db.setting).insert(
      SettingCompanion.insert(SettingId: 1, mode: Value(1))
    );
    print("✅ Setting xong");
  }
}