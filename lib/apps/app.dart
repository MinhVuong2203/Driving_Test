// import 'package:driving_test_prep/widgets/loginwithgg.dart';
import 'package:driving_test_prep/core/database/DBProvider.dart';
import 'package:driving_test_prep/core/database/app_database.dart';
import 'package:driving_test_prep/core/database/daos/setting_dao.dart';
import 'package:driving_test_prep/core/database/seeds/seed_setting.dart';
import 'package:driving_test_prep/data/repository/setting_reponsitory.dart';
import 'package:driving_test_prep/shared/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  int? mode;

  @override
  void initState(){
    super.initState();
    loadSetting();
  }

  Future<void> loadSetting() async {
    late final db = DBProvider().db;
    final SettingRepository repo = SettingRepository(SettingDao(db));
    final setting = await repo.getSetting();

    if (setting == null) {
      await repo.insertDefault();
      mode = 1; // mặc định light
    } else {
      mode = setting.mode;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GPLX App",
      debugShowCheckedModeBanner: false,

      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

      themeMode: mode == 0 ? ThemeMode.dark : ThemeMode.light,

      home: const BottomNavBar(),
    );
  }
}

