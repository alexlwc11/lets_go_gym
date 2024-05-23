import 'package:lets_go_gym/domain/repositories/auth_repository.dart';

class GetDeviceUUID {
  final AuthRepository repository;

  GetDeviceUUID({required this.repository});

  Future<String?> execute() => repository.getDeviceUUID();
}
