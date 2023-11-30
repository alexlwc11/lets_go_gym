import 'package:lets_go_gym/domain/entities/app_info/app_info.dart';
import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';

class GetAppInfo {
  final AppInfoRepository repository;

  GetAppInfo({required this.repository});

  Future<AppInfo> execute() async => repository.getAppInfo();
}
