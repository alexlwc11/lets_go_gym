part of 'bookmarks_bloc.dart';

abstract class BookmarksEvent extends Equatable {
  const BookmarksEvent();

  @override
  List<Object?> get props => [];
}

class BookmarkUpdateRequested extends BookmarksEvent {
  final String itemId;

  const BookmarkUpdateRequested({
    required this.itemId,
  });
}

class BookmarkDataUpdateReceived extends BookmarksEvent {
  final Set<int> bookmarkedIds;

  const BookmarkDataUpdateReceived({required this.bookmarkedIds});
}
