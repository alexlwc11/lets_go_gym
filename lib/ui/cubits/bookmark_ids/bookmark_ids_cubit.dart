import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/add_bookmark.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/get_all_bookmarks_as_stream.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/remove_bookmark.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/update_bookmarks.dart';
import 'package:rxdart/rxdart.dart';

class BookmarkIdsCubit extends Cubit<Set<int>> {
  final GetAllBookmarksAsStream _getAllBookmarksAsStream;
  final AddBookmark _addBookmark;
  final RemoveBookmark _removeBookmark;
  final UpdateBookmarks _updateBookmarks;

  BookmarkIdsCubit({
    required GetAllBookmarksAsStream getAllBookmarksAsStream,
    required AddBookmark addBookmark,
    required RemoveBookmark removeBookmark,
    required UpdateBookmarks updateBookmarks,
  })  : _getAllBookmarksAsStream = getAllBookmarksAsStream,
        _addBookmark = addBookmark,
        _removeBookmark = removeBookmark,
        _updateBookmarks = updateBookmarks,
        super({}) {
    _setupSubscription();
  }

  late final StreamSubscription _subscription;

  void _setupSubscription() {
    _subscription = _getAllBookmarksAsStream
        .execute()
        .throttleTime(
          const Duration(milliseconds: 300),
          trailing: true,
        )
        .distinct()
        .listen(
          (bookmarkedIds) => emit(bookmarkedIds),
        );
  }

  Future<void> addBookmark(int sportsCenterId) async {
    try {
      await _addBookmark.execute(sportsCenterId);
    } catch (error) {
      log("BookmarkIdsCubit#bookmark: $error");
    }
  }

  Future<void> removeBookmark(int sportsCenterId) async {
    try {
      await _removeBookmark.execute(sportsCenterId);
    } catch (error) {
      log("BookmarkIdsCubit#unBookmark: $error");
    }
  }

  void updateBookmark(Set<int> sportsCenterIds) async {
    try {
      _updateBookmarks.execute(sportsCenterIds);
    } catch (error) {
      log("BookmarkIdsCubit#updateBookmark: $error");
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    super.close();
  }
}
