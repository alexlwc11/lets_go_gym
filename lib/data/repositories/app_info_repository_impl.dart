import 'package:lets_go_gym/data/datasources/remote/app_info_remote_data_source.dart';
import 'package:lets_go_gym/data/models/app_info/app_info_dto.dart';
import 'package:lets_go_gym/domain/entities/app_info/app_info.dart';
import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';

class AppInfoRepositoryImpl implements AppInfoRepository {
  final AppInfoRemoteDataSource remoteDataSource;

  AppInfoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AppInfo> getAppInfo() async {
    try {
      final appInfoDto = await remoteDataSource.getAppInfo();
      return appInfoDto.toAppInfo;
    } catch (error) {
      return Future.error(error);
    }
  }
}
