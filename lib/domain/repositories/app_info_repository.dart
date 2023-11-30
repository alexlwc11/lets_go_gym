import 'package:lets_go_gym/domain/entities/app_info/app_info.dart';

abstract class AppInfoRepository {
  Future<AppInfo> getAppInfo();
}
