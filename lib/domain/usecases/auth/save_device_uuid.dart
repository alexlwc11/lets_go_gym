import 'package:lets_go_gym/domain/repositories/auth_repository.dart';

class SaveDeviceUUID {
  final AuthRepository repository;

  SaveDeviceUUID({required this.repository});

  Future<void> execute(String deviceUUID) =>
      repository.saveDeviceUUID(deviceUUID);
}
