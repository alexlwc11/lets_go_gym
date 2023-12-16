part of 'locations_bloc.dart';

sealed class LocationsState extends Equatable {
  const LocationsState();

  @override
  List<Object?> get props => [];
}

class LocationsDataLoadingInProgress extends LocationsState {}

class LocationsDataUpdated extends LocationsState {
  final List<LocationItemVM> displayItemVMs;

  const LocationsDataUpdated({required this.displayItemVMs});

  @override
  List<Object?> get props => displayItemVMs
      .map((vm) =>
          '${vm.region.id}-${vm.district.id}-${vm.sportsCenter.id}-${vm.bookmarked}')
      .toList();
}

class LocationsDataUpdateFailure extends LocationsState {}
