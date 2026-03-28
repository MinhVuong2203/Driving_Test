import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/app_database.dart';

class TrafficSignsDao {
  final AppDatabase db;
  TrafficSignsDao(this.db);

  /// Lấy tất cả biển báo theo category, sắp xếp theo signId
  Future<List<TrafficSign>> getByCategory(String category) {
    return (db.select(db.trafficSigns)
      ..where((t) => t.category.equals(category))
      ..orderBy([(t) => OrderingTerm.asc(t.signId)]))
        .get();
  }

  /// Tìm kiếm trong một category theo tên hoặc mã biển
  Future<List<TrafficSign>> searchInCategory(
      String category, String query) {
    final q = '%${query.toLowerCase()}%';
    return (db.select(db.trafficSigns)
      ..where((t) =>
      t.category.equals(category) &
      (t.name.lower().like(q) | t.signId.lower().like(q)))
      ..orderBy([(t) => OrderingTerm.asc(t.signId)]))
        .get();
  }
}