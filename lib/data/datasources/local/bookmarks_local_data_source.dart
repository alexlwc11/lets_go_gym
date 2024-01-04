import 'package:lets_go_gym/data/datasources/local/database/daos/bookmarks.dart';
import 'package:lets_go_gym/data/datasources/local/database/database.dart';
import 'package:lets_go_gym/domain/entities/bookmark/bookmark.dart' as entity;

abstract class BookmarksLocalDataSource {
  Future<List<Bookmark>> getAllBookmarks();
  Stream<List<Bookmark>> getAllBookmarksAsStream();
  Future<bool> checkIfBookmarked(int sportsCenterId);
  Stream<bool> checkIfBookmarkedAsStream(int sportsCenterId);
  Future<void> insertOrUpdateBookmark(entity.Bookmark bookmark);
  Future<void> insertLocalRecord(int sportsCenterId);
  Future<void> deleteBookmark(int sportsCenterId);
}

class BookmarksLocalDataSourceImpl implements BookmarksLocalDataSource {
  final BookmarksDao _dao;

  BookmarksLocalDataSourceImpl({required BookmarksDao dao}) : _dao = dao;

  @override
  Future<List<Bookmark>> getAllBookmarks() => _dao.findAll();

  @override
  Stream<List<Bookmark>> getAllBookmarksAsStream() => _dao.findAllAsStream();

  @override
  Future<bool> checkIfBookmarked(int sportsCenterId) =>
      _dao.checkIfBookmarked(sportsCenterId);

  @override
  Stream<bool> checkIfBookmarkedAsStream(int sportsCenterId) =>
      _dao.checkIfBookmarkedAsStream(sportsCenterId);

  @override
  Future<void> insertOrUpdateBookmark(entity.Bookmark bookmark) =>
      _dao.insertOrUpdateRecord(bookmark);

  @override
  Future<void> insertLocalRecord(int sportsCenterId) =>
      _dao.insertLocalRecord(sportsCenterId);

  @override
  Future<void> deleteBookmark(int sportsCenterId) =>
      _dao.deleteBySportsCenterId(sportsCenterId);
}
