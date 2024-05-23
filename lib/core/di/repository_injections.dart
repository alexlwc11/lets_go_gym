import 'package:lets_go_gym/data/repositories/app_info_repository_impl.dart';
import 'package:lets_go_gym/data/repositories/app_settings_repository_impl.dart';
import 'package:lets_go_gym/data/repositories/auth_repository_impl.dart';
import 'package:lets_go_gym/data/repositories/bookmarks_repository_impl.dart';
import 'package:lets_go_gym/data/repositories/districts_repository_impl.dart';
import 'package:lets_go_gym/data/repositories/regions_repository_impl.dart';
import 'package:lets_go_gym/data/repositories/sports_centers_repository_impl.dart';
import 'package:lets_go_gym/core/di/di.dart';
import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';
import 'package:lets_go_gym/domain/repositories/app_settings_repository.dart';
import 'package:lets_go_gym/domain/repositories/auth_repository.dart';
import 'package:lets_go_gym/domain/repositories/bookmarks_repository.dart';
import 'package:lets_go_gym/domain/repositories/districts_repository.dart';
import 'package:lets_go_gym/domain/repositories/regions_repository.dart';
import 'package:lets_go_gym/domain/repositories/sports_centers_repository.dart';

void initRepositoryInjections() {
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
  /* Auth */
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()));
}
