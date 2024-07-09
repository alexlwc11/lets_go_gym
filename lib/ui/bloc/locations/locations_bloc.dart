import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/core/utils/localization/localization_helper.dart';
import 'package:lets_go_gym/domain/entities/district/district.dart';
import 'package:lets_go_gym/domain/entities/region/region.dart';
import 'package:lets_go_gym/domain/entities/sports_center/sports_center.dart';
import 'package:lets_go_gym/domain/usecases/districts/get_all_districts.dart';
import 'package:lets_go_gym/domain/usecases/regions/get_all_regions.dart';
import 'package:lets_go_gym/domain/usecases/sports_centers/get_all_sports_centers.dart';
import 'package:lets_go_gym/ui/models/locations_filter.dart';

part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final GetAllRegions _getAllRegions;
  final GetAllDistricts _getAllDistricts;
  final GetAllSportsCenters _getAllSportsCenters;

  LocationsBloc({
    required GetAllRegions getAllRegions,
    required GetAllDistricts getAllDistricts,
    required GetAllSportsCenters getAllSportsCenters,
  })  : _getAllRegions = getAllRegions,
        _getAllDistricts = getAllDistricts,
        _getAllSportsCenters = getAllSportsCenters,
        super(LocationsDataLoadingInProgress()) {
    on<LocationsDataRequested>(_onLocationsDataRequested);
    on<LocationsFilterUpdated>(_onLocationsFilterUpdated);

    add(LocationsDataRequested());
  }

  // cached generated vms
  List<LocationItemVM> _locationItemVMs = [];
  // for display
  List<LocationItemVM> _displayItemVMs = [];

  Future<void> _onLocationsDataRequested(
      LocationsDataRequested event, Emitter<LocationsState> emit) async {
    try {
      final regions = await _getRegions();
      final districts = await _getDistricts();
      final sportsCenters = await _getSportsCenters();

      _locationItemVMs = _convertDataToVMs(
        regions: regions,
        districts: districts,
        sportsCenters: sportsCenters,
      );

      _displayItemVMs = _locationItemVMs.toList();
      emit(LocationsDataUpdated(displayItemVMs: _displayItemVMs.toList()));
    } catch (error) {
      log("LocationsBloc#onLocationsDataRequested: $error");
      emit(
          LocationsDataUpdateFailure(displayItemVMs: _displayItemVMs.toList()));
    }
  }

  void _onLocationsFilterUpdated(
      LocationsFilterUpdated event, Emitter<LocationsState> emit) {
    final regionIds = event.updateFilter.regionIds;
    final districtIds = event.updateFilter.districtIds;
    _displayItemVMs = _locationItemVMs.where((element) {
      if (regionIds.isNotEmpty && districtIds.isNotEmpty) {
        return regionIds.contains(element.regionId) ||
            districtIds.contains(element.districtId);
      } else if (regionIds.isNotEmpty) {
        return regionIds.contains(element.regionId);
      } else if (districtIds.isNotEmpty) {
        return districtIds.contains(element.districtId);
      } else {
        return true;
      }
    }).toList();

    emit(LocationsDataUpdated(displayItemVMs: _displayItemVMs.toList()));
  }

  Future<List<Region>> _getRegions() async {
    try {
      return await _getAllRegions.execute();
    } catch (_) {
      log("Failed to get all regions");
      rethrow;
    }
  }

  Future<List<District>> _getDistricts() async {
    try {
      return await _getAllDistricts.execute();
    } catch (_) {
      log("Failed to get all districts");
      rethrow;
    }
  }

  Future<List<SportsCenter>> _getSportsCenters() async {
    try {
      return await _getAllSportsCenters.execute();
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

          return LocationItemVM.create(
            region: region,
            district: district,
            sportsCenter: sportsCenter,
          );
        })
        .whereType<LocationItemVM>()
        .toList();
  }
}

