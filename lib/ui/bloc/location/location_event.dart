part of 'location_bloc.dart';

abstract class LocationEvent {
  const LocationEvent();
}

class LocationDataRequested extends LocationEvent {
  final int sportsCenterId;

  const LocationDataRequested({required this.sportsCenterId});
}

class LocationIsBookmarkedUpdateReceived extends LocationEvent {
  final bool isBookmarked;

  const LocationIsBookmarkedUpdateReceived({required this.isBookmarked});
}

class BookmarkUpdateRequested extends LocationEvent {}
