import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/domain/entities/district/district.dart';
import 'package:lets_go_gym/domain/entities/region/region.dart';
import 'package:lets_go_gym/domain/entities/sports_center/sports_center.dart';
import 'package:lets_go_gym/domain/usecases/districts/get_all_districts.dart';
import 'package:lets_go_gym/domain/usecases/regions/get_all_regions.dart';
import 'package:lets_go_gym/domain/usecases/sports_centers/get_all_sports_centers.dart';

part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final GetAllRegions getAllRegions;
  final GetAllDistricts getAllDistricts;
  final GetAllSportsCenters getAllSportsCenters;

  LocationsBloc({
    required this.getAllRegions,
    required this.getAllDistricts,
    required this.getAllSportsCenters,
  }) : super(LocationsDataLoadingInProgress()) {
    on<LocationsDataRequested>(_onLocationsDataRequested);
    on<BookmarkUpdateRequested>(_onBookmarkUpdateRequested);

    add(LocationsDataRequested());
  }

  List<Region> _regions = [];
  List<District> _districts = [];
  List<SportsCenter> _sportsCenters = [];
  List<LocationItemVM> _locationItemVMs = [];
  // TODO filter
  // for display
  List<LocationItemVM> _displayItemVMs = [];

  Future<void> _onLocationsDataRequested(
      LocationsDataRequested event, Emitter<LocationsState> emit) async {
    try {
      _regions = await _getAllRegions();

      _districts = await _getAllDistrict();

      _sportsCenters = await _getAllSportsCenter();

      _locationItemVMs = _convertDataToVMs(
        regions: _regions,
        districts: _districts,
        sportsCenters: _sportsCenters,
      );

      _displayItemVMs = _locationItemVMs.toList();
      emit(LocationsDataUpdated(displayItemVMs: _displayItemVMs.toList()));
    } catch (_) {
      emit(LocationsDataUpdateFailure());
    }
  }

  Future<void> _onBookmarkUpdateRequested(
      BookmarkUpdateRequested event, Emitter<LocationsState> emit) async {
    try {
      final targetIndex =
          _displayItemVMs.indexWhere((vm) => vm.itemId == event.itemId);
      if (targetIndex == -1) throw Exception('item not found');

      _displayItemVMs[targetIndex] = _displayItemVMs[targetIndex].copyWith(
        bookmarked: !_displayItemVMs[targetIndex].bookmarked,
      );

      emit(LocationsDataUpdated(displayItemVMs: _displayItemVMs.toList()));
    } catch (_) {
      // emit(LocationsDataUpdateFailure());
    }
  }

  Future<List<Region>> _getAllRegions() async {
    try {
      return await getAllRegions.execute();
    } catch (_) {
      log("Failed to get all regions");
      rethrow;
    }
  }

  Future<List<District>> _getAllDistrict() async {
    try {
      return await getAllDistricts.execute();
    } catch (_) {
      log("Failed to get all districts");
      rethrow;
    }
  }

  Future<List<SportsCenter>> _getAllSportsCenter() async {
    try {
      return await getAllSportsCenters.execute();
    } catch (_) {
      log("Failed to get all sports centers");
      rethrow;
    }
  }

  List<LocationItemVM> _convertDataToVMs({
    required List<Region> regions,
    required List<District> districts,
    required List<SportsCenter> sportsCenters,
  }) {
    return sportsCenters
        .map((sportsCenter) {
          final district = districts.firstWhereOrNull(
              (district) => district.id == sportsCenter.districtId);
          if (district == null) return null;
          final region = regions
              .firstWhereOrNull((region) => region.id == district.regionId);
          if (region == null) return null;

          return LocationItemVM(
              region: region, district: district, sportsCenter: sportsCenter);
        })
        .whereType<LocationItemVM>()
        .toList();
  }
}

class LocationItemVM extends Equatable {
  final Region region;
  final District district;
  final SportsCenter sportsCenter;
  final bool bookmarked;

  const LocationItemVM({
    required this.region,
    required this.district,
    required this.sportsCenter,
    this.bookmarked = false,
  });

  String get itemId => '${region.id}-${district.id}-${sportsCenter.id}';

  String getSportsCenterName(String langCode) => getLocalizedString(
        langCode,
        en: sportsCenter.nameEn,
        zh: sportsCenter.nameZh,
      );

  String getSportsCenterAddress(String langCode) => getLocalizedString(
        langCode,
        en: sportsCenter.addressEn,
        zh: sportsCenter.addressZh,
      );

  String getRegionName(String langCode) => getLocalizedString(
        langCode,
        en: region.nameEn,
        zh: region.nameZh,
      );

  String getDistrictName(String langCode) => getLocalizedString(
        langCode,
        en: district.nameEn,
        zh: district.nameZh,
      );

  @override
  List<Object?> get props => [sportsCenter, region, district, bookmarked];

  LocationItemVM copyWith({
    Region? region,
    District? district,
    SportsCenter? sportsCenter,
    bool? bookmarked,
  }) =>
      LocationItemVM(
        region: region ?? this.region,
        district: district ?? this.district,
        sportsCenter: sportsCenter ?? this.sportsCenter,
        bookmarked: bookmarked ?? this.bookmarked,
      );
}
