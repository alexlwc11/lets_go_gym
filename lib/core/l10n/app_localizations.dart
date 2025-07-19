import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go gym'**
  String get appTitle;

  /// No description provided for @entryScreen_pleaseUpdateToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please update to latest version first'**
  String get entryScreen_pleaseUpdateToContinue;

  /// No description provided for @entryScreen_update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get entryScreen_update;

  /// No description provided for @entryScreen_failedToUpdate.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again later'**
  String get entryScreen_failedToUpdate;

  /// No description provided for @entryScreen_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get entryScreen_retry;

  /// No description provided for @entryScreen_fetchingSystemInfo.
  ///
  /// In en, this message translates to:
  /// **'Fetching system info...'**
  String get entryScreen_fetchingSystemInfo;

  /// No description provided for @entryScreen_updatingData.
  ///
  /// In en, this message translates to:
  /// **'Updating data...'**
  String get entryScreen_updatingData;

  /// No description provided for @mainScreen_navBar_bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get mainScreen_navBar_bookmarks;

  /// No description provided for @mainScreen_navBar_locations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get mainScreen_navBar_locations;

  /// No description provided for @mainScreen_navBar_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get mainScreen_navBar_settings;

  /// No description provided for @bookmarksScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarksScreen_title;

  /// No description provided for @bookmarksScreen_emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ll find your bookmarks here'**
  String get bookmarksScreen_emptyTitle;

  /// No description provided for @bookmarksScreen_emptyHints.
  ///
  /// In en, this message translates to:
  /// **'Add location to bookmarks to check the details quickly'**
  String get bookmarksScreen_emptyHints;

  /// No description provided for @locationsScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locationsScreen_title;

  /// Hourly quota title
  ///
  /// In en, this message translates to:
  /// **'Hourly quota: {hourlyQuota}'**
  String locationScreen_hourlyQuota(int hourlyQuota);

  /// Monthly quota title
  ///
  /// In en, this message translates to:
  /// **'Monthly quota: {monthlyQuota}'**
  String locationScreen_monthlyQuota(int monthlyQuota);

  /// No description provided for @locationsFilterModal_title.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get locationsFilterModal_title;

  /// No description provided for @locationsFilterModal_regionsSection_title.
  ///
  /// In en, this message translates to:
  /// **'Regions'**
  String get locationsFilterModal_regionsSection_title;

  /// No description provided for @locationsFilterModal_districtsSection_title.
  ///
  /// In en, this message translates to:
  /// **'Districts'**
  String get locationsFilterModal_districtsSection_title;

  /// No description provided for @locationsFilterModal_filterLabel_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get locationsFilterModal_filterLabel_all;

  /// No description provided for @locationScreen_addressCard_title.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get locationScreen_addressCard_title;

  /// No description provided for @locationScreen_moreDetailsCard_title.
  ///
  /// In en, this message translates to:
  /// **'More details'**
  String get locationScreen_moreDetailsCard_title;

  /// No description provided for @settingsScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsScreen_title;

  /// No description provided for @settingsScreen_languagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get settingsScreen_languagesTitle;

  /// No description provided for @settingsScreen_languagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change the app language here'**
  String get settingsScreen_languagesSubtitle;

  /// No description provided for @settingsScreen_themesTitle.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get settingsScreen_themesTitle;

  /// No description provided for @settingsScreen_themesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change the app theme here'**
  String get settingsScreen_themesSubtitle;

  /// No description provided for @languagesScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languagesScreen_title;

  /// No description provided for @languagesScreen_systemTitle.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get languagesScreen_systemTitle;

  /// No description provided for @languagesScreen_enTitle.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languagesScreen_enTitle;

  /// No description provided for @languagesScreen_zhTitle.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languagesScreen_zhTitle;

  /// No description provided for @themesScreen_title.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themesScreen_title;

  /// No description provided for @themesScreen_systemTitle.
  ///
  /// In en, this message translates to:
  /// **'System theme'**
  String get themesScreen_systemTitle;

  /// No description provided for @themesScreen_lightTitle.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themesScreen_lightTitle;

  /// No description provided for @themesScreen_darkTitle.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themesScreen_darkTitle;

  /// No description provided for @general_dot.
  ///
  /// In en, this message translates to:
  /// **' • '**
  String get general_dot;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
