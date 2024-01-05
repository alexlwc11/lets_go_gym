import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/router.dart';
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

  Widget _buildItemTile(BuildContext context, _SettingsItem item) =>
      _SettingsItemTile(
        key: ValueKey(item.name),
        settingsItem: item,
        onTap: () {
          context.pushNamed(item.getScreenName());
        },
      );
}

class _SettingsItemTile extends StatelessWidget {
  final _SettingsItem settingsItem;
  final VoidCallback? onTap;

  const _SettingsItemTile({
    super.key,
    required this.settingsItem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: settingsItem.getScreenName(),
      child: Material(
        child: ListTile(
          leading: Icon(settingsItem.icon),
          title: Text(settingsItem.getTitleText(context)),
          titleTextStyle: Theme.of(context).textTheme.titleLarge,
          subtitle: Text(settingsItem.getSubtitleText(context)),
          onTap: onTap,
        ),
      ),
    );
  }
}

enum _SettingsItem {
  languages(Icons.translate),
  themes(Icons.brightness_4_outlined);

  final IconData icon;
  const _SettingsItem(this.icon);

  String getTitleText(BuildContext context) {
    switch (this) {
      case _SettingsItem.languages:
        return context.appLocalization.settingsScreen_languagesTitle;
      case _SettingsItem.themes:
        return context.appLocalization.settingsScreen_themesTitle;
    }
  }

  String getSubtitleText(BuildContext context) {
    switch (this) {
      case _SettingsItem.languages:
        return context.appLocalization.settingsScreen_languagesSubtitle;
      case _SettingsItem.themes:
        return context.appLocalization.settingsScreen_themesSubtitle;
    }
  }

  String getScreenName() {
    switch (this) {
      case _SettingsItem.languages:
        return ScreenDetails.languages.name;
      case _SettingsItem.themes:
        return ScreenDetails.themes.name;
    }
  }
}
