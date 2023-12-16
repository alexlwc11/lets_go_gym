import 'package:lets_go_gym/domain/entities/region/region.dart';
import 'package:lets_go_gym/domain/repositories/regions_repository.dart';

class GetAllRegions {
  final RegionsRepository repository;

  GetAllRegions({required this.repository});

  Future<List<Region>> execute() => repository.getAllRegions();
}
