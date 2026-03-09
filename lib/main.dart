import 'package:driving_test_prep/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseHelper.instance.database;
  runApp(MyApp());
}

void testDB() async {

  await DatabaseHelper.instance.insertQuestion({

    "question": "Biển nào cấm rẽ trái?",
    "optionA": "Biển 1",
    "optionB": "Biển 2",
    "optionC": "Biển 3",
    "optionD": "Biển 4",
    "correctAnswer": "A",
    "topic": "Biển báo"

  });

}