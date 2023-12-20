import 'package:lets_go_gym/domain/entities/sports_center/sports_center.dart';
import 'package:lets_go_gym/domain/repositories/sports_centers_repository.dart';

class GetSportsCentersByIds {
  final SportsCentersRepository repository;

  GetSportsCentersByIds({required this.repository});

  Future<List<SportsCenter>> execute(List<int> ids) =>
      repository.getSportsCentersByIds(ids);
}
