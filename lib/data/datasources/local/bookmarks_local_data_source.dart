import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BookmarksLocalDataSource {
  Set<int> getAllBookmarks();
  Stream<Set<int>> getAllBookmarksAsStream();
  bool checkIfBookmarked(int sportsCenterId);
  Stream<bool> checkIfBookmarkedAsStream(int sportsCenterId);
  Future<void> addBookmark(int sportsCenterId);
  Future<void> removeBookmark(int sportsCenterId);
  Future<void> updateBookmarks(Set<int> sportsCenterIds);
  Future<void> dispose();
}

const _bookmarksKey = "bookmarkedLocationIds";

class BookmarksLocalDataSourceImpl implements BookmarksLocalDataSource {
  final SharedPreferences _sharedPreferences;

  BookmarksLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final BehaviorSubject<Set<int>> _bookmarksStream = BehaviorSubject();

  @override
  Set<int> getAllBookmarks() {
    return (json.decode(_sharedPreferences.getString(_bookmarksKey) ?? '[]')
            as List<dynamic>)
        .cast<int>()
        .toSet();
  }

  @override
  Stream<Set<int>> getAllBookmarksAsStream() {
    _bookmarksStream.add(getAllBookmarks());

    return _bookmarksStream.asBroadcastStream();
  }

  @override
  bool checkIfBookmarked(int sportsCenterId) {
    return getAllBookmarks().contains(sportsCenterId);
  }

  @override
  Stream<bool> checkIfBookmarkedAsStream(int sportsCenterId) =>
      getAllBookmarksAsStream()
          .map((updatedBookmarks) => updatedBookmarks.contains(sportsCenterId));

  @override
  Future<void> addBookmark(int sportsCenterId) async {
    final currentBookmarks = getAllBookmarks();

    final Set<int> updatedBookmarks = {sportsCenterId};
    if (currentBookmarks.contains(sportsCenterId)) return;

    updatedBookmarks.addAll(currentBookmarks);
    await _sharedPreferences.setString(
        _bookmarksKey, json.encode(updatedBookmarks.toList()));

    _bookmarksStream.add(updatedBookmarks);
  }

  @override
  Future<void> removeBookmark(int sportsCenterId) async {
    final currentBookmarks = getAllBookmarks();
    if (currentBookmarks.isEmpty) return;

    // not bookmarked, not need to update
    if (!currentBookmarks.contains(sportsCenterId)) return;

    final updatedBookmarks = currentBookmarks..remove(sportsCenterId);
    await _sharedPreferences.setString(
        _bookmarksKey, json.encode(updatedBookmarks.toList()));

    _bookmarksStream.add(updatedBookmarks.toSet());
  }

  @override
  Future<void> updateBookmarks(Set<int> sportsCenterIds) async {
    await _sharedPreferences.setString(
        _bookmarksKey, json.encode(sportsCenterIds.toList()));

    _bookmarksStream.add(sportsCenterIds);
  }

  @override
  Future<void> dispose() async {
    await _bookmarksStream.close();
  }
}
