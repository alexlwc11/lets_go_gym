abstract class BookmarksRepository {
  Set<int> getAllBookmarks();
  Stream<Set<int>> getAllBookmarksAsStream();
  bool checkIfBookmarked(int sportsCenterId);
  Stream<bool> checkIfBookmarkedAsStream(int sportsCenterId);
  Future<void> addBookmark(int sportsCenterId);
  Future<void> removeBookmark(int sportsCenterId);
  Future<void> updateBookmarks(Set<int> sportsCenterIds);
}
