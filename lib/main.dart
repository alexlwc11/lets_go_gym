import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/core/utils/theme_helper.dart';
import 'package:lets_go_gym/data/datasources/remote/api/auth_manager.dart';
import 'package:lets_go_gym/ui/bloc/languages/language_settings_cubit.dart';
import 'package:lets_go_gym/ui/bloc/themes/theme_settings_cubit.dart';
import 'router.dart';
import 'di.dart' as di;

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await di.init();

    await di.sl<AuthManager>().clearSecureStorageOnReinstall();

    runApp(const MainApp());
  }, (error, stack) {
    log('$error - $stack');
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: di.sl<LanguageSettingsCubit>()),
        BlocProvider.value(value: di.sl<ThemeSettingsCubit>()),
      ],
      child: _App(),
    );
  }
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.appLocalization.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: getBrightnessFromThemeCode(
                  context.watch<ThemeSettingsCubit>().state) ??
              MediaQuery.platformBrightnessOf(context),
        ),
      ),
      locale:
          _getLocaleFromLangCode(context.watch<LanguageSettingsCubit>().state),
      routeInformationProvider: appRouter.routeInformationProvider,
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
    );
  }

  Locale? _getLocaleFromLangCode(String langCode) {
    return switch (langCode) {
      '' => null,
      _ => AppLocalizations.supportedLocales
              .firstWhereOrNull((locale) => locale.languageCode == langCode) ??
          AppLocalizations.supportedLocales.first
    };
  }
}
