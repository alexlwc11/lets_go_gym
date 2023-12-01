import 'package:flutter/material.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO implement
    return Scaffold(
      appBar: AppBar(
        title: Text(context.appLocalization.settingsScreen_title),
      ),
      body: const Placeholder(),
    );
  }
}
