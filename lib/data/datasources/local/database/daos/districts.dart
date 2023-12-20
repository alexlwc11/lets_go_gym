import 'package:drift/drift.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart';
import 'package:lets_go_gym/data/datasources/local/database/tables/districts.dart';
import 'package:lets_go_gym/domain/entities/district/district.dart' as entity;

part 'districts.g.dart';

@DriftAccessor(tables: [Districts])
class DistrictsDao extends DatabaseAccessor<AppDatabase>
    with _$DistrictsDaoMixin {
  DistrictsDao(super.db);

  Future<List<District>> findAll() => select(districts).get();

  Future<List<District>> findByIds(List<int> ids) =>
      (select(districts)..where((district) => district.id.isIn(ids))).get();

  Future<District?> findById(int id) =>
      (select(districts)..where((district) => district.id.equals(id)))
          .getSingleOrNull();

  Future<List<District>> findByRegionId(int regionId) => (select(districts)
        ..where((district) => district.regionId.equals(regionId)))
      .get();

  Future<void> updateData(List<entity.District> newDistricts) {
    final records = newDistricts.map(DistrictsDataConverter.fromEntity);

    return transaction(() async {
      await (delete(districts)
            ..where((district) =>
                district.id.isNotIn(newDistricts.map((d) => d.id))))
          .go();

      await batch((batch) {
        batch.insertAllOnConflictUpdate(districts, records);
      });
    });
  }
}
