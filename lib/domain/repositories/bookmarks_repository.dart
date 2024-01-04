import 'package:lets_go_gym/domain/entities/bookmark/bookmark.dart';

abstract class BookmarksRepository {
  Future<List<Bookmark>> getAllBookmarks();
  Stream<List<Bookmark>> getAllBookmarksAsStream();
  Future<bool> checkIfBookmarked(int sportsCenterId);
  Stream<bool> checkIfBookmarkedAsStream(int sportsCenterId);
  Future<void> addBookmark(int sportsCenterId);
  Future<void> removeBookmark(int sportsCenterId);
}
