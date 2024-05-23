import 'package:lets_go_gym/domain/entities/token/session_token.dart';

abstract class AuthRepository {
  Future<String?> getDeviceUUID();
  Future<void> saveDeviceUUID(String deviceUUID);
  Future<SessionToken?> getStoredSessionToken();
  Future<void> saveSessionToken(SessionToken sessionToken);
  Future<SessionToken> register(String deviceUUID);
  Future<SessionToken> signIn(String deviceUUID);
  Future<SessionToken> refresh(String refreshToken);
}
