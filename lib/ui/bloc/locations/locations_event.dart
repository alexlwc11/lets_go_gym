part of 'locations_bloc.dart';

abstract class LocationsEvent extends Equatable {
  const LocationsEvent();

  @override
  List<Object?> get props => [];
}

class LocationsDataRequested extends LocationsEvent {}

class BookmarkUpdateRequested extends LocationsEvent {
  final String itemId;

  const BookmarkUpdateRequested({
    required this.itemId,
  });
}

class BookmarkDataUpdateReceived extends LocationsEvent {
  final Set<int> bookmarkedIds;

  const BookmarkDataUpdateReceived({required this.bookmarkedIds});
}
