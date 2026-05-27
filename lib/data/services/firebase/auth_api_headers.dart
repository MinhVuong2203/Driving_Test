import 'package:firebase_auth/firebase_auth.dart';

class AuthApiHeaders {
  static Future<Map<String, String>> bearer() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();

    if (token == null || token.isEmpty) {
      throw StateError('User must be signed in to call this API.');
    }

    return {
      'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, String>> json() async {
    return {
      'Content-Type': 'application/json',
      ...await bearer(),
    };
  }
}
