import 'package:lets_go_gym/domain/entities/district/district.dart';

abstract class DistrictsRepository {
  Future<List<District>> getAllDistricts();
  Future<District?> getDistrictById(int id);
  Future<List<District>> getDistrictsByIds(List<int> ids);
  Future<List<District>> getDistrictsByRegionId(int regionId);
  Future<void> updateDistrictData();
}
