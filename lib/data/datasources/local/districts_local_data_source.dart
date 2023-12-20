import 'package:lets_go_gym/data/datasources/local/database/daos/districts.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart';
import 'package:lets_go_gym/domain/entities/district/district.dart' as entity;

abstract class DistrictsLocalDataSource {
  Future<List<District>> getAllDistricts();
  Future<District?> getDistrictById(int id);
  Future<List<District>> getDistrictsByIds(List<int> ids);
  Future<List<District>> getDistrictsByRegionId(int regionId);
  Future<void> updateDistrictsData(List<entity.District> districts);
}

class DistrictsLocalDataSourceImpl implements DistrictsLocalDataSource {
  final DistrictsDao _dao;

  DistrictsLocalDataSourceImpl({required DistrictsDao dao}) : _dao = dao;

  @override
  Future<List<District>> getAllDistricts() => _dao.findAll();

  @override
  Future<District?> getDistrictById(int id) => _dao.findById(id);

  @override
  Future<List<District>> getDistrictsByIds(List<int> ids) =>
      _dao.findByIds(ids);

  @override
  Future<List<District>> getDistrictsByRegionId(int regionId) =>
      _dao.findByRegionId(regionId);

  @override
  Future<void> updateDistrictsData(List<entity.District> districts) =>
      _dao.updateData(districts);
}
