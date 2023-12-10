import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:lets_go_gym/data/datasources/local/app_info_local_data_source.dart';
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
import 'package:lets_go_gym/data/datasources/remote/districts_remote_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/regions_remote_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/sports_centers_data_source.dart';
import 'package:lets_go_gym/data/repositories/app_info_repository_impl.dart';
import 'package:lets_go_gym/data/repositories/districts_repository_impl.dart';
import 'package:lets_go_gym/data/repositories/regions_repository_impl.dart';
import 'package:lets_go_gym/data/repositories/sports_centers_repository_impl.dart';
import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';
import 'package:lets_go_gym/domain/repositories/districts_repository.dart';
import 'package:lets_go_gym/domain/repositories/regions_repository.dart';
import 'package:lets_go_gym/domain/repositories/sports_centers_repository.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_app_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_current_data_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_district_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_region_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_sports_center_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/districts/update_districts_data.dart';
import 'package:lets_go_gym/domain/usecases/regions/update_regions_data.dart';
import 'package:lets_go_gym/domain/usecases/sports_centers/update_sports_centers_data.dart';
import 'package:lets_go_gym/ui/bloc/entry/entry_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // DataSources
  /* AppInfo */
  sl.registerLazySingleton<AppInfoLocalDataSource>(
      () => AppInfoLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<AppInfoRemoteDataSource>(
      () => AppInfoRemoteDataSourceImpl(unAuthClient: sl()));
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

  // Repositories
  /* AppInfo */
  sl.registerLazySingleton<AppInfoRepository>(() =>
      AppInfoRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()));
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

  // UseCases
  /* AppInfo */
  sl.registerLazySingleton<GetAppInfo>(() => GetAppInfo(repository: sl()));
  sl.registerLazySingleton<GetCurrentDataInfo>(
      () => GetCurrentDataInfo(repository: sl()));
  sl.registerLazySingleton<UpdateRegionDataLastUpdated>(
      () => UpdateRegionDataLastUpdated(repository: sl()));
  sl.registerLazySingleton<UpdateDistrictDataLastUpdated>(
      () => UpdateDistrictDataLastUpdated(repository: sl()));
  sl.registerLazySingleton<UpdateSportsCenterDataLastUpdated>(
      () => UpdateSportsCenterDataLastUpdated(repository: sl()));
  /* Regions */
  sl.registerLazySingleton<UpdateRegionsData>(
      () => UpdateRegionsData(repository: sl()));
  /* Districts */
  sl.registerLazySingleton<UpdateDistrictsData>(
      () => UpdateDistrictsData(repository: sl()));
  /* Sports centers */
  sl.registerLazySingleton<UpdateSportsCentersData>(
      () => UpdateSportsCentersData(repository: sl()));

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

  // DAO
  sl.registerLazySingleton<RegionsDao>(() => RegionsDao(sl()));
  sl.registerLazySingleton<DistrictsDao>(() => DistrictsDao(sl()));
  sl.registerLazySingleton<SportsCentersDao>(() => SportsCentersDao(sl()));

  // Misc
  sl.registerLazySingletonAsync(SharedPreferences.getInstance);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => AuthManager(
        sharedPreferences: sl(),
        flutterSecureStorage: sl(),
      ));
  sl.registerLazySingleton(() => AuthClient(authManager: sl()));
  sl.registerLazySingleton(() => UnAuthClient());
  sl.registerSingleton(() => AppDatabase());
}
