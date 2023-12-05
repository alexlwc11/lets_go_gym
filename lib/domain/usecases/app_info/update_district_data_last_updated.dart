import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';

class UpdateDistrictData {
  final AppInfoRepository repository;

  UpdateDistrictData({required this.repository});

  Future<void> execute() => repository.updateDistrictData();
}
