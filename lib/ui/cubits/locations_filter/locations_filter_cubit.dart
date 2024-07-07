import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/ui/models/locations_filter.dart';

class LocationsFilterCubit extends Cubit<LocationsFilter> {
  LocationsFilterCubit() : super(const LocationsFilter());

  LocationsFilter _currentFilters = const LocationsFilter();

  void updateFilters(LocationsFilter updatedFilter) {
    _currentFilters = updatedFilter;

    emit(_currentFilters);
  }

  void clearFilters() {
    _currentFilters = const LocationsFilter();

    emit(_currentFilters);
  }
}
