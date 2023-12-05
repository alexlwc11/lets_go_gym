import 'package:lets_go_gym/core/constants.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/models/app_info/app_info_dto.dart';
import 'package:lets_go_gym/data/models/app_info/data_info_dto.dart';

abstract class AppInfoRemoteDataSource {
  Future<AppInfoDto> getAppInfo();
}

class AppInfoRemoteDataSourceImpl implements AppInfoRemoteDataSource {
  final UnAuthClient _unAuthClient;

  static String get _appInfoUrl => '${ApiConstants.baseUrl}/app_info';

  AppInfoRemoteDataSourceImpl({required UnAuthClient unAuthClient})
      : _unAuthClient = unAuthClient;

  @override
  Future<AppInfoDto> getAppInfo() async {
    return Future.delayed(
        const Duration(seconds: 3),
        () => AppInfoDto(
              latestBuildVersion: 1,
              minimumBuildVersion: 1,
              dataInfoDto: DataInfoDto(
                regionDataLastUpdatedAt: DateTime(2023),
                districtDataLastUpdatedAt: DateTime(2023),
                sportsCenterDataLastUpdatedAt: DateTime(2023),
              ),
            ));
    // try {
    //   final response = await _unAuthClient.get(_appInfoUrl);
    //   final appInfoData = response.data as Map<String, dynamic>;
    //
    //   return AppInfoDto.fromJson((appInfoData['data'] as Map<String, dynamic>));
    // } catch (error) {
    //   rethrow;
    // }
  }
}
