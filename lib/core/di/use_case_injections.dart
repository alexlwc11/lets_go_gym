import 'package:lets_go_gym/core/di/di.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_app_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_current_data_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_district_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_region_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_sports_center_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/get_current_language_settings.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/get_current_theme_settings.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/update_language_settings.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/update_theme_settings.dart';
import 'package:lets_go_gym/domain/usecases/auth/get_device_uuid.dart';
import 'package:lets_go_gym/domain/usecases/auth/get_stored_session_token.dart';
import 'package:lets_go_gym/domain/usecases/auth/refresh_session_token.dart';
import 'package:lets_go_gym/domain/usecases/auth/register_new_user.dart';
import 'package:lets_go_gym/domain/usecases/auth/save_device_uuid.dart';
import 'package:lets_go_gym/domain/usecases/auth/save_session_token.dart';
import 'package:lets_go_gym/domain/usecases/auth/user_sign_in.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/add_bookmark.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/check_if_bookmarked.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/check_if_bookmarked_as_stream.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/get_all_bookmarks.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/get_all_bookmarks_as_stream.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/remove_bookmark.dart';
import 'package:lets_go_gym/domain/usecases/districts/get_all_districts.dart';
import 'package:lets_go_gym/domain/usecases/districts/get_district_by_id.dart';
import 'package:lets_go_gym/domain/usecases/districts/get_districts_by_ids.dart';
import 'package:lets_go_gym/domain/usecases/districts/update_districts_data.dart';
import 'package:lets_go_gym/domain/usecases/regions/get_all_regions.dart';
import 'package:lets_go_gym/domain/usecases/regions/get_region_by_id.dart';
import 'package:lets_go_gym/domain/usecases/regions/get_regions_by_ids.dart';
import 'package:lets_go_gym/domain/usecases/regions/update_regions_data.dart';
import 'package:lets_go_gym/domain/usecases/sports_centers/get_all_sports_centers.dart';
import 'package:lets_go_gym/domain/usecases/sports_centers/get_sports_center_by_id.dart';
import 'package:lets_go_gym/domain/usecases/sports_centers/get_sports_center_details_url.dart';
import 'package:lets_go_gym/domain/usecases/sports_centers/get_sports_centers_by_ids.dart';
import 'package:lets_go_gym/domain/usecases/sports_centers/update_sports_centers_data.dart';

void initUseCaseInjections() {
  /* AppInfo */
  sl.registerLazySingleton(() => GetAppInfo(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentDataInfo(repository: sl()));
  sl.registerLazySingleton(() => UpdateRegionDataLastUpdated(repository: sl()));
  sl.registerLazySingleton(
      () => UpdateDistrictDataLastUpdated(repository: sl()));
  sl.registerLazySingleton(
      () => UpdateSportsCenterDataLastUpdated(repository: sl()));
  /* AppSettings */
  sl.registerLazySingleton(() => GetCurrentLanguageSettings(repository: sl()));
  sl.registerLazySingleton(() => UpdateLanguageSettings(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentThemeSettings(repository: sl()));
  sl.registerLazySingleton(() => UpdateThemeSettings(repository: sl()));
  /* Regions */
  sl.registerLazySingleton(() => UpdateRegionsData(repository: sl()));
  sl.registerLazySingleton(() => GetAllRegions(repository: sl()));
  sl.registerLazySingleton(() => GetRegionById(repository: sl()));
  sl.registerLazySingleton(() => GetRegionsByIds(repository: sl()));
  /* Districts */
  sl.registerLazySingleton(() => UpdateDistrictsData(repository: sl()));
  sl.registerLazySingleton(() => GetAllDistricts(repository: sl()));
  sl.registerLazySingleton(() => GetDistrictById(repository: sl()));
  sl.registerLazySingleton(() => GetDistrictsByIds(repository: sl()));
  /* Sports centers */
  sl.registerLazySingleton(() => UpdateSportsCentersData(repository: sl()));
  sl.registerLazySingleton(() => GetAllSportsCenters(repository: sl()));
  sl.registerLazySingleton(() => GetSportsCenterById(repository: sl()));
  sl.registerLazySingleton(() => GetSportsCentersByIds(repository: sl()));
  sl.registerLazySingleton(() => GetSportsCenterDetailsUrl(repository: sl()));
  /* Bookmarks */
  sl.registerLazySingleton(() => GetAllBookmarks(repository: sl()));
  sl.registerLazySingleton(() => GetAllBookmarksAsStream(repository: sl()));
  sl.registerLazySingleton(() => CheckIfBookmarked(repository: sl()));
  sl.registerLazySingleton(() => CheckIfBookmarkedAsStream(repository: sl()));
  sl.registerLazySingleton(() => AddBookmark(repository: sl()));
  sl.registerLazySingleton(() => RemoveBookmark(repository: sl()));
  /* Auth */
  sl.registerLazySingleton(() => GetDeviceUUID(repository: sl()));
  sl.registerLazySingleton(() => SaveDeviceUUID(repository: sl()));
  sl.registerLazySingleton(() => GetStoredSessionToken(repository: sl()));
  sl.registerLazySingleton(() => SaveSessionToken(repository: sl()));
  sl.registerLazySingleton(() => RegisterNewUser(repository: sl()));
  sl.registerLazySingleton(() => UserSignIn(repository: sl()));
  sl.registerLazySingleton(() => RefreshSessionToken(repository: sl()));
}
