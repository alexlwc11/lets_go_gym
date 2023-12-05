import 'package:drift/drift.dart';
import 'package:lets_go_gym/data/datasources/local/database/tables/base.dart';

@TableIndex(name: 'district_region_id', columns: {#regionId})
class District extends BaseTable {
  IntColumn get regionId => integer()();
  TextColumn get nameEn => text()();
  TextColumn get nameZh => text()();
}
