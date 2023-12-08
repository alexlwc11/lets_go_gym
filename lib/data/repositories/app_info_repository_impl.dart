import 'package:lets_go_gym/data/datasources/local/app_info_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/app_info_remote_data_source.dart';
import 'package:lets_go_gym/data/models/app_info/app_info_dto.dart';
import 'package:lets_go_gym/data/models/app_info/data_info_dto.dart';
import 'package:lets_go_gym/domain/entities/app_info/app_info.dart';
import 'package:lets_go_gym/domain/entities/app_info/data_info.dart';
import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';

class AppInfoRepositoryImpl implements AppInfoRepository {
  final AppInfoLocalDataSource localDataSource;
  final AppInfoRemoteDataSource remoteDataSource;

  AppInfoRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<AppInfo> getAppInfo() async {
    try {
      final appInfoDto = await remoteDataSource.getAppInfo();
      return appInfoDto.toAppInfo;
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  Future<DataInfo> getCurrentDataInfo() async {
    try {
      final dataInfoDto = await localDataSource.getCurrentDataInfo();
      return dataInfoDto.toDataInfo;
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  Future<void> updateRegionDataLastUpdated() async {
    await localDataSource.updateRegionDataLastUpdated();
  }

  @override
  Future<void> updateDistrictDataLastUpdated() async {
    await localDataSource.updateDistrictDataLastUpdated();
  }

  @override
  Future<void> updateSportsCenterDataLastUpdated() async {
    await localDataSource.updateSportsCenterDataLastUpdated();
  }
}
