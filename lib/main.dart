import 'package:driving_test_prep/apps/app.dart';
import 'package:driving_test_prep/database/app_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  // 👇 Trigger mở DB
  await db.select(db.topics).get();


  runApp(const MyApp());
}