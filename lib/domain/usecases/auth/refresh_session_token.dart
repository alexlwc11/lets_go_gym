import 'package:lets_go_gym/domain/entities/token/session_token.dart';
import 'package:lets_go_gym/domain/repositories/auth_repository.dart';

class RefreshSessionToken {
  final AuthRepository repository;

  RefreshSessionToken({required this.repository});

  Future<SessionToken> execute(String refreshToken) =>
      repository.refresh(refreshToken);
}
