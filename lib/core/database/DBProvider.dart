import 'package:driving_test_prep/core/database/app_database.dart';

class DBProvider {
  static final DBProvider _instance = DBProvider._internal();

  late final AppDatabase db;

  factory DBProvider() {
    return _instance;
  }

  DBProvider._internal() {
    db = AppDatabase();
    print("✅ Đã tạo mới DB nè");
  }
}