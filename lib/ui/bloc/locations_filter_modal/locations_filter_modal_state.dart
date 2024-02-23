part of 'locations_filter_modal_bloc.dart';

sealed class LocationsFilterModalState extends Equatable {
  const LocationsFilterModalState();

  @override
  List<Object?> get props => [];
}

class LocationsFilterModalDataLoadingInProgress
    extends LocationsFilterModalState {}

class LocationsFilterModalDataUpdated extends LocationsFilterModalState {
  final List<RegionChipItemVM> regionChipItemVMs;
  final List<DistrictChipItemVM> districtChipItemVMs;

  const LocationsFilterModalDataUpdated({
    required this.regionChipItemVMs,
    required this.districtChipItemVMs,
  });

  @override
  List<Object?> get props => [
        regionChipItemVMs,
        districtChipItemVMs,
      ];
}
