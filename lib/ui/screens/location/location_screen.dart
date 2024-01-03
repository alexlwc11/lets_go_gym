import 'package:flutter/material.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/ui/components/main_screen_sliver_app_bar.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            const MainScreenSliverAppBar(
              titleText: 'Name',
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [],
              ),
            ),
          ],
        ),
      );
}

// class _DetailsSection extends StatelessWidget {
//   final String address;
//   final String region;
//   final String district;
// }
