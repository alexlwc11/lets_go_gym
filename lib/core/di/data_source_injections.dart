import 'package:lets_go_gym/data/datasources/local/app_info_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/local/app_settings_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/local/auth_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/local/bookmarks_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/local/districts_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/local/regions_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/local/sports_centers_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/app_info_remote_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/auth_remote_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/bookmarks_remote_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/districts_remote_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/regions_remote_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/sports_centers_remote_data_source.dart';
import 'package:lets_go_gym/core/di/di.dart';

void initDataSourcesInjections() {
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
    () => BookmarksLocalDataSourceImpl(sharedPreferences: sl()),
    dispose: (dataSource) => dataSource.dispose(),
  );
  sl.registerLazySingleton<BookmarksRemoteDataSource>(
      () => BookmarksRemoteDataSourceImpl(authClient: sl()));
  /* Auth */
  sl.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(flutterSecureStorage: sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(unAuthClient: sl()));
}
