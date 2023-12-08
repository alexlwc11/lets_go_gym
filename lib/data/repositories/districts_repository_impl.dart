import 'package:lets_go_gym/data/datasources/local/database/tables/districts.dart';
import 'package:lets_go_gym/data/datasources/local/districts_local_data_source.dart';
import 'package:lets_go_gym/domain/entities/district/district.dart';
import 'package:lets_go_gym/domain/repositories/districts_repository.dart';

class DistrictsRepositoryImpl implements DistrictsRepository {
  final DistrictsLocalDataSource localDataSource;

  DistrictsRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<List<District>> getAllDistricts() async =>
      (await localDataSource.getAllDistricts())
          .map((record) => record.toEntity)
          .toList();

  @override
  Future<District?> getDistrictById(int id) async =>
      (await localDataSource.getDistrictById(id))?.toEntity;

  @override
  Future<List<District>> getDistrictsByRegionId(int regionId) async =>
      (await localDataSource.getDistrictsByRegionId(regionId))
          .map((record) => record.toEntity)
          .toList();

  @override
  Future<void> updateDistrictData(List<District> districts) =>
      localDataSource.updateDistrictsData(districts);
}
