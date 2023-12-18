import 'package:lets_go_gym/data/datasources/local/bookmarks_local_data_source.dart';
import 'package:lets_go_gym/data/datasources/local/database/tables/bookmarks.dart';
import 'package:lets_go_gym/data/datasources/remote/bookmarks_remote_data_source.dart';
import 'package:lets_go_gym/data/models/bookmark/bookmark_dto.dart';
import 'package:lets_go_gym/domain/entities/bookmark/bookmark.dart';
import 'package:lets_go_gym/domain/repositories/bookmarks_repository.dart';

class BookmarksRepositoryImpl implements BookmarksRepository {
  final BookmarksLocalDataSource localDataSource;
  final BookmarksRemoteDataSource remoteDataSource;

  BookmarksRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<Bookmark>> getAllBookmarks() async =>
      (await localDataSource.getAllBookmarks())
          .map((record) => record.toEntity)
          .toList();

  @override
  Stream<List<Bookmark>> getAllBookmarksAsStream() => localDataSource
      .getAllBookmarksAsStream()
      .map((recordList) => recordList.map((record) => record.toEntity).toList())
      .asBroadcastStream();

  @override
  Future<void> addBookmark(int sportsCenterId) async {
    try {
      // TODO API request, then store the result
      // final dto = await remoteDataSource.addBookmark(sportsCenterId);
      //
      // final bookmark = dto.toEntity;
      //
      // await localDataSource.insertOrUpdateBookmark(bookmark);

      // temporarily create record in local database
      await localDataSource.insertLocalRecord(sportsCenterId);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> removeBookmark(int bookmarkId) async {
    try {
      // TODO API request
      // await remoteDataSource.removeBookmark(bookmarkId);

      await localDataSource.deleteBookmark(bookmarkId);
    } catch (error) {
      rethrow;
    }
  }
}
