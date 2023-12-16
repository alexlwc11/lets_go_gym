import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_go_gym/di.dart' as di;
import 'package:lets_go_gym/ui/bloc/entry/entry_bloc.dart';
import 'package:lets_go_gym/ui/bloc/locations/locations_bloc.dart';
import 'package:lets_go_gym/ui/screens/entry_screen.dart';
import 'package:lets_go_gym/ui/screens/main_screen.dart';
import 'package:lets_go_gym/ui/screens/bookmarks/bookmarks_screen.dart';
import 'package:lets_go_gym/ui/screens/locations/locations_screen.dart';
import 'package:lets_go_gym/ui/screens/settings/settings_screen.dart';

typedef RouteBuilder = Widget Function(GoRouterState state);

class ScreenPaths {
  static String entry = '/entry';
  static String bookmarks = '/bookmarks';
  static String locations = '/locations';
  static String settings = '/settings';
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _bookmarksNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'bookmarks');
final GlobalKey<NavigatorState> _locationsNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'locations');
final GlobalKey<NavigatorState> _settingsNavigatorKey =
    GlobalKey(debugLabel: 'settings');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: ScreenPaths.entry,
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: ScreenPaths.entry,
      builder: (_, __) => BlocProvider.value(
        value: di.sl<EntryBloc>(),
        child: const EntryScreen(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state, child) {
        final path = state.fullPath ?? '';
        int selectedIndex = _getBottomTabBarIndexFromPath(path);

        return MainScreen(
          selectedIndex: selectedIndex,
          body: child,
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _bookmarksNavigatorKey,
          initialLocation: ScreenPaths.bookmarks,
          routes: [
            GoRoute(
              path: ScreenPaths.bookmarks,
              builder: (_, __) => const BookmarkScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _locationsNavigatorKey,
          initialLocation: ScreenPaths.locations,
          routes: [
            GoRoute(
              path: ScreenPaths.locations,
              builder: (_, __) => BlocProvider.value(
                value: di.sl<LocationsBloc>(),
                child: const LocationsScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          initialLocation: ScreenPaths.settings,
          routes: [
            GoRoute(
              path: ScreenPaths.settings,
              builder: (_, __) => const SettingsScreen(),
            ),
          ],
        )
      ],
    ),
  ],
);

int _getBottomTabBarIndexFromPath(String path) {
  if (path.contains(ScreenPaths.bookmarks)) {
    return 0;
  } else if (path.contains(ScreenPaths.locations)) {
    return 1;
  } else if (path.contains(ScreenPaths.settings)) {
    return 2;
  }

  return 0;
}
