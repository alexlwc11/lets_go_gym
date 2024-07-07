import 'dart:developer';

import 'package:lets_go_gym/core/utils/constant/constants.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/models/token/refresh_token_dto.dart';
import 'package:lets_go_gym/data/models/token/session_token_dto.dart';
import 'package:lets_go_gym/data/models/user/user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<SessionTokenDto> register(String deviceUUID);
  Future<SessionTokenDto> signIn(String deviceUUID);
  Future<SessionTokenDto> refresh(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final UnAuthClient _unAuthClient;

  static String get _authUrl => ApiConstants.baseUrl;

  AuthRemoteDataSourceImpl({required UnAuthClient unAuthClient})
      : _unAuthClient = unAuthClient;

  @override
  Future<SessionTokenDto> register(String deviceUUID) async {
    try {
      final response = await _unAuthClient.post(
        '$_authUrl/register',
        data: UserDto(deviceUUID: deviceUUID).toJson(),
      );
      final responseData = response.data as Map<String, dynamic>;

      return SessionTokenDto.fromJson(responseData);
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future<SessionTokenDto> signIn(String deviceUUID) async {
    try {
      final response = await _unAuthClient.post(
        '$_authUrl/sign_in',
        data: UserDto(deviceUUID: deviceUUID).toJson(),
      );
      final responseData = response.data as Map<String, dynamic>;

      return SessionTokenDto.fromJson(responseData);
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future<SessionTokenDto> refresh(String refreshToken) async {
    try {
      final response = await _unAuthClient.post(
        '$_authUrl/refresh',
        data: RefreshTokenDto(refreshToken: refreshToken).toJson(),
      );
      final responseData = response.data as Map<String, dynamic>;

      return SessionTokenDto.fromJson(responseData);
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }
}
