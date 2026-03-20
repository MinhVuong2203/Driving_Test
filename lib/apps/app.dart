// import 'package:driving_test_prep/widgets/loginwithgg.dart';
import 'package:driving_test_prep/widgets/loginwithgg.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "GPLX App",
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      // home: const GoogleLoginScreen(),
      home: const BottomNavBar(),
    );

  }

}