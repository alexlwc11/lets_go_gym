import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lets_go_gym/domain/entities/token/session_token.dart';

const _deviceUUIDKey = 'deviceUUID';
const _sessionTokenKey = 'sessionToken';

abstract class AuthLocalDataSource {
  Future<String?> getDeviceUUID();
  Future<void> saveDeviceUUID(String deviceUUID);
  Future<SessionToken?> getSessionToken();
  Future<void> saveSessionToken(SessionToken sessionToken);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  AuthLocalDataSourceImpl({
    required FlutterSecureStorage flutterSecureStorage,
  }) : _storage = flutterSecureStorage;

  @override
  Future<String?> getDeviceUUID() => _storage.read(key: _deviceUUIDKey);

  @override
  Future<void> saveDeviceUUID(String deviceUUID) =>
      _storage.write(key: _deviceUUIDKey, value: deviceUUID);

  @override
  Future<SessionToken?> getSessionToken() async {
    final jsonString = await _storage.read(key: _sessionTokenKey);

    return jsonString != null
        ? SessionToken.fromJson(jsonDecode(jsonString))
        : null;
  }

  @override
  Future<void> saveSessionToken(SessionToken sessionToken) => _storage.write(
        key: _sessionTokenKey,
        value: jsonEncode(sessionToken.toJson()),
      );
}
