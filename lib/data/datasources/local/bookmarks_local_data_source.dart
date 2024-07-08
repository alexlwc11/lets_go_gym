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
  Set<int> getAllBookmarks() =>
      (json.decode(_sharedPreferences.getString(_bookmarksKey) ?? '[]')
              as List<int>)
          .toSet();

  @override
  Stream<Set<int>> getAllBookmarksAsStream() =>
      _bookmarksStream.asBroadcastStream();

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
    final currentBookmarksJson = _sharedPreferences.getString(_bookmarksKey);

    final Set<int> updatedBookmarks = {sportsCenterId};
    if (currentBookmarksJson != null) {
      final currentBookmarks = (json.decode(currentBookmarksJson) as List<int>);
      // already bookmarked, no need to update
      if (currentBookmarks.contains(sportsCenterId)) return;

      updatedBookmarks.addAll(currentBookmarks);
    }

    await _sharedPreferences.setString(
        _bookmarksKey, json.encode(updatedBookmarks.toList()));

    _bookmarksStream.add(updatedBookmarks);
  }

  @override
  Future<void> removeBookmark(int sportsCenterId) async {
    final currentBookmarksJson = _sharedPreferences.getString(_bookmarksKey);
    if (currentBookmarksJson == null) return;

    final updatedBookmarks = json.decode(currentBookmarksJson) as List<int>;
    // not bookmarked, not need to update
    if (!updatedBookmarks.contains(sportsCenterId)) return;

    updatedBookmarks.remove(sportsCenterId);

    await _sharedPreferences.setString(
        _bookmarksKey, json.encode(updatedBookmarks));

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
