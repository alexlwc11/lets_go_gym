import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:lets_go_gym/data/datasources/local/app_info_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/local/app_settings_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/local/bookmarks_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/local/database/daos/bookmarks.dart';
import 'package:lets_go_gym/data/datasources/local/database/daos/districts.dart';
import 'package:lets_go_gym/data/datasources/local/database/daos/regions.dart';
import 'package:lets_go_gym/data/datasources/local/database/daos/sports_centers.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart';
import 'package:lets_go_gym/data/datasources/local/districts_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/local/regions_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/local/sports_centers_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/datasources/remote/api/auth_manager.dart';
import 'package:lets_go_gym/data/datasources/remote/app_info_remote_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/bookmarks_remote_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/districts_remote_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/regions_remote_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/sports_centers_remote_data_source.dart';
import 'package:lets_go_gym/data/repositories/app_info_repository_impl.dart';
import 'package:lets_go_gym/data/repositories/app_settings_repository_impl.dart';
import 'package:lets_go_gym/data/repositories/bookmarks_repository_impl.dart';
import 'package:lets_go_gym/data/repositories/districts_repository_impl.dart';
import 'package:lets_go_gym/data/repositories/regions_repository_impl.dart';
import 'package:lets_go_gym/data/repositories/sports_centers_repository_impl.dart';
import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';
import 'package:lets_go_gym/domain/repositories/app_settings_repository.dart';
import 'package:lets_go_gym/domain/repositories/bookmarks_repository.dart';
import 'package:lets_go_gym/domain/repositories/districts_repository.dart';
import 'package:lets_go_gym/domain/repositories/regions_repository.dart';
import 'package:lets_go_gym/domain/repositories/sports_centers_repository.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_app_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_current_data_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_district_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_region_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_sports_center_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/get_current_language_settings.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/get_current_theme_settings.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/update_language_settings.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/update_theme_settings.dart';
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
import 'package:lets_go_gym/ui/bloc/bookmarks/bookmarks_bloc.dart';
import 'package:lets_go_gym/ui/bloc/entry/entry_bloc.dart';
import 'package:lets_go_gym/ui/bloc/languages/language_settings_cubit.dart';
import 'package:lets_go_gym/ui/bloc/location/location_bloc.dart';
import 'package:lets_go_gym/ui/bloc/locations/locations_bloc.dart';
import 'package:lets_go_gym/ui/bloc/themes/theme_settings_cubit.dart';
import 'package:lets_go_gym/ui/cubits/locations_fliter/locations_filter_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // DataSources
  /* AppInfo */
  sl.registerLazySingleton<AppInfoLocalDataSource>(
      () => AppInfoLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<AppInfoRemoteDataSource>(
      () => AppInfoRemoteDataSourceImpl(unAuthClient: sl()));
  /* AppSettings */
  sl.registerLazySingleton<AppSettingsLocalDataSource>(
      () => AppSettingsLocalDataSourceImpl(sharedPreferences: sl()));
  /* Regions */
  sl.registerLazySingleton<RegionsLocalDataSource>(
      () => RegionsLocalDataSourceImpl(dao: sl()));
  sl.registerLazySingleton<RegionsRemoteDataSource>(
      () => RegionsRemoteDataSourceImpl(authClient: sl()));
  /* Districts */
  sl.registerLazySingleton<DistrictsLocalDataSource>(
      () => DistrictsLocalDataSourceImpl(dao: sl()));
  sl.registerLazySingleton<DistrictsRemoteDataSource>(
      () => DistrictsRemoteDataSourceImpl(authClient: sl()));
  /* Sports centers */
  sl.registerLazySingleton<SportsCentersLocalDataSource>(
      () => SportsCentersLocalDataSourceImpl(dao: sl()));
  sl.registerLazySingleton<SportsCentersRemoteDataSource>(
      () => SportsCentersRemoteDataSourceImpl(authClient: sl()));
  /* Bookmarks */
  sl.registerLazySingleton<BookmarksLocalDataSource>(
      () => BookmarksLocalDataSourceImpl(dao: sl()));
  sl.registerLazySingleton<BookmarksRemoteDataSource>(
      () => BookmarksRemoteDataSourceImpl(authClient: sl()));

  // Repositories
  /* AppInfo */
  sl.registerLazySingleton<AppInfoRepository>(() =>
      AppInfoRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()));
  /* AppSettings */
  sl.registerLazySingleton<AppSettingsRepository>(
      () => AppSettingsRepositoryImpl(localDataSource: sl()));
  /* Regions */
  sl.registerLazySingleton<RegionsRepository>(() =>
      RegionsRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()));
  /* Districts */
  sl.registerLazySingleton<DistrictsRepository>(() =>
      DistrictsRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()));
  /* Sports centers */
  sl.registerLazySingleton<SportsCentersRepository>(() =>
      SportsCentersRepositoryImpl(
          localDataSource: sl(), remoteDataSource: sl()));
  /* Bookmarks */
  sl.registerLazySingleton<BookmarksRepository>(() =>
      BookmarksRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()));

  // UseCases
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

  // BLoC
  sl.registerFactory(() => EntryBloc(
        getAppInfo: sl(),
        getCurrentDataInfo: sl(),
        updateRegionsData: sl(),
        updateDistrictsData: sl(),
        updateSportsCentersData: sl(),
        updateRegionDataLastUpdated: sl(),
        updateDistrictDataLastUpdated: sl(),
        updateSportsCenterDataLastUpdated: sl(),
      ));
  sl.registerFactory(() => BookmarksBloc(
        getAllBookmarksAsStream: sl(),
        removeBookmark: sl(),
        getRegionsByIds: sl(),
        getDistrictsByIds: sl(),
        getSportsCentersByIds: sl(),
      ));
  sl.registerFactory(() => LocationsBloc(
        getAllRegions: sl(),
        getAllDistricts: sl(),
        getAllSportsCenters: sl(),
        getAllBookmarks: sl(),
        getAllBookmarksAsStream: sl(),
        addBookmark: sl(),
        removeBookmark: sl(),
      ));
  sl.registerFactoryParam<LocationBloc, int, dynamic>(
    (sportsCenterId, _) => LocationBloc(
      sportsCenterId: sportsCenterId,
      getRegionById: sl(),
      getDistrictById: sl(),
      getSportsCenterById: sl(),
      getSportsCenterDetailsUrl: sl(),
      checkIfBookmarked: sl(),
      checkIfBookmarkedAsStream: sl(),
      addBookmark: sl(),
      removeBookmark: sl(),
    ),
  );
  sl.registerFactory(() => LanguageSettingsCubit(
        getCurrentLanguageSettings: sl(),
        updateLanguageSettings: sl(),
      ));
  sl.registerFactory(() => ThemeSettingsCubit(
        getCurrentThemeSettings: sl(),
        updateThemeSettings: sl(),
      ));
  // Cubit
  sl.registerFactory(
    () => LocationsFilterCubit(),
  );

  // DAO
  sl.registerLazySingleton(() => RegionsDao(sl()));
  sl.registerLazySingleton(() => DistrictsDao(sl()));
  sl.registerLazySingleton(() => SportsCentersDao(sl()));
  sl.registerLazySingleton(() => BookmarksDao(sl()));

  // Misc
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => AuthManager(
        sharedPreferences: sl(),
        flutterSecureStorage: sl(),
      ));
  sl.registerLazySingleton(() => AuthClient(authManager: sl()));
  sl.registerLazySingleton(() => UnAuthClient());
  sl.registerSingleton(await SharedPreferences.getInstance());
  sl.registerSingleton(AppDatabase());
}
