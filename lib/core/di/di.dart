import 'package:get_it/get_it.dart';
import 'package:lets_go_gym/core/di/bloc_injections.dart';
import 'package:lets_go_gym/core/di/dao_injections.dart';
import 'package:lets_go_gym/core/di/data_source_injections.dart';
import 'package:lets_go_gym/core/di/misc_injections.dart';
import 'package:lets_go_gym/core/di/use_case_injections.dart';
import 'package:lets_go_gym/core/di/repository_injections.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // DataSources
  initDataSourcesInjections();

  // Repositories
  initRepositoryInjections();

  // UseCases
  initUseCaseInjections();

  // BLoC
  initBlocInjections();

  // DAO
  initDaoInjections();

  // Misc
  await initMiscInjections();
}
