import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FcmService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> initAndSaveToken(String uid) async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _messaging.getToken();

    if (token != null) {
      await _saveToken(uid, token);
    }

    _messaging.onTokenRefresh.listen((newToken) async {
      await _saveToken(uid, newToken);
    });
  }

  static Future<void> _saveToken(String uid, String token) async {
    await _db.collection('users').doc(uid).set({
      'fcm_tokens': FieldValue.arrayUnion([token]),
      'updatedAt': DateTime.now(),
    }, SetOptions(merge: true));
  }
}