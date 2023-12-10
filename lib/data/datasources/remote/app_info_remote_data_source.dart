import 'package:lets_go_gym/core/constants.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/models/app_info/app_info_dto.dart';

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
    try {
      // TODO remove mock data
      // final response = await _unAuthClient.get(_appInfoUrl);
      // final responseData = response.data as Map<String, dynamic>;
      final responseData = await Future.delayed(
        const Duration(seconds: 3),
        () => _appInfoJson,
      );

      return AppInfoDto.fromJson(responseData);
    } catch (error) {
      rethrow;
    }
  }
}

final _appInfoJson = {
  'latest_build_version': 1,
  'minimum_build_version': 1,
  'data_info': {
    'region_data_last_updated_at': DateTime.utc(2023).toIso8601String(),
    'district_data_last_updated_at': DateTime.utc(2023).toIso8601String(),
    'sports_center_data_last_updated_at': DateTime.utc(2023).toIso8601String(),
  },
};
