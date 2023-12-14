import 'package:flutter/material.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/ui/components/main_screen_sliver_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MainScreenSliverAppBar(
            titleText: context.appLocalization.settingsScreen_title,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  _buildItemTile(context, _SettingsItem.values[index]),
              childCount: _SettingsItem.values.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, _SettingsItem item) => ListTile(
        leading: Icon(item.icon),
        title: Text(item.getTitleText(context)),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        subtitle: Text(item.getSubtitleText(context)),
        onTap: () => _settingsItemOnTap(context, item),
      );

  void _settingsItemOnTap(BuildContext context, _SettingsItem item) {
    // TODO implement
  }
}

enum _SettingsItem {
  language(Icons.translate),
  theme(Icons.brightness_4_outlined);

  final IconData icon;
  const _SettingsItem(this.icon);

  String getTitleText(BuildContext context) {
    switch (this) {
      case _SettingsItem.language:
        return context.appLocalization.settingsScreen_languageTitle;
      case _SettingsItem.theme:
        return context.appLocalization.settingsScreen_themeTitle;
    }
  }

  String getSubtitleText(BuildContext context) {
    switch (this) {
      case _SettingsItem.language:
        return context.appLocalization.settingsScreen_languageSubtitle;
      case _SettingsItem.theme:
        return context.appLocalization.settingsScreen_themeSubtitle;
    }
  }
}
