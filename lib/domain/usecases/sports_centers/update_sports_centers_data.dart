import 'package:lets_go_gym/domain/repositories/sports_centers_repository.dart';

class UpdateSportsCentersData {
  final SportsCentersRepository repository;

  UpdateSportsCentersData({required this.repository});

  Future<void> execute() => repository.updateSportsCenterData();
}
