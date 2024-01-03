import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/router.dart';

class MainScreen extends StatelessWidget {
  final int selectedIndex;
  final Widget body;

  const MainScreen({
    super.key,
    required this.selectedIndex,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: NavigationBar(
        key: const Key('bottomNavBar'),
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) =>
            _onNavBarSelectedIndexChanged(context, index),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.bookmarks_outlined),
            selectedIcon: const Icon(Icons.bookmarks_rounded),
            label: context.appLocalization.mainScreen_navBar_bookmarks,
          ),
          NavigationDestination(
            icon: const Icon(Icons.location_on_outlined),
            selectedIcon: const Icon(Icons.location_on),
            label: context.appLocalization.mainScreen_navBar_locations,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: context.appLocalization.mainScreen_navBar_settings,
          ),
        ],
      ),
      body: body,
    );
  }

  void _onNavBarSelectedIndexChanged(BuildContext context, int index) {
    final String destination = switch (index) {
      0 => ScreenDetails.bookmarks.path,
      1 => ScreenDetails.locations.path,
      2 => ScreenDetails.settings.path,
      _ => throw ('Invalid index value')
    };

    context.go(destination);
  }
}
