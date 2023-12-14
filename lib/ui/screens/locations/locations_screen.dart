import 'package:flutter/material.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/ui/components/main_screen_sliver_app_bar.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO implement
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MainScreenSliverAppBar(
            titleText: context.appLocalization.locationsScreen_title,
          ),
          const SliverFillRemaining(child: Placeholder()),
        ],
      ),
    );
  }
}
