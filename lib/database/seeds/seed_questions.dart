import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:driving_test_prep/database/app_database.dart';
import 'package:flutter/services.dart';

class SeedsQuestions {
  static Future<void> seedQuestions(AppDatabase db) async {
    final files = [
      'assets/json/questions/questions_1_150.json',
      'assets/json/questions/questions_151_300.json',
      'assets/json/questions/questions_301_450.json',
      'assets/json/questions/questions_451_600.json',
    ];

    for (final path in files) {
      final jsonString = await rootBundle.loadString(path);
      final List<dynamic> jsonData = json.decode(jsonString);

      for (final item in jsonData) {
        await db.into(db.questions).insert(
          QuestionsCompanion.insert(
            id: item['id'],
            topicId: Value(item['topic_id']),
            question: item['question'],
            imageUrl: Value(item['image_url']),
            answerA: Value(item['answer_a']),
            answerB: Value(item['answer_b']),
            answerC: Value(item['answer_c']),
            answerD: Value(item['answer_d']),
            ofRankA: Value(item['ofRankA'] ?? 0),
            ofRankB1: Value(item['ofRankB1'] ?? 0),
            correctAnswer: item['correct_answer'],
            explanation: Value(item['explanation']),
            isCritical: Value(item['is_critical'] ?? 0),
          ),
        );
      }
    }

    print("✅ Seed questions xong (4 files)");
  }
}