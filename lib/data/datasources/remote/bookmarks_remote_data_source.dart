import 'dart:developer';

import 'package:lets_go_gym/core/utils/constant/constants.dart';
import 'package:lets_go_gym/data/datasources/remote/api/api_client.dart';
import 'package:lets_go_gym/data/models/bookmark/bookmark_dto.dart';

abstract class BookmarksRemoteDataSource {
  Future<BookmarkDto> getBookmarks();
  Future<void> putBookmarks(Set<int> sportsCenterIds);
}

class BookmarksRemoteDataSourceImpl implements BookmarksRemoteDataSource {
  final AuthClient _authClient;

  static String get _bookmarksUrl => '${ApiConstants.baseUrl}/bookmarks';

  BookmarksRemoteDataSourceImpl({
    required AuthClient authClient,
  }) : _authClient = authClient;

  @override
  Future<BookmarkDto> getBookmarks() async {
    try {
      final response = await _authClient.get(_bookmarksUrl);
      final responseData = response.data as Map<String, dynamic>;

      return BookmarkDto.fromJson(responseData);
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }

  @override
  Future<void> putBookmarks(Set<int> sportsCenterIds) async {
    try {
      final bookmarkDto = BookmarkDto(sportsCenterIds: sportsCenterIds);
      await _authClient.post(_bookmarksUrl, data: bookmarkDto.toJson());
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }
}
