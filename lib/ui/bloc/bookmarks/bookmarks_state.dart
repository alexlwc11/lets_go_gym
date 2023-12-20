part of 'bookmarks_bloc.dart';

sealed class BookmarksState extends Equatable {
  const BookmarksState();

  @override
  List<Object?> get props => [];
}

class BookmarksLoadingInProgress extends BookmarksState {}

class BookmarksDataUpdated extends BookmarksState {
  final List<BookmarkItemVM> displayItemVMs;

  const BookmarksDataUpdated({required this.displayItemVMs});

  @override
  List<Object?> get props => displayItemVMs
      .map((vm) =>
  '${vm.region.id}-${vm.district.id}-${vm.sportsCenter.id}')
      .toList();
}

class BookmarksDataUpdateFailure extends BookmarksState {}
