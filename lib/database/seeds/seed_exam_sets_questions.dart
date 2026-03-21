import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:driving_test_prep/database/app_database.dart';
import 'package:flutter/services.dart';

class SeedsExamSetQuestions {
  static Future<void> seedExamSetQuestions(AppDatabase db) async {
    final files = [
      'assets/json/exam_sets_questions/data_exam_sets_questions_1.json',
      'assets/json/exam_sets_questions/data_exam_sets_questions_2.json',
      'assets/json/exam_sets_questions/data_exam_sets_questions_3.json',
      'assets/json/exam_sets_questions/data_exam_sets_questions_4.json',
      'assets/json/exam_sets_questions/data_exam_sets_questions_5.json',
    ];

    for (final path in files) {
      final jsonString = await rootBundle.loadString(path);
      final List<dynamic> jsonData = json.decode(jsonString);

      await db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          db.examSetQuestions,
          jsonData.map((item) => ExamSetQuestionsCompanion.insert(
            examSetId: Value(item['exam_set_id']),
            questionId: Value(item['question_id']),
            questionOrder: Value(item['question_order']),
          )).toList(),
        );
      });
    }

    print("✅ Seed exam_set_questions (5 files) xong");
  }
}