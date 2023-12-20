import 'package:lets_go_gym/domain/entities/region/region.dart';
import 'package:lets_go_gym/domain/repositories/regions_repository.dart';

class GetRegionById {
  final RegionsRepository repository;

  GetRegionById({required this.repository});

  Future<Region?> execute(int id) => repository.getRegionById(id);
}