class LocationItemVM extends Equatable {
  final int regionId;
  final String _regionNameEn;
  final String _regionNameZh;
  final int districtId;
  final String _districtNameEn;
  final String _districtNameZh;
  final int sportsCenterId;
  final String _sportsCenterNameEn;
  final String _sportsCenterNameZh;
  final String _sportsCenterAddressEn;
  final String _sportsCenterAddressZh;

  factory LocationItemVM.create({
    required Region region,
    required District district,
    required SportsCenter sportsCenter,
  }) =>
      LocationItemVM._(
        regionId: region.id,
        regionNameEn: region.nameEn,
        regionNameZh: region.nameZh,
        districtId: district.id,
        districtNameEn: district.nameEn,
        districtNameZh: district.nameZh,
        sportsCenterId: sportsCenter.id,
        sportsCenterNameEn: sportsCenter.nameEn,
        sportsCenterNameZh: sportsCenter.nameZh,
        sportsCenterAddressEn: sportsCenter.addressEn,
        sportsCenterAddressZh: sportsCenter.addressZh,
      );

  const LocationItemVM._({
    required this.regionId,
    required String regionNameEn,
    required String regionNameZh,
    required this.districtId,
    required String districtNameEn,
    required String districtNameZh,
    required this.sportsCenterId,
    required String sportsCenterNameEn,
    required String sportsCenterNameZh,
    required String sportsCenterAddressEn,
    required String sportsCenterAddressZh,
  })  : _regionNameEn = regionNameEn,
        _regionNameZh = regionNameZh,
        _districtNameEn = districtNameEn,
        _districtNameZh = districtNameZh,
        _sportsCenterNameEn = sportsCenterNameEn,
        _sportsCenterNameZh = sportsCenterNameZh,
        _sportsCenterAddressEn = sportsCenterAddressEn,
        _sportsCenterAddressZh = sportsCenterAddressZh;

  String get itemId => '$regionId-$districtId-$sportsCenterId';

  String getSportsCenterName(String langCode) => getLocalizedString(
        langCode,
        en: _sportsCenterNameEn,
        zh: _sportsCenterNameZh,
      );

  String getSportsCenterAddress(String langCode) => getLocalizedString(
        langCode,
        en: _sportsCenterAddressEn,
        zh: _sportsCenterAddressZh,
      );

  String getRegionName(String langCode) => getLocalizedString(
        langCode,
        en: _regionNameEn,
        zh: _regionNameZh,
      );

  String getDistrictName(String langCode) => getLocalizedString(
        langCode,
        en: _districtNameEn,
        zh: _districtNameZh,
      );

  @override
  List<Object?> get props => [
        regionId,
        _regionNameEn,
        _regionNameZh,
        districtId,
        _districtNameEn,
        _districtNameZh,
        sportsCenterId,
        _sportsCenterNameEn,
        _sportsCenterNameZh,
        _sportsCenterAddressEn,
        _sportsCenterAddressZh,
      ];

  LocationItemVM copyWith({
    Region? region,
    District? district,
    SportsCenter? sportsCenter,
    bool? isBookmarked,
  }) =>
      LocationItemVM._(
        regionId: region?.id ?? regionId,
        regionNameEn: region?.nameEn ?? _regionNameEn,
        regionNameZh: region?.nameZh ?? _regionNameZh,
        districtId: district?.id ?? districtId,
        districtNameEn: district?.nameEn ?? _districtNameEn,
        districtNameZh: district?.nameZh ?? _districtNameZh,
        sportsCenterId: sportsCenter?.id ?? sportsCenterId,
        sportsCenterNameEn: sportsCenter?.nameEn ?? _sportsCenterNameEn,
        sportsCenterNameZh: sportsCenter?.nameZh ?? _sportsCenterNameZh,
        sportsCenterAddressEn:
            sportsCenter?.addressEn ?? _sportsCenterAddressEn,
        sportsCenterAddressZh:
            sportsCenter?.addressZh ?? _sportsCenterAddressZh,
      );
}
