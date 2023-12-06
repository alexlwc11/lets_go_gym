import 'package:lets_go_gym/domain/repositories/app_info_repository.dart';

class UpdateSportsCenterData {
  final AppInfoRepository repository;

  UpdateSportsCenterData({required this.repository});

  Future<void> execute() => repository.updateSportsCenterData();
}
