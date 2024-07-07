import 'dart:developer';

import 'package:lets_go_gym/core/utils/constant/constants.dart';
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
      final response = await _unAuthClient.get(_appInfoUrl);
      final responseData = response.data as Map<String, dynamic>;

      return AppInfoDto.fromJson(responseData);
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }
}
