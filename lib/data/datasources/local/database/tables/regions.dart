import 'package:drift/drift.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart'
    as db;
import 'package:lets_go_gym/data/datasources/local/database/tables/base.dart';
import 'package:lets_go_gym/domain/entities/region/region.dart';

class Regions extends BaseTable {
  TextColumn get code => text().withLength(min: 2, max: 3)();
  TextColumn get nameEn => text()();
  TextColumn get nameZh => text()();
}

extension RegionsDataConverter on db.Region {
  Region get toEntity => Region(
        id: id,
        code: code,
        nameEn: nameEn,
        nameZh: nameZh,
      );

  static db.Region fromEntity(Region region) => db.Region(
        id: region.id,
        code: region.code,
        nameEn: region.nameEn,
        nameZh: region.nameZh,
      );
}
