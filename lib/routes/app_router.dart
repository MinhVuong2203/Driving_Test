import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';

final GoRouter appRouter = GoRouter(

  initialLocation: "/centers",

  routes: [

    GoRoute(
      path: "/practice",

      pageBuilder: (context, state) => CustomTransitionPage(

        key: state.pageKey,

        child: const BottomNavBar(index: 0),

        transitionsBuilder: (context, animation, secondaryAnimation, child) {

          return FadeTransition(
            opacity: animation,
            child: child,
          );

        },

      ),
    ),

    GoRoute(
      path: "/centers",

      pageBuilder: (context, state) => CustomTransitionPage(

        key: state.pageKey,

        child: const BottomNavBar(index: 1),

        transitionsBuilder: (context, animation, secondaryAnimation, child) {

          return FadeTransition(
            opacity: animation,
            child: child,
          );

        },

      ),
    ),

    GoRoute(
      path: "/info",

      pageBuilder: (context, state) => CustomTransitionPage(

        key: state.pageKey,

        child: const BottomNavBar(index: 2),

        transitionsBuilder: (context, animation, secondaryAnimation, child) {

          return FadeTransition(
            opacity: animation,
            child: child,
          );

        },

      ),
    ),

  ],

);