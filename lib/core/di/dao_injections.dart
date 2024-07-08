import 'package:lets_go_gym/core/di/di.dart';
import 'package:lets_go_gym/data/datasources/local/database/daos/districts.dart';
import 'package:lets_go_gym/data/datasources/local/database/daos/regions.dart';
import 'package:lets_go_gym/data/datasources/local/database/daos/sports_centers.dart';

void initDaoInjections() {
  sl.registerLazySingleton(() => RegionsDao(sl()));
  sl.registerLazySingleton(() => DistrictsDao(sl()));
  sl.registerLazySingleton(() => SportsCentersDao(sl()));
}
