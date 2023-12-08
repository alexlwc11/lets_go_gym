import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';

class UpdateRegionDataLastUpdated {
  final AppInfoRepository repository;

  UpdateRegionDataLastUpdated({required this.repository});

  Future<void> execute() => repository.updateRegionDataLastUpdated();
}
