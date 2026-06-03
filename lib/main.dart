import 'package:driving_test_prep/apps/app.dart';
import 'package:driving_test_prep/data/services/sqlite/wrong_question_notification_service.dart';
import 'package:driving_test_prep/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'data/services/firebase/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotificationService.init();
  await WrongQuestionNotificationService.instance.init();

  // Luong chinh
  runApp(const MyApp());
}
