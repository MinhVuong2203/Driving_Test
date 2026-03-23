import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:flutter/services.dart';

class SeedsExamSets {
  static Future<void> seedExamSets(AppDatabase db) async {
    final files = [
      'assets/json/exam_sets/data_exam_sets_1.json',
      'assets/json/exam_sets/data_exam_sets_2.json',
      'assets/json/exam_sets/data_exam_sets_3.json',
      'assets/json/exam_sets/data_exam_sets_4.json',
      'assets/json/exam_sets/data_exam_sets_5.json',
    ];

    for (final path in files) {
      final jsonString = await rootBundle.loadString(path);
      final List<dynamic> jsonData = json.decode(jsonString);

      for (final item in jsonData) {
        await db.into(db.examSets).insertOnConflictUpdate(
          ExamSetsCompanion.insert(
            id: Value(item['id']),
            examGroupsId: item['exam_groups_id'],
            name: Value(item['name']),
          ),
        );
      }
    }

    print("✅ Seed exam_sets (5 files) xong");
  }
}