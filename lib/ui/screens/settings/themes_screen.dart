import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/core/utils/theme_helper.dart';
import 'package:lets_go_gym/ui/bloc/themes/theme_settings_cubit.dart';
import 'package:lets_go_gym/ui/components/main_screen_sliver_app_bar.dart';

class ThemesScreen extends StatelessWidget {
  const ThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MainScreenSliverAppBar(
            titleText: context.appLocalization.themesScreen_title,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildItemTile(
                  context,
                  ThemeItem.values[index],
                  context.watch<ThemeSettingsCubit>().state),
              childCount: ThemeItem.values.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(
          BuildContext context, ThemeItem item, currentThemeCode) =>
      _ThemeItemTile(
        key: ValueKey(item.name),
        themeItem: item,
        isSelected: currentThemeCode == item.themeCode,
        onTap: () {
          context.read<ThemeSettingsCubit>().updateSettings(item.themeCode);
        },
      );
}

class _ThemeItemTile extends StatelessWidget {
  final ThemeItem themeItem;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ThemeItemTile({
    super.key,
    required this.themeItem,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: isSelected ? Theme.of(context).colorScheme.surfaceVariant : null,
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        leading: Icon(getIcon(themeItem)),
        title: Text(getTitleText(context, themeItem)),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        trailing: isSelected ? const Icon(Icons.check) : null,
        selected: isSelected,
        onTap: () {
          if (isSelected) return;

          onTap?.call();
        },
      ),
    );
  }

  String getTitleText(BuildContext context, ThemeItem themeItem) {
    return switch (themeItem) {
      ThemeItem.system => context.appLocalization.themesScreen_systemTitle,
      ThemeItem.light => context.appLocalization.themesScreen_lightTitle,
      ThemeItem.dark => context.appLocalization.themesScreen_darkTitle,
    };
  }

  IconData getIcon(ThemeItem themeItem) {
    return switch (themeItem) {
      ThemeItem.system => Icons.brightness_4_outlined,
      ThemeItem.light => Icons.light_mode,
      ThemeItem.dark => Icons.dark_mode,
    };
  }
}
