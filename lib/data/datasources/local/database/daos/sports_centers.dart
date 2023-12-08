import 'package:drift/drift.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart';
import 'package:lets_go_gym/data/datasources/local/database/tables/districts.dart';
import 'package:lets_go_gym/data/datasources/local/database/tables/sports_centers.dart';
import 'package:lets_go_gym/domain/entities/sports_center/sports_center.dart'
    as entity;

part 'sports_centers.g.dart';

@DriftAccessor(tables: [SportsCenters, Districts])
class SportsCentersDao extends DatabaseAccessor<AppDatabase>
    with _$SportsCentersDaoMixin {
  SportsCentersDao(super.db);

  Future<List<SportsCenter>> findAll() => select(sportsCenters).get();

  Future<SportsCenter?> findById(int id) => (select(sportsCenters)
        ..where((sportsCenter) => sportsCenter.id.equals(id)))
      .getSingleOrNull();

  Future<List<SportsCenter>> findByDistrictId(int districtId) => (select(
          sportsCenters)
        ..where((sportsCenter) => sportsCenter.districtId.equals(districtId)))
      .get();

  Future<List<SportsCenter>> findByRegionId(int regionId) async {
    final districtIdsInRegion = (await (select(districts)
              ..where((district) => district.regionId.equals(regionId)))
            .get())
        .map((d) => d.id);

    return (select(sportsCenters)
          ..where((sportsCenter) =>
              sportsCenter.districtId.isIn(districtIdsInRegion)))
        .get();
  }

  Future<void> updateData(List<entity.SportsCenter> newSportsCenters) {
    final records = newSportsCenters.map(SportsCentersDataConverter.fromEntity);

    return transaction(() async {
      await (delete(sportsCenters)
            ..where((sportsCenter) =>
                sportsCenter.id.isNotIn(newSportsCenters.map((sc) => sc.id))))
          .go();

      await batch((batch) {
        batch.insertAllOnConflictUpdate(sportsCenters, records);
      });
    });
  }
}
