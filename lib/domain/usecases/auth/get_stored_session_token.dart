import 'package:lets_go_gym/domain/entities/token/session_token.dart';
import 'package:lets_go_gym/domain/repositories/auth_repository.dart';

class GetStoredSessionToken {
  final AuthRepository repository;

  GetStoredSessionToken({required this.repository});

  Future<SessionToken?> execute() => repository.getStoredSessionToken();
}
