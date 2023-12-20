import 'package:lets_go_gym/domain/entities/district/district.dart';
import 'package:lets_go_gym/domain/repositories/districts_repository.dart';

class GetDistrictsByIds {
  final DistrictsRepository repository;

  GetDistrictsByIds({required this.repository});

  Future<List<District>> execute(List<int> ids) =>
      repository.getDistrictsByIds(ids);
}
