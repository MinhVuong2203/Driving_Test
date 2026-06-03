import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:driving_test_prep/core/database/seeds/seed_exam_group.dart';
import 'package:driving_test_prep/core/database/seeds/seed_exam_sets.dart';
import 'package:driving_test_prep/core/database/seeds/seed_exam_sets_questions.dart';
import 'package:driving_test_prep/core/database/seeds/seed_questions.dart';
import 'package:driving_test_prep/core/database/seeds/seed_ranks.dart';
import 'package:driving_test_prep/core/database/seeds/seed_setting.dart';
import 'package:driving_test_prep/core/database/seeds/seed_traffic_signs.dart';
import 'package:driving_test_prep/core/database/seeds/seeds_topics.dart';
import 'package:driving_test_prep/core/database/tables/recognition_history_table.dart';
import 'package:driving_test_prep/core/database/tables/setting_table.dart';
import 'package:driving_test_prep/core/database/tables/saved_questions_table.dart';
import 'package:driving_test_prep/core/database/tables/traffic_signs_table.dart';
import 'package:driving_test_prep/core/database/tables/traffic_violations_table.dart';
import 'package:driving_test_prep/core/database/tables/driving_centers_table.dart';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/topics_table.dart';
import 'tables/questions_table.dart';
import 'tables/exam_groups_table.dart';
import 'tables/ranks_table.dart';
import 'tables/exam_sets_table.dart';
import 'tables/exam_set_questions_table.dart';
import 'tables/practice_sessions_table.dart';
import 'tables/user_answers_table.dart';
import 'tables/wrong_questions_table.dart';
import 'tables/exam_history_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Topics,
    Questions,
    ExamGroups,
    Ranks,
    ExamSets,
    ExamSetQuestions,
    PracticeSessions,
    UserAnswers,
    WrongQuestions,
    ExamHistory,
    TrafficSigns,
    Setting,
    RecognitionHistoryTable,
    SavedQuestions,
    TrafficViolationRecords,
    DrivingCenterRecords,
    DrivingCenterPageCaches,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  bool get logStatements => kDebugMode;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();

      await SeedsSetting.seedsSetting(this);
      await SeedsTopics.seedTopics(this);
      await SeedsExamGroups.seedExamGroups(this);
      await SeedsRanks.seedRanks(this);
      await SeedsQuestions.seedQuestions(this);
      await SeedsExamSets.seedExamSets(this);
      await SeedsExamSetQuestions.seedExamSetQuestions(this);
      await SeedsTrafficSigns.seedTrafficSigns(this);
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        final tableRows = await customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table'",
        ).get();
        final tableNames = tableRows
            .map((row) => row.data['name'] as String?)
            .whereType<String>()
            .toSet();

        if (!tableNames.contains('wrong_questions')) {
          await m.createTable(wrongQuestions);
        }
        if (!tableNames.contains('saved_questions')) {
          await m.createTable(savedQuestions);
        }
      }

      if (from < 3) {
        final settingColumns = await customSelect(
          "PRAGMA table_info(setting)",
        ).get();
        final columnNames = settingColumns
            .map((row) => row.data['name'] as String?)
            .whereType<String>()
            .toSet();

        if (!columnNames.contains('wrong_reminder_enabled')) {
          await m.addColumn(setting, setting.wrongReminderEnabled);
        }
        if (!columnNames.contains('reminder_sync_dirty')) {
          await m.addColumn(setting, setting.reminderSyncDirty);
        }
      }

      if (from < 4) {
        final settingColumns = await customSelect(
          "PRAGMA table_info(setting)",
        ).get();
        final columnNames = settingColumns
            .map((row) => row.data['name'] as String?)
            .whereType<String>()
            .toSet();

        if (!columnNames.contains('last_synced_reminder_wrong')) {
          await m.addColumn(setting, setting.lastSyncedReminderWrong);
        }
      }

      if (from < 5) {
        final userAnswerColumns = await customSelect(
          "PRAGMA table_info(user_answers)",
        ).get();
        final columnNames = userAnswerColumns
            .map((row) => row.data['name'] as String?)
            .whereType<String>()
            .toSet();

        if (!columnNames.contains('rank_id')) {
          await m.addColumn(userAnswers, userAnswers.rankId);
        }

        await customStatement("""
        UPDATE user_answers
        SET rank_id = (
          SELECT rank_id
          FROM setting
          WHERE setting_id = 1
        )
        WHERE rank_id IS NULL
      """);
      }

      if (from < 6) {
        final tableRows = await customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table'",
        ).get();
        final tableNames = tableRows
            .map((row) => row.data['name'] as String?)
            .whereType<String>()
            .toSet();

        if (!tableNames.contains('traffic_violation_records')) {
          await m.createTable(trafficViolationRecords);
        }
      }

      if (from < 7) {
        final tableRows = await customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table'",
        ).get();
        final tableNames = tableRows
            .map((row) => row.data['name'] as String?)
            .whereType<String>()
            .toSet();

        if (!tableNames.contains('driving_center_records')) {
          await m.createTable(drivingCenterRecords);
        }
        if (!tableNames.contains('driving_center_page_caches')) {
          await m.createTable(drivingCenterPageCaches);
        }
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'gplx_app.db'));

    return NativeDatabase.createInBackground(file);
  });
}
