import 'package:text_recognition_mlkit/screens/Image_to_text.dart';
import 'package:go_router/go_router.dart';
import 'package:text_recognition_mlkit/screens/history.dart';
import 'package:text_recognition_mlkit/screens/settings.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String home = '/';
  static const String history = 'history';
  static const String settings = 'settings';
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: Routes.home,
      builder: (BuildContext context, GoRouterState state) {
        return const ImageToTextScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: Routes.history,
          builder: (BuildContext context, GoRouterState state) {
            return const HistoryScreen();
          },
        ),
         GoRoute(
          path: Routes.settings,
          builder: (BuildContext context, GoRouterState state) {
            return const Settings();
          },
        ),
      ],
    ),
  ],
);