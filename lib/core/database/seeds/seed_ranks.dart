import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:flutter/services.dart';

class SeedsRanks {
  static Future<void> seedRanks(AppDatabase db) async {
    final jsonString = await rootBundle
        .loadString('assets/json/ranks/data_ranks.json');

    final List<dynamic> jsonData = json.decode(jsonString);

    for (final item in jsonData) {
      await db.into(db.ranks).insert(
        RanksCompanion.insert(
          rankId: item['rank_id'],
          name: item['name'],
          description: Value(item['description']),
          totalQuestions: Value(item['total_questions']),
          totalExam: Value(item['total_exam']),
          totalPass: Value(item['total_pass']),
          time: Value(item['time']),
          examGroupsId: Value(item['exam_groups_id']),
        ),
      );
    }

    print("✅ Seed ranks xong");
  }
}