import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/setting_dao.dart';
import 'package:driving_test_prep/core/database/seeds/seed_setting.dart';
import 'package:driving_test_prep/data/repository/setting_reponsitory.dart';
import 'package:driving_test_prep/shared/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

final ValueNotifier<int> themeNotifier = ValueNotifier<int>(1);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    loadSetting();
  }

  Future<void> loadSetting() async {
    final db = DBProvider().db;
    final SettingRepository repo = SettingRepository(SettingDao(db));
    final setting = await repo.getSetting();

    if (setting == null) {
      await repo.insertDefault();
      themeNotifier.value = 1;
    } else {
      themeNotifier.value = setting.mode; // 👈 gán vào notifier
    }

    setState(() => _loaded = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // 👇 Lắng nghe thay đổi từ SettingsScreen
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
        );
      },
    );
  }
}