import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/ui/bloc/languages/language_settings_cubit.dart';
import 'package:lets_go_gym/ui/components/main_screen_sliver_app_bar.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MainScreenSliverAppBar(
            titleText: context.appLocalization.languagesScreen_title,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildItemTile(
                  context,
                  _LanguagesItem.values[index],
                  context.watch<LanguageSettingsCubit>().state),
              childCount: _LanguagesItem.values.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(
          BuildContext context, _LanguagesItem item, currentLangCode) =>
      _LanguagesItemTile(
        key: ValueKey(item.name),
        languagesItem: item,
        isSelected: currentLangCode == item.langCode,
        onTap: () {
          context.read<LanguageSettingsCubit>().updateSettings(item.langCode);
        },
      );
}

class _LanguagesItemTile extends StatelessWidget {
  final _LanguagesItem languagesItem;
  final bool isSelected;
  final VoidCallback? onTap;

  const _LanguagesItemTile({
    super.key,
    required this.languagesItem,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: isSelected
          ? Theme.of(context).colorScheme.surfaceContainerHighest
          : null,
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        title: Text(getTitleText(context)),
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

  String getTitleText(BuildContext context) {
    switch (languagesItem) {
      case _LanguagesItem.system:
        return context.appLocalization.languagesScreen_systemTitle;
      case _LanguagesItem.en:
        return context.appLocalization.languagesScreen_enTitle;
      case _LanguagesItem.zh:
        return context.appLocalization.languagesScreen_zhTitle;
    }
  }
}

enum _LanguagesItem {
  system(''),
  en('en'),
  zh('zh');

  final String langCode;
  const _LanguagesItem(this.langCode);
}
