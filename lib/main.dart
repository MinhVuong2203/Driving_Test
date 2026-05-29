import 'package:driving_test_prep/UserListPage.dart';
import 'package:driving_test_prep/apps/app.dart';
import 'package:driving_test_prep/apps/app_test.dart';
import 'package:driving_test_prep/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Luồng chính
  runApp(const MyApp());

  // Để test UserListPage
  // runApp(
  //   const MaterialApp(
  //     home: UserListPage(),
  //   ),
  // );



  //runApp(const MyAppTest());

}
