import 'package:lets_go_gym/data/datasources/local/auth_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/auth_remote_data_source.dart';
import 'package:lets_go_gym/data/models/token/session_token_dto.dart';
import 'package:lets_go_gym/domain/entities/token/session_token.dart';
import 'package:lets_go_gym/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<String?> getDeviceUUID() => localDataSource.getDeviceUUID();

  @override
  Future<void> saveDeviceUUID(String deviceUUID) =>
      localDataSource.saveDeviceUUID(deviceUUID);

  @override
  Future<SessionToken?> getStoredSessionToken() =>
      localDataSource.getSessionToken();

  @override
  Future<void> saveSessionToken(SessionToken sessionToken) =>
      localDataSource.saveSessionToken(sessionToken);

  @override
  Future<SessionToken> register(String deviceUUID) async {
    try {
      final sessionTokenDto = await remoteDataSource.register(deviceUUID);
      return sessionTokenDto.toEntity;
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  Future<SessionToken> signIn(String deviceUUID) async {
    try {
      final sessionTokenDto = await remoteDataSource.signIn(deviceUUID);
      return sessionTokenDto.toEntity;
    } catch (error) {
      return Future.error(error);
    }
  }

  @override
  Future<SessionToken> refresh(String refreshToken) async {
    try {
      final sessionTokenDto = await remoteDataSource.refresh(refreshToken);
      return sessionTokenDto.toEntity;
    } catch (error) {
      return Future.error(error);
    }
  }
}
