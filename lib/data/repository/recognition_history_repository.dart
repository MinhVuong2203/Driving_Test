import 'dart:io';
import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/recognition_history_dao.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class RecognitionHistoryRepository {
  final RecognitionHistoryDao dao;

  RecognitionHistoryRepository(this.dao);

  Future<int> saveRecognition({
    required String imagePath,
    required String result,
    String? signName,
    String? signType,
  }) async {
    final savedImagePath = await _saveImageToStorage(imagePath);

    final entry = RecognitionHistoryTableCompanion(
      imagePath: Value(savedImagePath),
      result: Value(result),
      signName: Value(signName),
      signType: Value(signType),
      createdAt: Value(DateTime.now()),
    );

    return dao.insertRecognitionHistory(entry);
  }

  Future<List<RecognitionHistoryData>> getAllHistory() {
    return dao.getAllRecognitionHistory();
  }

  Future<RecognitionHistoryData?> getHistoryById(int id) {
    return dao.getRecognitionHistoryById(id);
  }

  Future<List<RecognitionHistoryData>> getRecentHistory(int limit) {
    return dao.getRecentRecognitionHistory(limit);
  }

  Future<void> deleteHistory(int id) async {
    final history = await dao.getRecognitionHistoryById(id);
    if (history != null) {
      await _deleteImageFile(history.imagePath);
      await dao.deleteRecognitionHistory(id);
    }
  }

  Future<void> deleteAllHistory() async {
    final all = await dao.getAllRecognitionHistory();

    for (final item in all) {
      await _deleteImageFile(item.imagePath);
    }

    await dao.deleteAllRecognitionHistory();
  }

  Future<int> getTotalCount() async {
    final all = await dao.getAllRecognitionHistory();
    return all.length;
  }

  // ================= FILE =================

  Future<String> _saveImageToStorage(String sourcePath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final dir = Directory(p.join(appDir.path, 'traffic_signs'));

      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ext = p.extension(sourcePath);
      final fileName = 'sign_$timestamp$ext';
      final savedPath = p.join(dir.path, fileName);

      final file = File(sourcePath);
      await file.copy(savedPath);

      return savedPath;
    } catch (_) {
      return sourcePath;
    }
  }

  Future<void> _deleteImageFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }
}