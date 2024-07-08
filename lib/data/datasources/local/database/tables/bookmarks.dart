import 'package:drift/drift.dart';
import 'package:lets_go_gym/data/datasources/local/database/tables/base.dart';

/*
    This table has been drop in version 5
 */
class Bookmarks extends BaseTable {
  IntColumn get sportsCenterId => integer().unique()();
}
