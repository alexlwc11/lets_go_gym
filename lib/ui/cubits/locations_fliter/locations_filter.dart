part of 'locations_filter_cubit.dart';

class LocationsFilter extends Equatable {
  final Set<int> regionIds;
  final Set<int> districtIds;

  const LocationsFilter({
    this.regionIds = const {},
    this.districtIds = const {},
  });

  bool get isEmpty => regionIds.isEmpty && districtIds.isEmpty;

  @override
  List<Object?> get props => [
        ...regionIds.map((id) => 'region-$id'),
        ...districtIds.map((id) => 'district-$id'),
      ];
}
