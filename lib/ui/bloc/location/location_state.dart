part of 'location_bloc.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationDataLoadingInProgress extends LocationState {}

class LocationDataUpdated extends LocationState {
  final LocationVM vm;

  const LocationDataUpdated({required this.vm});

  @override
  List<Object?> get props => [vm];
}

class LocationDataUpdateFailure extends LocationState {
  final LocationVM vm;

  const LocationDataUpdateFailure({required this.vm});

  @override
  List<Object?> get props => [vm];
}
