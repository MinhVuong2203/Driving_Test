import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/daos/setting_dao.dart';
import 'package:driving_test_prep/core/database/daos/user_progress_dao.dart';
import 'package:driving_test_prep/data/repository/setting_reponsitory.dart';
import 'package:driving_test_prep/data/repository/user_progress_repository.dart';
import 'package:driving_test_prep/features/overlay/screens/wrong_question_reminder_overlay.dart';
import 'package:driving_test_prep/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> wrongQuestionReminderBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class WrongQuestionNotificationService {
  WrongQuestionNotificationService._();

  static final instance = WrongQuestionNotificationService._();

  static const reminderType = 'wrong_question_reminder';

  final _messaging = FirebaseMessaging.instance;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  StreamSubscription<User?>? _authSub;
  StreamSubscription<String>? _tokenSub;
  StreamSubscription<RemoteMessage>? _openedSub;
  StreamSubscription<RemoteMessage>? _foregroundSub;

  bool _initialized = false;
  bool _pendingOpenOverlay = false;
  String? _lastSyncedUid;
  String? _lastSyncedToken;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    FirebaseMessaging.onBackgroundMessage(
      wrongQuestionReminderBackgroundHandler,
    );

    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final initialMessage = await _messaging.getInitialMessage();
    if (_isWrongReminderMessage(initialMessage)) {
      _pendingOpenOverlay = true;
    }

    _openedSub = FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);
    _foregroundSub = FirebaseMessaging.onMessage.listen((message) {
      if (_isWrongReminderMessage(message)) {
        _openOverlayOrMarkPending();
      }
    });

    _authSub = _auth.authStateChanges().listen((_) {
      unawaited(syncCurrentReminderState());
    });

    _tokenSub = _messaging.onTokenRefresh.listen((_) {
      unawaited(syncCurrentReminderState());
    });

    await syncCurrentReminderState(markDirtyOnFailure: false);
  }

  bool consumePendingOpenOverlay() {
    if (!_pendingOpenOverlay) return false;
    _pendingOpenOverlay = false;
    return true;
  }

  Future<void> syncCurrentReminderState({
    bool markDirtyOnFailure = true,
  }) async {
    final settingRepo = SettingRepository(SettingDao(DBProvider().db));
    final progressRepo = UserProgressRepository(
      UserProgressDao(DBProvider().db),
    );

    try {
      final user = _auth.currentUser;
      final setting = await settingRepo.getSetting();
      final enabled = await settingRepo.isWrongReminderEnabled();
      final wrongCount = await progressRepo.countWrongQuestions();
      final shouldRemind = enabled && wrongCount > 0;
      final token = await _messaging.getToken();

      if (user == null) {
        await _removeTokenFromLastUser(token);
        await settingRepo.markReminderSyncDirty();
        return;
      }

      if (_lastSyncedUid != null && _lastSyncedUid != user.uid) {
        await _removeTokenFromLastUser(token);
      }

      final lastSyncedReminderWrong =
          (setting?.lastSyncedReminderWrong ?? 0) == 1;
      final isDirty = (setting?.reminderSyncDirty ?? 1) == 1;
      final tokenChanged =
          token != null && token.trim().isNotEmpty && token != _lastSyncedToken;
      final userChanged = _lastSyncedUid != user.uid;

      if (!isDirty &&
          !tokenChanged &&
          !userChanged &&
          lastSyncedReminderWrong == shouldRemind) {
        return;
      }

      final userRef = _firestore.collection('users').doc(user.uid);

      final data = <String, dynamic>{
        'reminder_wrong': shouldRemind,
        'wrong_reminder_enabled': enabled,
        'reminder_synced_at': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (token != null && token.trim().isNotEmpty) {
        data['fcm_tokens'] = FieldValue.arrayUnion([token]);
      }

      await userRef.set(data, SetOptions(merge: true));
      _lastSyncedUid = user.uid;
      _lastSyncedToken = token;
      await settingRepo.markReminderSyncCleanWithValue(shouldRemind);
    } catch (_) {
      if (markDirtyOnFailure) {
        await settingRepo.markReminderSyncDirty();
      }
    }
  }

  Future<void> _removeTokenFromLastUser(String? token) async {
    final uid = _lastSyncedUid;
    if (uid == null || token == null || token.trim().isEmpty) return;

    await _firestore.collection('users').doc(uid).set({
      'fcm_tokens': FieldValue.arrayRemove([token]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    _lastSyncedUid = null;
    _lastSyncedToken = null;
  }

  Future<void> removeCurrentUserToken() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final token = await _messaging.getToken();
    if (token == null || token.trim().isEmpty) return;

    await _firestore.collection('users').doc(user.uid).set({
      'fcm_tokens': FieldValue.arrayRemove([token]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (_lastSyncedUid == user.uid && _lastSyncedToken == token) {
      _lastSyncedUid = null;
      _lastSyncedToken = null;
    }
  }

  bool _isWrongReminderMessage(RemoteMessage? message) {
    if (message == null) return false;
    return message.data['type'] == reminderType;
  }

  void _handleTap(RemoteMessage message) {
    if (!_isWrongReminderMessage(message)) return;
    _openOverlayOrMarkPending();
  }

  void _openOverlayOrMarkPending() {
    final overlayState = wrongQuestionReminderOverlayKey.currentState;

    if (overlayState == null) {
      _pendingOpenOverlay = true;
      return;
    }

    overlayState.showFromNotification();
  }

  Future<void> dispose() async {
    await _authSub?.cancel();
    await _tokenSub?.cancel();
    await _openedSub?.cancel();
    await _foregroundSub?.cancel();
  }
}
