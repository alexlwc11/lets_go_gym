import 'package:lets_go_gym/core/constants.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/models/bookmark/bookmark_dto.dart';

abstract class BookmarksRemoteDataSource {
  Future<List<BookmarkDto>> getBookmarks();
  Future<BookmarkDto> addBookmark(int sportsCenterId);
  Future<void> removeBookmark(int bookmarkId);
}

class BookmarksRemoteDataSourceImpl implements BookmarksRemoteDataSource {
  final AuthClient _authClient;

  static String get _bookmarksUrl => '${ApiConstants.baseUrl}/bookmarks';

  BookmarksRemoteDataSourceImpl({
    required AuthClient authClient,
  }) : _authClient = authClient;

  @override
  Future<List<BookmarkDto>> getBookmarks() async {
    try {
      final response = await _authClient.get(_bookmarksUrl);
      final responseData = response.data as Map<String, dynamic>;

      final bookmarksData =
          responseData['bookmarks'] as List<Map<String, dynamic>>;

      return bookmarksData.map(BookmarkDto.fromJson).toList();
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<BookmarkDto> addBookmark(int sportsCenterId) async {
    try {
      final bookmarkDto = BookmarkDto(sportsCenterId: sportsCenterId);
      final response =
          await _authClient.post(_bookmarksUrl, data: bookmarkDto.toJson());
      final responseData = response.data as Map<String, dynamic>;

      final bookmarksData = responseData['bookmark'];

      return BookmarkDto.fromJson(bookmarksData);
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> removeBookmark(int bookmarkId) async {
    try {
      final bookmarkDto = BookmarkDto(id: bookmarkId);

      await _authClient.delete(_bookmarksUrl, data: bookmarkDto.toJson());
    } catch (error) {
      rethrow;
    }
  }
}
