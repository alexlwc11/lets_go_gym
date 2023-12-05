import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:lets_go_gym/data/datasources/local/app_info_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/datasources/remote/api/auth_manager.dart';
import 'package:lets_go_gym/data/datasources/remote/app_info_remote_data_source.dart';
import 'package:lets_go_gym/data/repositories/app_info_repository_impl.dart';
import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_app_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_current_data_info.dart';
import 'package:lets_go_gym/ui/bloc/entry/entry_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // DataSources
  /// AppInfo
  sl.registerLazySingleton<AppInfoLocalDataSource>(
      () => AppInfoLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<AppInfoRemoteDataSource>(
      () => AppInfoRemoteDataSourceImpl(unAuthClient: sl()));

  // Repositories
  sl.registerLazySingleton<AppInfoRepository>(() =>
      AppInfoRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()));

  // UseCases
  /// AppInfo
  sl.registerLazySingleton<GetAppInfo>(() => GetAppInfo(repository: sl()));
  sl.registerLazySingleton<GetCurrentDataInfo>(
      () => GetCurrentDataInfo(repository: sl()));

  // BLoC
  sl.registerFactory(() => EntryBloc(getAppInfo: sl()));

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
