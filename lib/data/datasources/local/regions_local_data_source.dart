import 'package:lets_go_gym/data/datasources/local/database/daos/regions.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart';
import 'package:lets_go_gym/domain/entities/region/region.dart' as entity;

abstract class RegionsLocalDataSource {
  Future<List<Region>> getAllRegions();
  Future<Region?> getRegionById(int id);
  Future<List<Region>> getRegionsByIds(List<int> ids);
  Future<void> updateRegionsData(List<entity.Region> regions);
}

class RegionsLocalDataSourceImpl implements RegionsLocalDataSource {
  final RegionsDao _dao;

  RegionsLocalDataSourceImpl({required RegionsDao dao}) : _dao = dao;

  @override
  Future<List<Region>> getAllRegions() => _dao.findAll();

  @override
  Future<Region?> getRegionById(int id) => _dao.findById(id);

  @override
  Future<List<Region>> getRegionsByIds(List<int> ids) => _dao.findByIds(ids);

  @override
  Future<void> updateRegionsData(List<entity.Region> regions) =>
      _dao.updateData(regions);
}
