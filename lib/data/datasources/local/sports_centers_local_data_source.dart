import 'package:lets_go_gym/data/datasources/local/database/daos/sports_centers.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart';
import 'package:lets_go_gym/domain/entities/sports_center/sports_center.dart'
    as entity;

abstract class SportsCentersLocalDataSource {
  Future<List<SportsCenter>> getAllSportsCenters();
  Future<SportsCenter?> getSportsCenterById(int id);
  Future<List<SportsCenter>> getSportsCentersByIds(List<int> ids);
  Future<List<SportsCenter>> getSportsCentersByDistrictId(int districtId);
  Future<List<SportsCenter>> getSportsCentersByRegionId(int regionId);
  Future<void> updateSportsCentersData(List<entity.SportsCenter> sportsCenters);
}

class SportsCentersLocalDataSourceImpl implements SportsCentersLocalDataSource {
  final SportsCentersDao _dao;

  SportsCentersLocalDataSourceImpl({required SportsCentersDao dao})
      : _dao = dao;

  @override
  Future<List<SportsCenter>> getAllSportsCenters() => _dao.findAll();

  @override
  Future<SportsCenter?> getSportsCenterById(int id) => _dao.findById(id);

  @override
  Future<List<SportsCenter>> getSportsCentersByIds(List<int> ids) =>
      _dao.findByIds(ids);

  @override
  Future<List<SportsCenter>> getSportsCentersByDistrictId(int districtId) =>
      _dao.findByDistrictId(districtId);

  @override
  Future<List<SportsCenter>> getSportsCentersByRegionId(int regionId) =>
      _dao.findByRegionId(regionId);

  @override
  Future<void> updateSportsCentersData(
          List<entity.SportsCenter> sportsCenters) =>
      _dao.updateData(sportsCenters);
}
