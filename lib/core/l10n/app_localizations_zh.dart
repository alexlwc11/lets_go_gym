// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '做尖喇';

  @override
  String get entryScreen_pleaseUpdateToContinue => '唔該更新到最新版本先繼續用啦';

  @override
  String get entryScreen_update => '更新';

  @override
  String get entryScreen_failedToUpdate => '好似發生咗啲問題，麻煩你等一陣再試多次';

  @override
  String get entryScreen_retry => '試多次';

  @override
  String get entryScreen_fetchingSystemInfo => '幫緊你幫緊你...';

  @override
  String get entryScreen_updatingData => '更新中...';

  @override
  String get mainScreen_navBar_bookmarks => '收藏';

  @override
  String get mainScreen_navBar_locations => '地點';

  @override
  String get mainScreen_navBar_settings => '設定';

  @override
  String get bookmarksScreen_title => '收藏';

  @override
  String get bookmarksScreen_emptyTitle => '你可以喺依度搵到你嘅收藏';

  @override
  String get bookmarksScreen_emptyHints => '加個地點入收藏可以快啲搵到詳細資料';

  @override
  String get locationsScreen_title => '地點';

  @override
  String locationScreen_hourlyQuota(int hourlyQuota) {
    return '時票名額：$hourlyQuota';
  }

  @override
  String locationScreen_monthlyQuota(int monthlyQuota) {
    return '月票名額：$monthlyQuota';
  }

  @override
  String get locationsFilterModal_title => '過濾器';

  @override
  String get locationsFilterModal_regionsSection_title => '區域';

  @override
  String get locationsFilterModal_districtsSection_title => '地區';

  @override
  String get locationsFilterModal_filterLabel_all => '全部';

  @override
  String get locationScreen_addressCard_title => '地址';

  @override
  String get locationScreen_moreDetailsCard_title => '更多資料';

  @override
  String get settingsScreen_title => '設定';

  @override
  String get settingsScreen_languagesTitle => '語言';

  @override
  String get settingsScreen_languagesSubtitle => '喺依度轉顯示嘅語言';

  @override
  String get settingsScreen_themesTitle => '主題';

  @override
  String get settingsScreen_themesSubtitle => '喺依度轉主題';

  @override
  String get languagesScreen_title => '語言';

  @override
  String get languagesScreen_systemTitle => '系統語言';

  @override
  String get languagesScreen_enTitle => 'English';

  @override
  String get languagesScreen_zhTitle => '中文';

  @override
  String get themesScreen_title => '主題';

  @override
  String get themesScreen_systemTitle => '系統主題';

  @override
  String get themesScreen_lightTitle => '淺色';

  @override
  String get themesScreen_darkTitle => '深色';

  @override
  String get general_dot => ' • ';
}
