import 'package:lets_go_gym/data/datasources/local/database/tables/sports_centers.dart';
import 'package:lets_go_gym/data/datasources/local/sports_centers_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/sports_centers_data_source.dart';
import 'package:lets_go_gym/data/models/sports_center/sports_center_dto.dart';
import 'package:lets_go_gym/domain/entities/sports_center/sports_center.dart';
import 'package:lets_go_gym/domain/repositories/sports_centers_repository.dart';

class SportsCentersRepositoryImpl implements SportsCentersRepository {
  final SportsCentersLocalDataSource localDataSource;
  final SportsCentersRemoteDataSource remoteDataSource;

  SportsCentersRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<SportsCenter>> getAllSportsCenters() async =>
      (await localDataSource.getAllSportsCenters())
          .map((record) => record.toEntity)
          .toList();

  @override
  Future<SportsCenter?> getSportsCenterById(int id) async =>
      (await localDataSource.getSportsCenterById(id))?.toEntity;

  @override
  Future<List<SportsCenter>> getSportsCentersByDistrictId(
          int districtId) async =>
      (await localDataSource.getSportsCentersByDistrictId(districtId))
          .map((record) => record.toEntity)
          .toList();

  @override
  Future<List<SportsCenter>> getSportsCentersByRegionId(int regionId) async =>
      (await localDataSource.getSportsCentersByRegionId(regionId))
          .map((record) => record.toEntity)
          .toList();

  @override
  Future<void> updateSportsCenterData() async {
    final List<SportsCenter> sportsCenters =
        (await remoteDataSource.getLatestSportsCenters())
            .map((dto) => dto.toEntity)
            .toList();

    await localDataSource.updateSportsCentersData(sportsCenters);
  }
}
