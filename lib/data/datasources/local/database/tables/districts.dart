import 'package:drift/drift.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart'
    as db;
import 'package:lets_go_gym/data/datasources/local/database/tables/base.dart';
import 'package:lets_go_gym/domain/entities/district/district.dart';

@TableIndex(name: 'districts_region_id', columns: {#regionId})
class Districts extends BaseTable {
  IntColumn get regionId => integer()();
  TextColumn get nameEn => text()();
  TextColumn get nameZh => text()();
}

extension DistrictsDataConverter on db.District {
  District get toEntity => District(
        id: id,
        regionId: regionId,
        nameEn: nameEn,
        nameZh: nameZh,
      );

  static db.District fromEntity(District district) => db.District(
        id: district.id,
        regionId: district.regionId,
        nameEn: district.nameEn,
        nameZh: district.nameZh,
      );
}
