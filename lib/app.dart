import 'package:driving_test_prep/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'widgets/bottom_nav_bar.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "GPLX App",
      theme: ThemeData.dark(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}