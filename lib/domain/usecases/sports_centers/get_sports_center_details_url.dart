import 'package:lets_go_gym/domain/repositories/sports_centers_repository.dart';

class GetSportsCenterDetailsUrl {
  final SportsCentersRepository repository;

  GetSportsCenterDetailsUrl({required this.repository});

  Future<String> execute(int id) => repository.getSportsCenterDetailsUrl(id);
}
