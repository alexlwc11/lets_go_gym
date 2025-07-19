// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Let\'s go gym';

  @override
  String get entryScreen_pleaseUpdateToContinue =>
      'Please update to latest version first';

  @override
  String get entryScreen_update => 'Update';

  @override
  String get entryScreen_failedToUpdate =>
      'Something went wrong, please try again later';

  @override
  String get entryScreen_retry => 'Retry';

  @override
  String get entryScreen_fetchingSystemInfo => 'Fetching system info...';

  @override
  String get entryScreen_updatingData => 'Updating data...';

  @override
  String get mainScreen_navBar_bookmarks => 'Bookmarks';

  @override
  String get mainScreen_navBar_locations => 'Locations';

  @override
  String get mainScreen_navBar_settings => 'Settings';

  @override
  String get bookmarksScreen_title => 'Bookmarks';

  @override
  String get bookmarksScreen_emptyTitle => 'You\'ll find your bookmarks here';

  @override
  String get bookmarksScreen_emptyHints =>
      'Add location to bookmarks to check the details quickly';

  @override
  String get locationsScreen_title => 'Locations';

  @override
  String locationScreen_hourlyQuota(int hourlyQuota) {
    return 'Hourly quota: $hourlyQuota';
  }

  @override
  String locationScreen_monthlyQuota(int monthlyQuota) {
    return 'Monthly quota: $monthlyQuota';
  }

  @override
  String get locationsFilterModal_title => 'Filter';

  @override
  String get locationsFilterModal_regionsSection_title => 'Regions';

  @override
  String get locationsFilterModal_districtsSection_title => 'Districts';

  @override
  String get locationsFilterModal_filterLabel_all => 'All';

  @override
  String get locationScreen_addressCard_title => 'Address';

  @override
  String get locationScreen_moreDetailsCard_title => 'More details';

  @override
  String get settingsScreen_title => 'Settings';

  @override
  String get settingsScreen_languagesTitle => 'Languages';

  @override
  String get settingsScreen_languagesSubtitle => 'Change the app language here';

  @override
  String get settingsScreen_themesTitle => 'Themes';

  @override
  String get settingsScreen_themesSubtitle => 'Change the app theme here';

  @override
  String get languagesScreen_title => 'Languages';

  @override
  String get languagesScreen_systemTitle => 'System language';

  @override
  String get languagesScreen_enTitle => 'English';

  @override
  String get languagesScreen_zhTitle => '中文';

  @override
  String get themesScreen_title => 'Themes';

  @override
  String get themesScreen_systemTitle => 'System theme';

  @override
  String get themesScreen_lightTitle => 'Light';

  @override
  String get themesScreen_darkTitle => 'Dark';

  @override
  String get general_dot => ' • ';
}
