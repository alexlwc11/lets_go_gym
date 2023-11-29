import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_go_gym/ui/screens/entry_screen.dart';

typedef RouteBuilder = Widget Function(GoRouterState state);

class ScreenPaths {
  static String entry = '/entry';
  static String home = '/home';
  static String settings = '/settings';
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
// final GlobalKey<NavigatorState> _shellNavigatorKey =
//     GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: ScreenPaths.entry,
  routes: [
    GoRoute(
      path: ScreenPaths.entry,
      builder: (_, __) => const EntryScreen(),
    ),
  ],
);
