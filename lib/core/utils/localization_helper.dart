import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LocalizationHelper on BuildContext {
  AppLocalizations get appLocalization => AppLocalizations.of(this)!;
}

String getLocalizedString(
  String langCode, {
  required String en,
  String? zh,
}) {
  if (zh == null) return en;

  switch (langCode) {
    case 'en':
      return en;
    case 'zh':
      return zh;
    default:
      return en;
  }
}
