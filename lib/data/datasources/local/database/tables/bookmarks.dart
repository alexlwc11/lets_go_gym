import 'package:drift/drift.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart'
    as db;
import 'package:lets_go_gym/data/datasources/local/database/tables/base.dart';
import 'package:lets_go_gym/domain/entities/bookmark/bookmark.dart';

class Bookmarks extends BaseTable {
  IntColumn get sportsCenterId => integer().unique()();
}

extension BookmarksDataConverter on db.Bookmark {
  Bookmark get toEntity => Bookmark(
        id: id,
        sportsCenterId: sportsCenterId,
      );

  static db.Bookmark fromEntity(Bookmark bookmark) => db.Bookmark(
        id: bookmark.id,
        sportsCenterId: bookmark.sportsCenterId,
      );
}
