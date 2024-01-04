import 'package:drift/drift.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart';
import 'package:lets_go_gym/data/datasources/local/database/tables/bookmarks.dart';
import 'package:lets_go_gym/domain/entities/bookmark/bookmark.dart' as entity;

part 'bookmarks.g.dart';

@DriftAccessor(tables: [Bookmarks])
class BookmarksDao extends DatabaseAccessor<AppDatabase>
    with _$BookmarksDaoMixin {
  BookmarksDao(super.db);

  Future<List<Bookmark>> findAll() => select(bookmarks).get();

  Stream<List<Bookmark>> findAllAsStream() => select(bookmarks).watch();

  Future<bool> checkIfBookmarked(int sportsCenterId) async {
    final record = await (select(bookmarks)
          ..where((record) => record.sportsCenterId.equals(sportsCenterId)))
        .getSingleOrNull();

    return record != null;
  }

  Stream<bool> checkIfBookmarkedAsStream(int sportsCenterId) =>
      (select(bookmarks)
            ..where((record) => record.sportsCenterId.equals(sportsCenterId)))
          .watchSingleOrNull()
          .map((bookmark) => bookmark != null);

  Future<void> insertOrUpdateRecord(entity.Bookmark bookmark) {
    final newRecord = BookmarksDataConverter.fromEntity(bookmark);

    return into(bookmarks).insertOnConflictUpdate(newRecord);
  }

  Future<void> insertLocalRecord(int sportsCenterId) =>
      into(bookmarks).insertOnConflictUpdate(
          BookmarksCompanion(sportsCenterId: Value(sportsCenterId)));

  Future<void> deleteById(int id) =>
      (delete(bookmarks)..where((t) => t.id.equals(id))).go();

  Future<void> deleteBySportsCenterId(int sportCenterId) =>
      (delete(bookmarks)..where((t) => t.sportsCenterId.equals(sportCenterId)))
          .go();
}
