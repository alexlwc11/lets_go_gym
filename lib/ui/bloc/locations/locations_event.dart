part of 'locations_bloc.dart';

abstract class LocationsEvent extends Equatable {
  const LocationsEvent();

  @override
  List<Object?> get props => [];
}

class LocationsDataRequested extends LocationsEvent {}

class LocationsFilterUpdated extends LocationsEvent {
  final LocationsFilter updateFilter;

  const LocationsFilterUpdated({
    required this.updateFilter,
  });
}
