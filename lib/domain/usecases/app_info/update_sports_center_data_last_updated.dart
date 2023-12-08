import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';

class UpdateSportsCenterDataLastUpdated {
  final AppInfoRepository repository;

  UpdateSportsCenterDataLastUpdated({required this.repository});

  Future<void> execute() => repository.updateSportsCenterDataLastUpdated();
}
