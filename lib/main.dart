import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lets_go_gym/core/utils/helper/clear_storage_helper.dart';
import 'package:lets_go_gym/core/utils/localization/localization_helper.dart';
import 'package:lets_go_gym/core/utils/theme/theme_helper.dart';
import 'package:lets_go_gym/ui/bloc/languages/language_settings_cubit.dart';
import 'package:lets_go_gym/ui/bloc/themes/theme_settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/router/router.dart';
import 'core/di/di.dart' as di;

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await di.init();

    await clearSecureStorageOnReinstall(
      secureStorage: di.sl<FlutterSecureStorage>(),
      sharedPreferences: di.sl<SharedPreferences>(),
    );

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
