part of 'locations_filter_modal_bloc.dart';

abstract class LocationsFilterModalEvent extends Equatable {
  const LocationsFilterModalEvent();

  @override
  List<Object?> get props => [];
}

class LocationsFilterModalInitRequested extends LocationsFilterModalEvent {}

class AllRegionChipSelected extends LocationsFilterModalEvent {}

class RegionFilterUpdateRequested extends LocationsFilterModalEvent {
  final int regionId;
  final bool isSelected;

  const RegionFilterUpdateRequested({
    required this.regionId,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [regionId, isSelected];
}

class AllDistrictChipSelected extends LocationsFilterModalEvent {}

class DistrictFilterUpdateRequested extends LocationsFilterModalEvent {
  final int districtId;
  final bool isSelected;

  const DistrictFilterUpdateRequested({
    required this.districtId,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [districtId, isSelected];
}

class ApplyFilterRequested extends LocationsFilterModalEvent {
  final ValueSetter<LocationsFilter>? onLocationsFilterApply;

  const ApplyFilterRequested({this.onLocationsFilterApply});

  @override
  List<Object?> get props => [onLocationsFilterApply];
}
