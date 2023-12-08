import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';

class UpdateDistrictDataLastUpdated {
  final AppInfoRepository repository;

  UpdateDistrictDataLastUpdated({required this.repository});

  Future<void> execute() => repository.updateDistrictDataLastUpdated();
}
