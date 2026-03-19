import 'package:driving_test_prep/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'apps/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper.instance.database;
  runApp(MyApp());
}