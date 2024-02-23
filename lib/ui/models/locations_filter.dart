import 'package:equatable/equatable.dart';

class LocationsFilter extends Equatable {
  final Set<int> regionIds;
  final Set<int> districtIds;

  const LocationsFilter({
    this.regionIds = const {},
    this.districtIds = const {},
  });

  bool get isEmpty => regionIds.isEmpty && districtIds.isEmpty;

  LocationsFilter removeAllRegion() {
    return LocationsFilter(districtIds: districtIds);
  }

  LocationsFilter removeAllDistrict() {
    return LocationsFilter(regionIds: regionIds);
  }

  LocationsFilter remove({
    int? regionId,
    int? districtId,
  }) {
    final updatedRegionIds = regionIds.toSet();
    if (regionId != null) {
      updatedRegionIds.remove(regionId);
    }
    final updatedDistrictIds = districtIds.toSet();
    if (districtId != null) {
      updatedDistrictIds.remove(districtId);
    }

    return LocationsFilter(
      regionIds: updatedRegionIds,
      districtIds: updatedDistrictIds,
    );
  }

  LocationsFilter add({
    int? regionId,
    int? districtId,
  }) {
    final updatedRegionIds = regionIds.toSet();
    if (regionId != null) {
      updatedRegionIds.add(regionId);
    }
    final updatedDistrictIds = districtIds.toSet();
    if (districtId != null) {
      updatedDistrictIds.add(districtId);
    }

    return LocationsFilter(
      regionIds: updatedRegionIds,
      districtIds: updatedDistrictIds,
    );
  }

  @override
  List<Object?> get props => [
        ...regionIds.map((id) => 'region-$id'),
        ...districtIds.map((id) => 'district-$id'),
      ];
}
