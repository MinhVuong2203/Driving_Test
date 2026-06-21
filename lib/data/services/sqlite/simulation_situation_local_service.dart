import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/data/models/simulation_situation_model.dart';

class SimulationProgressSummary {
  final int situationId;
  final int bestScore;
  final double? bestFlagSecond;
  final int lastScore;
  final double? lastFlagSecond;
  final int attemptCount;
  final bool isCompleted;
  final DateTime? lastPracticedAt;

  const SimulationProgressSummary({
    required this.situationId,
    required this.bestScore,
    required this.bestFlagSecond,
    required this.lastScore,
    required this.lastFlagSecond,
    required this.attemptCount,
    required this.isCompleted,
    required this.lastPracticedAt,
  });
}

class SimulationAttemptHistory {
  final int id;
  final int situationId;
  final int score;
  final double flagSecond;
  final int duration;
  final DateTime createdAt;

  const SimulationAttemptHistory({
    required this.id,
    required this.situationId,
    required this.score,
    required this.flagSecond,
    required this.duration,
    required this.createdAt,
  });
}

class SimulationSituationLocalService {
  final AppDatabase db;

  SimulationSituationLocalService(this.db);

  bool _isReady = false;

  Future<void> ensureTables() async {
    if (_isReady) return;

    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS simulation_situations_cache (
        doc_id TEXT NOT NULL PRIMARY KEY,
        id INTEGER NOT NULL UNIQUE,
        title TEXT NOT NULL,
        chapter INTEGER NOT NULL,
        duration INTEGER NOT NULL,
        video_url TEXT NOT NULL,
        score_windows_json TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        data_version INTEGER NOT NULL DEFAULT 1,
        synced_at INTEGER NOT NULL
      )
    ''');

    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS simulation_progress (
        situation_id INTEGER NOT NULL PRIMARY KEY,
        best_score INTEGER NOT NULL DEFAULT 0,
        best_flag_second REAL NULL,
        last_score INTEGER NOT NULL DEFAULT 0,
        last_flag_second REAL NULL,
        attempt_count INTEGER NOT NULL DEFAULT 0,
        is_completed INTEGER NOT NULL DEFAULT 0,
        last_practiced_at INTEGER NULL
      )
    ''');

