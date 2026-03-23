import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/app_database.dart';

import 'package:flutter/services.dart';

class SeedsExamGroups {
  static Future<void> seedExamGroups(AppDatabase db) async {
    final jsonString = await rootBundle
        .loadString('assets/json/exam_groups/data_exam_groups.json');

    final List<dynamic> jsonData = json.decode(jsonString);

    for (final item in jsonData) {
      await db.into(db.examGroups).insert(
        ExamGroupsCompanion.insert(
          examGroupsId: Value(item['exam_groups_id']),
          name: Value(item['name']),
          totalQuestions: Value(item['total_questions']),
        ),
      );
    }
    print("✅ Seed exam_groups xong");
  }
}