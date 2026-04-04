import 'package:driving_test_prep/UserListPage.dart';
import 'package:driving_test_prep/apps/app.dart';
import 'package:driving_test_prep/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // runApp(
  //   const MaterialApp(
  //     home: UserListPage(),
  //   ),
  // );

  runApp(const MyApp());

}
