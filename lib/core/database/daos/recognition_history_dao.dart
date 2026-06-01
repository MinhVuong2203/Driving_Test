import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/app_database.dart';

class RecognitionHistoryDao {
  final AppDatabase db;

  RecognitionHistoryDao(this.db);

  Future<int> insertRecognitionHistory(RecognitionHistoryTableCompanion entry) {
    return db.into(db.recognitionHistoryTable).insert(entry);
  }

  Future<List<RecognitionHistoryData>> getAllRecognitionHistory() {
    return (db.select(db.recognitionHistoryTable)..orderBy([
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
        .get();
  }

  Future<RecognitionHistoryData?> getRecognitionHistoryById(int id) {
    return (db.select(
      db.recognitionHistoryTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<RecognitionHistoryData>> getRecentRecognitionHistory(int limit) {
    return (db.select(db.recognitionHistoryTable)
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .get();
  }

  Future<int> deleteRecognitionHistory(int id) {
    return (db.delete(
      db.recognitionHistoryTable,
    )..where((t) => t.id.equals(id))).go();
  }

  Future<int> deleteAllRecognitionHistory() {
    return db.delete(db.recognitionHistoryTable).go();
  }
}
