import 'package:lets_go_gym/domain/entities/app_info/app_info.dart';
import 'package:lets_go_gym/domain/entities/app_info/data_info.dart';

abstract class AppInfoRepository {
  Future<AppInfo> getAppInfo();
  Future<DataInfo> getCurrentDataInfo();
  Future<void> updateRegionDataLastUpdated();
  Future<void> updateDistrictDataLastUpdated();
  Future<void> updateSportsCenterDataLastUpdated();
}
