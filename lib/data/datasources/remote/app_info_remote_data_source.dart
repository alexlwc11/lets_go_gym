import 'package:lets_go_gym/core/constants.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/models/app_info/app_info_dto.dart';
import 'package:lets_go_gym/mock_data/mock_data.dart' as mock;

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
        () => mock.appInfoJson,
      );

      return AppInfoDto.fromJson(responseData);
    } catch (error) {
      rethrow;
    }
  }
}
