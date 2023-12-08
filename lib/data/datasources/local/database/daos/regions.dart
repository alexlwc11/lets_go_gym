import 'package:drift/drift.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart';
import 'package:lets_go_gym/data/datasources/local/database/tables/regions.dart';
import 'package:lets_go_gym/domain/entities/region/region.dart' as entity;

part 'regions.g.dart';

@DriftAccessor(tables: [Regions])
class RegionsDao extends DatabaseAccessor<AppDatabase> with _$RegionsDaoMixin {
  RegionsDao(super.db);

  Future<List<Region>> findAll() => select(regions).get();

  Future<Region?> findById(int id) =>
      (select(regions)..where((region) => region.id.equals(id)))
          .getSingleOrNull();

  Future<void> updateData(List<entity.Region> newRegions) {
    final records = newRegions.map(RegionsDataConverter.fromEntity);

    return transaction(() async {
      await (delete(regions)
            ..where((region) => region.id.isNotIn(newRegions.map((r) => r.id))))
          .go();

      await batch((batch) {
        batch.insertAllOnConflictUpdate(regions, records);
      });
    });
  }
}
