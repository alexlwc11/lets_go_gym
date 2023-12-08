import 'package:lets_go_gym/data/datasources/local/database/tables/regions.dart';
import 'package:lets_go_gym/data/datasources/local/regions_local_data_source.dart';
import 'package:lets_go_gym/domain/entities/region/region.dart';
import 'package:lets_go_gym/domain/repositories/regions_repository.dart';

class RegionsRepositoryImpl implements RegionsRepository {
  final RegionsLocalDataSource localDataSource;

  RegionsRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<Region>> getAllRegions() async =>
      (await localDataSource.getAllRegions())
          .map((record) => record.toEntity)
          .toList();

  @override
  Future<Region?> getRegionById(int id) async =>
      (await localDataSource.getRegionById(id))?.toEntity;

  @override
  Future<void> updateRegionData(List<Region> regions) =>
      localDataSource.updateRegionsData(regions);
}
