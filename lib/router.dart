import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_go_gym/di.dart' as di;
import 'package:lets_go_gym/ui/bloc/bookmarks/bookmarks_bloc.dart';
import 'package:lets_go_gym/ui/bloc/entry/entry_bloc.dart';
import 'package:lets_go_gym/ui/bloc/location/location_bloc.dart';
import 'package:lets_go_gym/ui/bloc/locations/locations_bloc.dart';
import 'package:lets_go_gym/ui/cubits/locations_fliter/locations_filter_cubit.dart';
import 'package:lets_go_gym/ui/screens/entry_screen.dart';
import 'package:lets_go_gym/ui/screens/location/location_screen.dart';
import 'package:lets_go_gym/ui/screens/main_screen.dart';
import 'package:lets_go_gym/ui/screens/bookmarks/bookmarks_screen.dart';
import 'package:lets_go_gym/ui/screens/locations/locations_screen.dart';
import 'package:lets_go_gym/ui/screens/settings/language_screen.dart';
import 'package:lets_go_gym/ui/screens/settings/settings_screen.dart';
import 'package:lets_go_gym/ui/screens/settings/themes_screen.dart';

typedef RouteBuilder = Widget Function(GoRouterState state);

class ScreenDetails {
  final String name;
  final String path;

  const ScreenDetails({required this.name, required this.path});

  static const entry = ScreenDetails(name: 'entry', path: _ScreenPaths.entry);
  static const bookmarks =
      ScreenDetails(name: 'bookmarks', path: _ScreenPaths.bookmarks);
  static const locations =
      ScreenDetails(name: 'locations', path: _ScreenPaths.locations);
  static const location =
      ScreenDetails(name: 'location', path: _ScreenPaths.location);
  static const settings =
      ScreenDetails(name: 'settings', path: _ScreenPaths.settings);
  static const languages =
      ScreenDetails(name: 'settings-languages', path: _ScreenPaths.languages);
  static const themes =
      ScreenDetails(name: 'settings-themes', path: _ScreenPaths.themes);
}

class _ScreenPaths {
  static const String entry = '/entry';
  static const String bookmarks = '/bookmarks';
  static const String locations = '/locations';
  static const String location = '/locations/:sports_center_id';
  static const String settings = '/settings';
  static const String languages = '$settings/languages';
  static const String themes = '$settings/themes';
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
  initialLocation: ScreenDetails.entry.path,
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: ScreenDetails.entry.name,
      path: ScreenDetails.entry.path,
      builder: (_, __) => BlocProvider.value(
        value: di.sl<EntryBloc>(),
        child: const EntryScreen(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state, child) {
        final path = state.fullPath ?? '';
        final selectedIndex = _getBottomTabBarIndexFromPath(path);

        return MainScreen(
          selectedIndex: selectedIndex,
          body: child,
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _bookmarksNavigatorKey,
          initialLocation: ScreenDetails.bookmarks.path,
          routes: [
            GoRoute(
              name: ScreenDetails.bookmarks.name,
              path: ScreenDetails.bookmarks.path,
              builder: (_, __) => BlocProvider.value(
                value: di.sl<BookmarksBloc>(),
                child: const BookmarksScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _locationsNavigatorKey,
          initialLocation: ScreenDetails.locations.path,
          routes: [
            GoRoute(
              name: ScreenDetails.locations.name,
              path: ScreenDetails.locations.path,
              builder: (_, __) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: di.sl<LocationsBloc>()),
                  BlocProvider.value(value: di.sl<LocationsFilterCubit>()),
                ],
                child: const LocationsScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _settingsNavigatorKey,
          initialLocation: ScreenDetails.settings.path,
          routes: [
            GoRoute(
              name: ScreenDetails.settings.name,
              path: ScreenDetails.settings.path,
              builder: (_, __) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: ScreenDetails.location.name,
      path: ScreenDetails.location.path,
      builder: (_, state) {
        final sportsCenterId =
            int.parse(state.pathParameters['sports_center_id']!);
        final heroTag = switch (state.extra) {
          'fromLocations' => 'locations-$sportsCenterId',
          'fromBookmarks' => 'bookmarks-$sportsCenterId',
          _ => '$sportsCenterId',
        };

        return Hero(
          tag: heroTag,
          child: BlocProvider.value(
            value: di.sl.get<LocationBloc>(param1: sportsCenterId),
            child: const LocationScreen(),
          ),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: ScreenDetails.languages.name,
      path: ScreenDetails.languages.path,
      builder: (context, __) => Hero(
        tag: ScreenDetails.languages.name,
        child: const LanguageScreen(),
      ),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      name: ScreenDetails.themes.name,
      path: ScreenDetails.themes.path,
      builder: (context, __) => Hero(
        tag: ScreenDetails.themes.name,
        child: const ThemesScreen(),
      ),
    )
  ],
);

int _getBottomTabBarIndexFromPath(String path) {
  if (path.contains(ScreenDetails.bookmarks.path)) {
    return 0;
  } else if (path.contains(ScreenDetails.locations.path)) {
    return 1;
  } else if (path.contains(ScreenDetails.settings.path)) {
    return 2;
  }

  return 0;
}
