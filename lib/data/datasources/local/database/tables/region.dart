import 'package:drift/drift.dart';
import 'package:lets_go_gym/data/datasources/local/database/tables/base.dart';

class Region extends BaseTable {
  TextColumn get code => text().withLength(min: 2, max: 3)();
  TextColumn get nameEn => text()();
  TextColumn get nameZh => text()();
}
