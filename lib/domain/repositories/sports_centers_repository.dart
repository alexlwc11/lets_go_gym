import 'package:lets_go_gym/domain/entities/sports_center/sports_center.dart';

abstract class SportsCentersRepository {
  Future<List<SportsCenter>> getAllSportsCenters();
  Future<SportsCenter?> getSportsCenterById(int id);
  Future<List<SportsCenter>> getSportsCentersByDistrictId(int districtId);
  Future<List<SportsCenter>> getSportsCentersByRegionId(int regionId);
  Future<void> updateSportsCenterData();
}
