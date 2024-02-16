import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'locations_filter.dart';

class LocationsFilterCubit extends Cubit<LocationsFilter> {
  LocationsFilterCubit() : super(const LocationsFilter());

  LocationsFilter _currentFilters = const LocationsFilter();

  void updateFilters(Set<int> regionIds, Set<int> districtIds) {
    _currentFilters = LocationsFilter(
      regionIds: regionIds,
      districtIds: districtIds,
    );

    emit(_currentFilters);
  }

  void clearFilters() {
    _currentFilters = const LocationsFilter();

    emit(_currentFilters);
  }
}
