import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';

class UpdateRegionData {
  final AppInfoRepository repository;

  UpdateRegionData({required this.repository});

  Future<void> execute() => repository.updateRegionData();
}
