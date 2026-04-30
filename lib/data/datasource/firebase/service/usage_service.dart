import 'dart:convert';
import 'package:driving_test_prep/shared/utils/constants/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class UsageService {
  final String baseUrl = AppConfig.baseUrl;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Future<bool> canUseRecognition() async {
    print('---------------$baseUrl/api/usage/can-use-recognition/$_uid');
    final res = await http.post(
      Uri.parse('$baseUrl/api/usage/can-use-recognition/$_uid'),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    return false;
  }

  Future<int> getRemainingRecognition() async {
    final res = await http.get(
      Uri.parse('$baseUrl/api/usage/remaining/$_uid'),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    return 0;
  }
}