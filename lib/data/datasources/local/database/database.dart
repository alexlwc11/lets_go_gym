import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:lets_go_gym/data/datasources/local/database/daos/districts.dart';
import 'package:lets_go_gym/data/datasources/local/database/daos/regions.dart';
import 'package:lets_go_gym/data/datasources/local/database/daos/sports_centers.dart';
import 'package:lets_go_gym/data/datasources/local/database/tables/bookmarks.dart';
import 'package:lets_go_gym/data/datasources/local/database/tables/districts.dart';
import 'package:lets_go_gym/data/datasources/local/database/tables/regions.dart';
import 'package:lets_go_gym/data/datasources/local/database/tables/sports_centers.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

@DriftDatabase(
    tables: [Regions, Districts, SportsCenters, Bookmarks],
    daos: [RegionsDao, DistrictsDao, SportsCentersDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          /// added [Bookmarks] table in version 2
          await m.createTable(bookmarks);
        }
        if (from < 3) {
          /// added [latitude] and [longitude] columns to [SportsCenters] table in version 3
          await m.addColumn(sportsCenters, sportsCenters.latitude);
          await m.addColumn(sportsCenters, sportsCenters.longitude);
        }
        if (from < 4) {
          /// rename [phone_number] column to [phone_numbers] in [SportsCenters] table in version 4
          await m.renameColumn(
              sportsCenters, "phone_number", sportsCenters.phoneNumbers);
        }
        if (from < 5) {
          /// drop [Bookmarks] table in version5
          await m.drop(bookmarks);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(join(dbFolder.path, 'app_db.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cachebase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
