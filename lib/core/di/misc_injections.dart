import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lets_go_gym/core/di/di.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/datasources/remote/api/token_manager.dart';

Future<void> initMiscInjections() async {
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => TokenManager(
      getDeviceUUID: sl(),
      getStoredSessionToken: sl(),
      saveSessionToken: sl(),
      refreshSessionToken: sl()));
  sl.registerLazySingleton(() => AuthClient(authManager: sl()));
  sl.registerLazySingleton(() => UnAuthClient());
  sl.registerSingletonAsync(SharedPreferences.getInstance);
  await sl.isReady<SharedPreferences>();
  sl.registerSingleton(AppDatabase());
}
