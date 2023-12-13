import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  final double _appBarExpandedHeight = 120;

  final ScrollController _scrollController = ScrollController();

  bool get _isSliverAppBarExpanded =>
      _scrollController.hasClients &&
      _scrollController.offset > (_appBarExpandedHeight - kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar.large(
            pinned: true,
            centerTitle: true,
            automaticallyImplyLeading: false,
            expandedHeight: _appBarExpandedHeight,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              collapseMode: CollapseMode.pin,
              title: Text(
                context.appLocalization.settingsScreen_title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              _SettingsItem.values.map(_buildItemTile).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemTile(_SettingsItem item) => ListTile(
        leading: Icon(item.icon),
        title: Text(item.getTitleText(context)),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        subtitle: Text(item.getSubtitleText(context)),
        // TODO display the current locale
        onTap: () {},
      );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
