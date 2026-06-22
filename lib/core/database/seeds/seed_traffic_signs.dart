import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:flutter/services.dart';

class SeedsTrafficSigns {
  static Future<void> seedTrafficSigns(AppDatabase db) async {
    final jsonString = await rootBundle
        .loadString('assets/json/traffic_signs/traffic_signs.json');
    final List<dynamic> jsonData = json.decode(jsonString);

    final rows = jsonData.map((item) {
      return TrafficSignsCompanion.insert(
        signId: item['sign_id'],
        category: item['category'],
        name: item['name'],
        description: Value(item['description']),
        imageUrl: Value(item['image_url']),
      );
    }).toList();

    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(db.trafficSigns, rows);
    });

    print("Seed traffic_signs xong (${rows.length} biển báo)");
  }
}