    await db.customStatement('''
      CREATE TABLE IF NOT EXISTS simulation_attempts (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        situation_id INTEGER NOT NULL,
        score INTEGER NOT NULL,
        flag_second REAL NOT NULL,
        duration INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_simulation_chapter '
      'ON simulation_situations_cache (chapter, id)',
    );
    await db.customStatement(
      'CREATE INDEX IF NOT EXISTS idx_simulation_attempts_situation '
      'ON simulation_attempts (situation_id, created_at)',
    );

    _isReady = true;
  }

  Future<List<SimulationSituation>> fetchAll() async {
    await ensureTables();

    final rows = await db
        .customSelect(
          '''
          SELECT *
          FROM simulation_situations_cache
          ORDER BY id ASC
          ''',
        )
        .get();

    return rows.map((row) => _situationFromRow(row.data)).toList();
  }

  Future<void> replaceAll(
    List<SimulationSituation> situations, {
    int dataVersion = 1,
  }) async {
    await ensureTables();
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.transaction(() async {
      await db.customStatement('DELETE FROM simulation_situations_cache');

      for (final situation in situations) {
        await db.customStatement(
          '''
          INSERT OR REPLACE INTO simulation_situations_cache (
            doc_id,
            id,
            title,
            chapter,
            duration,
            video_url,
            score_windows_json,
            is_active,
            data_version,
            synced_at
          )
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
          ''',
          [
            situation.docId,
            situation.id,
            situation.title,
            situation.chapter,
            situation.duration,
            situation.videoUrl,
            jsonEncode(
              situation.scoreWindows
                  .map(
                    (window) => {
                      'from': window.from,
                      'to': window.to,
                      'score': window.score,
                    },
                  )
                  .toList(),
            ),
            situation.isActive ? 1 : 0,
            dataVersion,
            now,
          ],
        );
      }
    });
  }

  Future<void> recordAttempt({
    required int situationId,
    required int score,
    required double flagSecond,
    required int duration,
  }) async {
    await ensureTables();
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.transaction(() async {
      await db.customStatement(
        '''
        INSERT INTO simulation_attempts (
          situation_id,
          score,
          flag_second,
          duration,
          created_at
        )
        VALUES (?, ?, ?, ?, ?)
        ''',
        [situationId, score, flagSecond, duration, now],
      );

      final existing = await db
          .customSelect(
            '''
            SELECT *
            FROM simulation_progress
            WHERE situation_id = ?
            LIMIT 1
            ''',
            variables: [Variable.withInt(situationId)],
          )
          .getSingleOrNull();

      if (existing == null) {
        await db.customStatement(
          '''
          INSERT INTO simulation_progress (
            situation_id,
            best_score,
            best_flag_second,
            last_score,
            last_flag_second,
            attempt_count,
            is_completed,
            last_practiced_at
          )
          VALUES (?, ?, ?, ?, ?, 1, ?, ?)
          ''',
          [
            situationId,
            score,
            flagSecond,
            score,
            flagSecond,
            score > 0 ? 1 : 0,
            now,
          ],
        );
        return;
      }

      final currentBestScore = _readInt(existing.data, 'best_score');
      final currentBestSecond = _readDouble(existing.data, 'best_flag_second');
      final isNewBest = score > currentBestScore ||
          (score == currentBestScore &&
              (currentBestSecond == null || flagSecond < currentBestSecond));

      await db.customStatement(
        '''
        UPDATE simulation_progress
        SET
          best_score = ?,
          best_flag_second = ?,
          last_score = ?,
          last_flag_second = ?,
          attempt_count = attempt_count + 1,
          is_completed = ?,
          last_practiced_at = ?
        WHERE situation_id = ?
        ''',
        [
          isNewBest ? score : currentBestScore,
          isNewBest ? flagSecond : currentBestSecond,
          score,
          flagSecond,
          score > 0 ? 1 : _readInt(existing.data, 'is_completed'),
          now,
          situationId,
        ],
      );
    });
  }

  Future<SimulationProgressSummary?> getProgress(int situationId) async {
    await ensureTables();

    final row = await db
        .customSelect(
          '''
          SELECT *
          FROM simulation_progress
          WHERE situation_id = ?
          LIMIT 1
          ''',
          variables: [Variable.withInt(situationId)],
        )
        .getSingleOrNull();

    if (row == null) return null;
    return _progressFromRow(row.data);
  }

  Future<Map<int, SimulationProgressSummary>> getProgressBySituationIds(
    List<int> situationIds,
  ) async {
    await ensureTables();
    if (situationIds.isEmpty) return {};

    final placeholders = List.filled(situationIds.length, '?').join(', ');
    final rows = await db
        .customSelect(
          '''
          SELECT *
          FROM simulation_progress
          WHERE situation_id IN ($placeholders)
          ''',
          variables: situationIds.map((id) => Variable.withInt(id)).toList(),
        )
        .get();

    return {
      for (final row in rows)
        _readInt(row.data, 'situation_id'): _progressFromRow(row.data),
    };
  }

  Future<List<SimulationAttemptHistory>> fetchAttempts(
    int situationId, {
    int limit = 20,
  }) async {
    await ensureTables();

    final rows = await db
        .customSelect(
          '''
          SELECT *
          FROM simulation_attempts
          WHERE situation_id = ?
          ORDER BY created_at DESC
          LIMIT ?
          ''',
          variables: [
            Variable.withInt(situationId),
            Variable.withInt(limit),
          ],
        )
        .get();

    return rows.map((row) => _attemptFromRow(row.data)).toList();
  }

  Future<List<SimulationAttemptHistory>> fetchRecentAttempts({
    int limit = 100,
  }) async {
    await ensureTables();

    final rows = await db
        .customSelect(
          '''
          SELECT *
          FROM simulation_attempts
          ORDER BY created_at DESC
          LIMIT ?
          ''',
          variables: [Variable.withInt(limit)],
        )
        .get();

    return rows.map((row) => _attemptFromRow(row.data)).toList();
  }

  Future<void> deleteAttempt(int attemptId) async {
    await ensureTables();

    await db.transaction(() async {
      final row = await db
          .customSelect(
            '''
            SELECT situation_id
            FROM simulation_attempts
            WHERE id = ?
            LIMIT 1
            ''',
            variables: [Variable.withInt(attemptId)],
          )
          .getSingleOrNull();

      if (row == null) return;

      final situationId = _readInt(row.data, 'situation_id');
      await db.customStatement(
        'DELETE FROM simulation_attempts WHERE id = ?',
        [attemptId],
      );
      await _rebuildProgressForSituation(situationId);
    });
  }

  Future<void> clearAttempts({int? situationId}) async {
    await ensureTables();

    await db.transaction(() async {
      if (situationId == null) {
        await db.customStatement('DELETE FROM simulation_attempts');
        await db.customStatement('DELETE FROM simulation_progress');
        return;
      }

      await db.customStatement(
        'DELETE FROM simulation_attempts WHERE situation_id = ?',
        [situationId],
      );
      await db.customStatement(
        'DELETE FROM simulation_progress WHERE situation_id = ?',
        [situationId],
      );
    });
  }

  SimulationSituation _situationFromRow(Map<String, Object?> row) {
    final rawWindows = row['score_windows_json']?.toString() ?? '[]';
    final decodedWindows = jsonDecode(rawWindows);

    return SimulationSituation.fromJson({
      'docId': row['doc_id'],
      'id': row['id'],
      'title': row['title'],
      'chapter': row['chapter'],
      'duration': row['duration'],
      'videoUrl': row['video_url'],
      'scoreWindows': decodedWindows is List ? decodedWindows : const [],
      'isActive': _readInt(row, 'is_active') == 1,
    });
  }

  Future<void> _rebuildProgressForSituation(int situationId) async {
    final rows = await db
        .customSelect(
          '''
          SELECT *
          FROM simulation_attempts
          WHERE situation_id = ?
          ORDER BY created_at ASC
          ''',
          variables: [Variable.withInt(situationId)],
        )
        .get();

    if (rows.isEmpty) {
      await db.customStatement(
        'DELETE FROM simulation_progress WHERE situation_id = ?',
        [situationId],
      );
      return;
    }

    final attempts = rows.map((row) => _attemptFromRow(row.data)).toList();
    final last = attempts.last;
    var best = attempts.first;
    for (final attempt in attempts.skip(1)) {
      final betterScore = attempt.score > best.score;
      final sameScoreEarlier =
          attempt.score == best.score && attempt.flagSecond < best.flagSecond;
      if (betterScore || sameScoreEarlier) {
        best = attempt;
      }
    }

    await db.customStatement(
      '''
      INSERT OR REPLACE INTO simulation_progress (
        situation_id,
        best_score,
        best_flag_second,
        last_score,
        last_flag_second,
        attempt_count,
        is_completed,
        last_practiced_at
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        situationId,
        best.score,
        best.flagSecond,
        last.score,
        last.flagSecond,
        attempts.length,
        attempts.any((attempt) => attempt.score > 0) ? 1 : 0,
        last.createdAt.millisecondsSinceEpoch,
      ],
    );
  }

  SimulationProgressSummary _progressFromRow(Map<String, Object?> row) {
    return SimulationProgressSummary(
      situationId: _readInt(row, 'situation_id'),
      bestScore: _readInt(row, 'best_score'),
      bestFlagSecond: _readDouble(row, 'best_flag_second'),
      lastScore: _readInt(row, 'last_score'),
      lastFlagSecond: _readDouble(row, 'last_flag_second'),
      attemptCount: _readInt(row, 'attempt_count'),
      isCompleted: _readInt(row, 'is_completed') == 1,
      lastPracticedAt: _readDateTime(row, 'last_practiced_at'),
    );
  }

  SimulationAttemptHistory _attemptFromRow(Map<String, Object?> row) {
    return SimulationAttemptHistory(
      id: _readInt(row, 'id'),
      situationId: _readInt(row, 'situation_id'),
      score: _readInt(row, 'score'),
      flagSecond: _readDouble(row, 'flag_second') ?? 0,
      duration: _readInt(row, 'duration'),
      createdAt: _readDateTime(row, 'created_at') ?? DateTime.now(),
    );
  }

  int _readInt(Map<String, Object?> row, String key) {
    final value = row[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double? _readDouble(Map<String, Object?> row, String key) {
    final value = row[key];
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  DateTime? _readDateTime(Map<String, Object?> row, String key) {
    final value = row[key];
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }
    if (value is String) {
      final millis = int.tryParse(value);
      if (millis != null) return DateTime.fromMillisecondsSinceEpoch(millis);
      return DateTime.tryParse(value);
    }
    return null;
  }
}
