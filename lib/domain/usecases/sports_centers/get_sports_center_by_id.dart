import 'package:lets_go_gym/domain/entities/sports_center/sports_center.dart';
import 'package:lets_go_gym/domain/repositories/sports_centers_repository.dart';

class GetSportsCenterById {
  final SportsCentersRepository repository;

  GetSportsCenterById({required this.repository});

  Future<SportsCenter?> execute(int id) => repository.getSportsCenterById(id);
}
