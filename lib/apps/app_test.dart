// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:driving_test_prep/apps/app.dart';
import 'package:driving_test_prep/features/recognition_ai/screens/recognition_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:driving_test_prep/main.dart';


class MyAppTest extends StatelessWidget {
  const MyAppTest({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RecognitionHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
