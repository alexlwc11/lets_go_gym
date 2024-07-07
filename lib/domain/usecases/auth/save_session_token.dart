import 'package:lets_go_gym/domain/entities/token/session_token.dart';
import 'package:lets_go_gym/domain/repositories/auth_repository.dart';

class SaveSessionToken {
  final AuthRepository repository;

  SaveSessionToken({required this.repository});

  Future<void> execute(SessionToken sessionToken) =>
      repository.saveSessionToken(sessionToken);
}
