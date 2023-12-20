import 'package:lets_go_gym/data/datasources/local/database/tables/districts.dart';
import 'package:lets_go_gym/data/datasources/local/districts_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/districts_remote_data_source.dart';
import 'package:lets_go_gym/data/models/district/district_dto.dart';
import 'package:lets_go_gym/domain/entities/district/district.dart';
import 'package:lets_go_gym/domain/repositories/districts_repository.dart';

class DistrictsRepositoryImpl implements DistrictsRepository {
  final DistrictsLocalDataSource localDataSource;
  final DistrictsRemoteDataSource remoteDataSource;

  DistrictsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
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
  Future<List<District>> getDistrictsByIds(List<int> ids) async =>
      (await localDataSource.getDistrictsByIds(ids))
          .map((record) => record.toEntity)
          .toList();

  @override
  Future<List<District>> getDistrictsByRegionId(int regionId) async =>
      (await localDataSource.getDistrictsByRegionId(regionId))
          .map((record) => record.toEntity)
          .toList();

  @override
  Future<void> updateDistrictData() async {
    final List<District> districts =
        (await remoteDataSource.getLatestDistricts())
            .map((dto) => dto.toEntity)
            .toList();

    await localDataSource.updateDistrictsData(districts);
  }
}
