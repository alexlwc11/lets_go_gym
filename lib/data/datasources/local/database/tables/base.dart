import 'package:drift/drift.dart';

class BaseTable extends Table {
  IntColumn get id => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
