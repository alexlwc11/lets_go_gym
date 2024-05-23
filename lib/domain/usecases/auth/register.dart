import 'package:lets_go_gym/domain/entities/token/session_token.dart';
import 'package:lets_go_gym/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository repository;

  Register({required this.repository});

  Future<SessionToken> execute(String deviceUUID) =>
      repository.register(deviceUUID);
}
