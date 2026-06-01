import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class QuestionImageDownloadState {
  final bool isRunning;
  final int completed;
  final int total;

  const QuestionImageDownloadState({
    required this.isRunning,
    required this.completed,
    required this.total,
  });

  static const idle = QuestionImageDownloadState(
    isRunning: false,
    completed: 0,
    total: 0,
  );
}

class QuestionImageCacheService {
  QuestionImageCacheService._();

  static final QuestionImageCacheService instance =
      QuestionImageCacheService._();

  static const String _cloudinaryBaseUrl =
      'https://res.cloudinary.com/djfgmo94t/image/upload';
  static const String _folderName = 'img_questions';

  static final ValueNotifier<QuestionImageDownloadState> progress =
      ValueNotifier<QuestionImageDownloadState>(QuestionImageDownloadState.idle);

  static const List<String> _questionJsonFiles = [
    'assets/json/questions/questions_1_150.json',
    'assets/json/questions/questions_151_300.json',
    'assets/json/questions/questions_301_450.json',
    'assets/json/questions/questions_451_600.json',
  ];

  bool _started = false;
  Future<void>? _runningTask;

  void startBackgroundDownload() {
    if (_started) return;
    _started = true;
    _runningTask = _downloadMissingImages();
  }

  Future<File> localFileFor(String rawPath) async {
    final dir = await _imageDir();
    return File(p.join(dir.path, fileNameOf(rawPath)));
  }

  Future<File?> existingLocalFileFor(String rawPath) async {
    final file = await localFileFor(rawPath);
    return file.existsSync() ? file : null;
  }

  static String storagePathFor(String rawPath) {
    final fileName = fileNameOf(rawPath);
    return fileName.isEmpty ? '' : '$_folderName/$fileName';
  }

  static String fileNameOf(String rawPath) {
    final value = rawPath.trim();
    if (value.isEmpty) return '';

    final uri = Uri.tryParse(value);
    if (uri != null && uri.pathSegments.isNotEmpty) {
      return uri.pathSegments.last;
    }

    return p.basename(value);
  }

  static String cloudinaryUrlFor(String rawPath) {
    final fileName = fileNameOf(rawPath);
    return '$_cloudinaryBaseUrl/$fileName';
  }

  Future<void> waitForCurrentTask() async {
    await _runningTask;
  }

  Future<void> _downloadMissingImages() async {
    final imagePaths = await _loadQuestionImagePaths();
    final dir = await _imageDir();
    final targets = <String, File>{};

    for (final imagePath in imagePaths) {
      final fileName = fileNameOf(imagePath);
      if (fileName.isNotEmpty) {
        targets[fileName] = File(p.join(dir.path, fileName));
      }
    }

    final missing = targets.entries
        .where((entry) => !entry.value.existsSync())
        .toList(growable: false);

    if (missing.isEmpty) {
      progress.value = QuestionImageDownloadState.idle;
      return;
    }

    progress.value = QuestionImageDownloadState(
      isRunning: true,
      completed: 0,
      total: missing.length,
    );

    final client = http.Client();
    var completed = 0;

    try {
      for (final entry in missing) {
        await _downloadOne(client, entry.key, entry.value);
        completed++;
        progress.value = QuestionImageDownloadState(
          isRunning: true,
          completed: completed,
          total: missing.length,
        );
      }
    } finally {
      client.close();
      progress.value = QuestionImageDownloadState.idle;
    }
  }

  Future<void> _downloadOne(http.Client client, String fileName, File file) async {
    final uri = Uri.parse('$_cloudinaryBaseUrl/$fileName');
    final response = await client.get(uri).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
      return;
    }

    final tempFile = File('${file.path}.tmp');
    await tempFile.writeAsBytes(response.bodyBytes, flush: true);

    if (await file.exists()) {
      await file.delete();
    }

    await tempFile.rename(file.path);
  }

  Future<Set<String>> _loadQuestionImagePaths() async {
    final result = <String>{};

    for (final path in _questionJsonFiles) {
      final jsonString = await rootBundle.loadString(path);
      final decoded = jsonDecode(jsonString);

      if (decoded is! List) continue;

      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          final imageUrl = item['image_url'];
          if (imageUrl is String && imageUrl.trim().isNotEmpty) {
            result.add(imageUrl.trim());
          }
        }
      }
    }

    return result;
  }

  Future<Directory> _imageDir() async {
    final baseDir = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(baseDir.path, _folderName));

    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }

    return dir;
  }
}
