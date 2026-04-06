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
import 'package:driving_test_prep/core/database/tables/traffic_signs_table.dart';

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

@DriftDatabase(tables: [
  Topics, Questions, ExamGroups, Ranks, ExamSets,
  ExamSetQuestions, PracticeSessions, UserAnswers,
  WrongQuestions, ExamHistory, TrafficSigns, Setting,
  RecognitionHistoryTable
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection()){
    // print("✅ AppDatabase CREATED: ${identityHashCode(Sthis)}");
  }

  @override
  int get schemaVersion => 1;

  @override
  bool get logStatements => kDebugMode;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // 👇 SEED DATA
      await SeedsSetting.seedsSetting(this);
      await SeedsTopics.seedTopics(this);
      await SeedsExamGroups.seedExamGroups(this);
      await SeedsRanks.seedRanks(this);
      await SeedsQuestions.seedQuestions(this);
      await SeedsExamSets.seedExamSets(this);
      await SeedsExamSetQuestions.seedExamSetQuestions(this);
      await SeedsTrafficSigns.seedTrafficSigns(this);
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'gplx_app.db'));

    // // Xóa db cũ mỗi lần mở app — CHỈ DÙNG KHI DEV
    // if (await file.exists()) {
    //   await file.delete();
    //   print('✅ Đã xóa DB cũ');
    // }


    return NativeDatabase.createInBackground(file);
  });
}

