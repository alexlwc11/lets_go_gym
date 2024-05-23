import 'dart:developer';

import 'package:lets_go_gym/domain/entities/token/session_token.dart';
import 'package:lets_go_gym/domain/usecases/auth/get_device_uuid.dart';
import 'package:lets_go_gym/domain/usecases/auth/get_stored_session_token.dart';
import 'package:lets_go_gym/domain/usecases/auth/refresh_session_token.dart';
import 'package:lets_go_gym/domain/usecases/auth/save_session_token.dart';

const _authHeaderPrefix = 'Bearer ';

class TokenManager {
  final GetDeviceUUID getDeviceUUID;
  final GetStoredSessionToken getStoredSessionToken;
  final SaveSessionToken saveSessionToken;
  final RefreshSessionToken refreshSessionToken;

  TokenManager({
    required this.getDeviceUUID,
    required this.getStoredSessionToken,
    required this.saveSessionToken,
    required this.refreshSessionToken,
  });

  SessionToken? _sessionToken;

  Future<String> get authHeader async {
    _sessionToken ??= await getStoredSessionToken.execute();
    if (_sessionToken == null) {
      // Failed to retrieve the session token from secure storage
      log('TokenManager#authHeader - Missing session token');
      return '';
    } else if (_sessionToken!.sessionTokenExpiredAt.isAfter(DateTime.now())) {
      // Session token expired, need to refresh
      await _refreshToken(_sessionToken!.refreshToken);
    }

    final token = _sessionToken?.sessionToken ?? '';
    return '$_authHeaderPrefix$token';
  }

  Future<void> _refreshToken(String refreshToken) async {
    try {
      final newSessionToken = await refreshSessionToken.execute(refreshToken);

      await saveSessionToken.execute(newSessionToken);
      _sessionToken = newSessionToken;
    } catch (error) {
      log('AuthManager#_refreshToken', error: error);
    }
  }
}
