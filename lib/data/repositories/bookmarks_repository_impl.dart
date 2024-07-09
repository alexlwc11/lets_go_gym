import 'package:lets_go_gym/data/datasources/local/bookmarks_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/remote/bookmarks_remote_data_source.dart';
import 'package:lets_go_gym/domain/repositories/bookmarks_repository.dart';

class BookmarksRepositoryImpl implements BookmarksRepository {
  final BookmarksLocalDataSource localDataSource;
  final BookmarksRemoteDataSource remoteDataSource;

  BookmarksRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<void> getLatestBookmarks() async {
    try {
      final bookmarks =
          (await remoteDataSource.getBookmarks()).sportsCenterIds ?? {};

      await localDataSource.updateBookmarks(bookmarks);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Set<int> getAllBookmarks() {
    try {
      return localDataSource.getAllBookmarks();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Stream<Set<int>> getAllBookmarksAsStream() =>
      localDataSource.getAllBookmarksAsStream();

  @override
  bool checkIfBookmarked(int sportsCenterId) {
    try {
      return localDataSource.checkIfBookmarked(sportsCenterId);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Stream<bool> checkIfBookmarkedAsStream(int sportsCenterId) => localDataSource
      .checkIfBookmarkedAsStream(sportsCenterId)
      .asBroadcastStream();

  @override
  Future<void> addBookmark(int sportsCenterId) async {
    try {
      final bookmarks = getAllBookmarks();
      if (bookmarks.contains(sportsCenterId)) return;

      await remoteDataSource.putBookmarks(bookmarks..add(sportsCenterId));

      await localDataSource.addBookmark(sportsCenterId);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> removeBookmark(int sportsCenterId) async {
    try {
      final bookmarks = getAllBookmarks();
      if (!bookmarks.contains(sportsCenterId)) return;

      await remoteDataSource.putBookmarks(bookmarks..remove(sportsCenterId));

      await localDataSource.removeBookmark(sportsCenterId);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> updateBookmarks(Set<int> sportsCenterIds) async {
    try {
      await remoteDataSource.putBookmarks(sportsCenterIds);

      await localDataSource.updateBookmarks(sportsCenterIds);
    } catch (error) {
      rethrow;
    }
  }
}
