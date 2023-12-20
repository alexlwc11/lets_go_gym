import 'package:lets_go_gym/domain/entities/region/region.dart';
import 'package:lets_go_gym/domain/repositories/regions_repository.dart';

class GetRegionsByIds {
  final RegionsRepository repository;

  GetRegionsByIds({required this.repository});

  Future<List<Region>> execute(List<int> ids) =>
      repository.getRegionsByIds(ids);
}
