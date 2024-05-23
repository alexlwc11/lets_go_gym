import 'package:lets_go_gym/core/di/di.dart';
import 'package:lets_go_gym/ui/bloc/bookmarks/bookmarks_bloc.dart';
import 'package:lets_go_gym/ui/bloc/entry/entry_bloc.dart';
import 'package:lets_go_gym/ui/bloc/languages/language_settings_cubit.dart';
import 'package:lets_go_gym/ui/bloc/location/location_bloc.dart';
import 'package:lets_go_gym/ui/bloc/locations/locations_bloc.dart';
import 'package:lets_go_gym/ui/bloc/locations_filter_modal/locations_filter_modal_bloc.dart';
import 'package:lets_go_gym/ui/bloc/themes/theme_settings_cubit.dart';
import 'package:lets_go_gym/ui/cubits/locations_filter/locations_filter_cubit.dart';
import 'package:lets_go_gym/ui/models/locations_filter.dart';

void initBlocInjections() {
  sl.registerFactory(() => EntryBloc(
        getAppInfo: sl(),
        getCurrentDataInfo: sl(),
        updateRegionsData: sl(),
        updateDistrictsData: sl(),
        updateSportsCentersData: sl(),
        updateRegionDataLastUpdated: sl(),
        updateDistrictDataLastUpdated: sl(),
        updateSportsCenterDataLastUpdated: sl(),
      ));
  sl.registerFactory(() => BookmarksBloc(
        getAllBookmarksAsStream: sl(),
        removeBookmark: sl(),
        getRegionsByIds: sl(),
        getDistrictsByIds: sl(),
        getSportsCentersByIds: sl(),
      ));
  sl.registerFactory(() => LocationsBloc(
        getAllRegions: sl(),
        getAllDistricts: sl(),
        getAllSportsCenters: sl(),
        getAllBookmarks: sl(),
        getAllBookmarksAsStream: sl(),
        addBookmark: sl(),
        removeBookmark: sl(),
      ));
  sl.registerFactoryParam<LocationBloc, int, dynamic>(
      (sportsCenterId, _) => LocationBloc(
            sportsCenterId: sportsCenterId,
            getRegionById: sl(),
            getDistrictById: sl(),
            getSportsCenterById: sl(),
            getSportsCenterDetailsUrl: sl(),
            checkIfBookmarked: sl(),
            checkIfBookmarkedAsStream: sl(),
            addBookmark: sl(),
            removeBookmark: sl(),
          ));
  sl.registerFactoryParam<LocationsFilterModalBloc, LocationsFilter, dynamic>(
      (locationsFilter, _) => LocationsFilterModalBloc(
            currentFilter: locationsFilter,
            getAllRegions: sl(),
            getAllDistricts: sl(),
          ));
  sl.registerFactory(() => LanguageSettingsCubit(
        getCurrentLanguageSettings: sl(),
        updateLanguageSettings: sl(),
      ));
  sl.registerFactory(() => ThemeSettingsCubit(
        getCurrentThemeSettings: sl(),
        updateThemeSettings: sl(),
      ));
  // Cubit
  sl.registerFactory(
    () => LocationsFilterCubit(),
  );
}
