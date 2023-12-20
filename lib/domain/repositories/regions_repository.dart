import 'package:lets_go_gym/domain/entities/region/region.dart';

abstract class RegionsRepository {
  Future<List<Region>> getAllRegions();
  Future<Region?> getRegionById(int id);
  Future<List<Region>> getRegionsByIds(List<int> id);
  Future<void> updateRegionData();
}
