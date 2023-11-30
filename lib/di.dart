import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:lets_go_gym/core/api/api_client.dart';
import 'package:lets_go_gym/core/utils/auth_manager.dart';
import 'package:lets_go_gym/data/datasources/remote/app_info_remote_data_source.dart';
import 'package:lets_go_gym/data/repositories/app_info_repository_impl.dart';
import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_app_info.dart';
import 'package:lets_go_gym/ui/bloc/entry/entry_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // DataSources
  sl.registerLazySingleton<AppInfoRemoteDataSource>(
      () => AppInfoRemoteDataSourceImpl(unAuthClient: sl()));

  // Repositories
  sl.registerLazySingleton<AppInfoRepository>(
      () => AppInfoRepositoryImpl(remoteDataSource: sl()));

  // UseCases
  sl.registerLazySingleton<GetAppInfo>(() => GetAppInfo(repository: sl()));

  // BLoC
  sl.registerFactory(() => EntryBloc(getAppInfo: sl()));

  // Misc
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => AuthManager(flutterSecureStorage: sl()));
  sl.registerLazySingleton(() => AuthClient(authManager: sl()));
  sl.registerLazySingleton(() => UnAuthClient());
}
