import 'package:flutter/material.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO implement
    return Scaffold(
      appBar: AppBar(
        title: Text(context.appLocalization.locationScreen_title),
      ),
      body: const Placeholder(),
    );
  }
}
