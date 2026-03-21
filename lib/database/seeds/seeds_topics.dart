import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:driving_test_prep/database/app_database.dart';
import 'package:flutter/services.dart';

class SeedsTopics {
  static Future<void> seedTopics(AppDatabase db) async {
    final jsonString =
    await rootBundle.loadString('assets/json/topics/data_topics.json');

    final List<dynamic> jsonData = json.decode(jsonString);

    for (final item in jsonData) {
      await db.into(db.topics).insert(
        TopicsCompanion.insert(
          id: item['id'],
          name: item['name'],
          fullname: item['fullname'],
          description: Value(item['description']),
        ),
      );
    }
    print("✅ Seed topics xong");
  }
}