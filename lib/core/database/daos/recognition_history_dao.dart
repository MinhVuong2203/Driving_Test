import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/app_database.dart';

class RecognitionHistoryDao {
  final AppDatabase db;

  RecognitionHistoryDao(this.db);

  // 🔹 Insert
  Future<int> insertRecognitionHistory(RecognitionHistoryTableCompanion entry) {
    return db.into(db.recognitionHistoryTable).insert(entry);
  }

  // 🔹 Get all
  Future<List<RecognitionHistoryData>> getAllRecognitionHistory() {
    return (db.select(db.recognitionHistoryTable)
      ..orderBy([
            (t) => OrderingTerm(
            expression: t.createdAt, mode: OrderingMode.desc)
      ]))
        .get();
  }

  // 🔹 Get by id
  Future<RecognitionHistoryData?> getRecognitionHistoryById(int id) {
    return (db.select(db.recognitionHistoryTable)
      ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // 🔹 Get recent
  Future<List<RecognitionHistoryData>> getRecentRecognitionHistory(int limit) {
    return (db.select(db.recognitionHistoryTable)
      ..orderBy([
            (t) => OrderingTerm(
            expression: t.createdAt, mode: OrderingMode.desc)
      ])
      ..limit(limit))
        .get();
  }

  // 🔹 Delete by id
  Future<int> deleteRecognitionHistory(int id) {
    return (db.delete(db.recognitionHistoryTable)
      ..where((t) => t.id.equals(id)))
        .go();
  }

  // 🔹 Delete all
  Future<int> deleteAllRecognitionHistory() {
    return db.delete(db.recognitionHistoryTable).go();
  }
}