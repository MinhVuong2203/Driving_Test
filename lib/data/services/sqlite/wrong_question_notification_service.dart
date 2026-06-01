import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/daos/user_progress_dao.dart';
import 'package:driving_test_prep/data/repository/user_progress_repository.dart';
import 'package:driving_test_prep/features/overlay/screens/wrong_question_reminder_overlay.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class WrongQuestionNotificationService {
  WrongQuestionNotificationService._();

  static final instance = WrongQuestionNotificationService._();

  static const _id = 901;
  static const _payload = 'wrong_question_reminder';

  final _plugin = FlutterLocalNotificationsPlugin();

  bool _pendingOpenOverlay = false;

  Future<void> init() async {
    tz.initializeTimeZones();

    final localTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimezone.identifier));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _handleTap,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    final response = launchDetails?.notificationResponse;

    if (launchDetails?.didNotificationLaunchApp == true &&
        response?.payload == _payload) {
      _pendingOpenOverlay = true;
    }
  }

  bool consumePendingOpenOverlay() {
    if (!_pendingOpenOverlay) return false;
    _pendingOpenOverlay = false;
    return true;
  }

  Future<void> scheduleIfHasWrongQuestionsAfter(Duration delay) async {
    final repo = UserProgressRepository(UserProgressDao(DBProvider().db));
    final wrongQuestions = await repo.getWrongQuestions();

    if (wrongQuestions.isEmpty) {
      await _plugin.cancel(id: _id);
      return;
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'wrong_question_reminder',
        'Nhắc ôn câu sai',
        channelDescription: 'Nhắc người dùng ôn lại các câu đã làm sai',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      id: _id,
      title: 'Đến giờ ôn lại câu sai',
      body: 'Bấm để làm nhanh một câu bạn từng trả lời sai.',
      scheduledDate: tz.TZDateTime.now(tz.local).add(delay),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: _payload,
    );
  }

  void _handleTap(NotificationResponse response) {
    if (response.payload != _payload) return;

    final overlayState = wrongQuestionReminderOverlayKey.currentState;

    if (overlayState == null) {
      _pendingOpenOverlay = true;
      return;
    }

    overlayState.showFromNotification();
  }
}