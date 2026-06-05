import 'dart:async';

import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/daos/setting_dao.dart';
import 'package:driving_test_prep/data/services/sqlite/question_image_cache_service.dart';
import 'package:driving_test_prep/data/repository/setting_reponsitory.dart';
import 'package:driving_test_prep/data/repository/traffic_violation_repository.dart';
import 'package:driving_test_prep/data/services/sqlite/wrong_question_notification_service.dart';
import 'package:driving_test_prep/features/overlay/screens/wrong_question_reminder_overlay.dart';
import 'package:driving_test_prep/shared/utils/app_state_notifiers.dart';
import 'package:driving_test_prep/shared/widgets/bottom_nav_bar.dart';
import 'package:driving_test_prep/shared/widgets/question_data_download_banner.dart';
import 'package:flutter/material.dart';

final ValueNotifier<int> themeNotifier = ValueNotifier<int>(1);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    QuestionImageCacheService.instance.startBackgroundDownload();
    loadSetting();
  }

  void _startDeferredServices() {
    unawaited(_warmUpTrafficViolations());
  }

  Future<void> _warmUpTrafficViolations() async {
    try {
      await TrafficViolationRepository.localFirst().syncIfNeeded();
    } catch (_) {
      // Lần đầu chưa có mạng/backend thì màn tra cứu sẽ thử sync lại khi cần.
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(
        WrongQuestionNotificationService.instance.syncCurrentReminderState(),
      );
    }
  }

  Future<void> loadSetting() async {
    print('AppStartup: loadSetting start');
    final db = DBProvider().db;
    print('AppStartup: DBProvider ready');
    final SettingRepository repo = SettingRepository(SettingDao(db));
    print('AppStartup: getSetting start');
    final setting = await repo.getSetting();
    print('AppStartup: getSetting done, hasSetting=${setting != null}');

    if (setting == null) {
      print('AppStartup: insertDefault setting start');
      await repo.insertDefault();
      print('AppStartup: insertDefault setting done');
      themeNotifier.value = 1;
      rankNotifier.value = 'B';
    } else {
      themeNotifier.value = setting.mode;
      rankNotifier.value = setting.rankId.trim().toUpperCase();
    }

    print('AppStartup: set loaded true');
    setState(() => _loaded = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startDeferredServices();

      unawaited(
        Future.delayed(const Duration(milliseconds: 260), () {
          if (!mounted) return;

          final shouldOpen = WrongQuestionNotificationService.instance
              .consumePendingOpenOverlay();

          if (shouldOpen) {
            wrongQuestionReminderOverlayKey.currentState
                ?.showFromNotification();
          }

          unawaited(
            WrongQuestionNotificationService.instance
                .syncCurrentReminderState(),
          );
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return ValueListenableBuilder<int>(
      valueListenable: themeNotifier,
      builder: (context, modeValue, _) {
        return MaterialApp(
          title: "GPLX App",
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: modeValue == 0 ? ThemeMode.dark : ThemeMode.light,
          home: const BottomNavBar(),
          builder: (context, child) {
            return Stack(
              children: [
                if (child != null) child,
                const QuestionDataDownloadBanner(),
                WrongQuestionReminderOverlay(
                  key: wrongQuestionReminderOverlayKey,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
