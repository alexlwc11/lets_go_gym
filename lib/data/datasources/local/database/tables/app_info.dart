import 'package:drift/drift.dart';

class AppInfo extends Table {
  DateTimeColumn get regionDataLastUpdatedAt => dateTime()();
  DateTimeColumn get districtDataLastUpdatedAt => dateTime()();
  DateTimeColumn get sportsCenterDataLastUpdatedAt => dateTime()();
}
