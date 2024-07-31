import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/core/utils/localization/localization_helper.dart';
import 'package:lets_go_gym/domain/entities/district/district.dart';
import 'package:lets_go_gym/domain/entities/region/region.dart';
import 'package:lets_go_gym/domain/usecases/districts/get_all_districts.dart';
import 'package:lets_go_gym/domain/usecases/regions/get_all_regions.dart';
import 'package:lets_go_gym/ui/models/locations_filter.dart';

part 'locations_filter_modal_event.dart';
part 'locations_filter_modal_state.dart';

class LocationsFilterModalBloc
    extends Bloc<LocationsFilterModalEvent, LocationsFilterModalState> {
  final GetAllRegions _getAllRegions;
  final GetAllDistricts _getAllDistricts;

  LocationsFilterModalBloc({
    required LocationsFilter currentFilter,
    required GetAllRegions getAllRegions,
    required GetAllDistricts getAllDistricts,
  })  : _getAllDistricts = getAllDistricts,
        _getAllRegions = getAllRegions,
        super(LocationsFilterModalDataLoadingInProgress()) {
    on<LocationsFilterModalInitRequested>(_onLocationsFilterModalInitRequested);
    on<AllRegionChipSelected>(_onAllRegionChipSelected);
    on<RegionFilterUpdateRequested>(_onRegionFilterUpdateRequested);
    on<AllDistrictChipSelected>(_onAllDistrictChipSelected);
    on<DistrictFilterUpdateRequested>(_onDistrictFilterUpdateRequested);
    on<ApplyFilterRequested>(_onApplyFilterRequested);

    _filter = currentFilter;
    add(LocationsFilterModalInitRequested());
  }

  late List<Region> _regions;
  late List<District> _districts;
  late LocationsFilter _filter;

  Future<void> _onLocationsFilterModalInitRequested(
      LocationsFilterModalInitRequested event,
      Emitter<LocationsFilterModalState> emit) async {
    try {
      _regions = await _getRegions();
      _districts = await _getDistricts();

      emit(LocationsFilterModalDataUpdated(
        regionChipItemVMs: _generateRegionChipItemVMs(
          regions: _regions,
          selectedRegions: _filter.regionIds,
        ),
        districtChipItemVMs: _generateDistrictChipItemVMs(
          districts: _districts,
          selectedDistricts: _filter.districtIds,
        ),
      ));
    } catch (error) {
      log(error.toString());
    }
  }

  void _onAllRegionChipSelected(
      AllRegionChipSelected event, Emitter<LocationsFilterModalState> emit) {
    _filter = _filter.removeAllRegion();

    emit(LocationsFilterModalDataUpdated(
      regionChipItemVMs: _generateRegionChipItemVMs(
        regions: _regions,
        selectedRegions: _filter.regionIds,
      ),
      districtChipItemVMs: _generateDistrictChipItemVMs(
        districts: _districts,
        selectedDistricts: _filter.districtIds,
      ),
    ));
  }

  void _onRegionFilterUpdateRequested(RegionFilterUpdateRequested event,
      Emitter<LocationsFilterModalState> emit) {
    if (event.isSelected) {
      _filter = _filter.add(regionId: event.regionId);
    } else {
      _filter = _filter.remove(regionId: event.regionId);
    }

    emit(LocationsFilterModalDataUpdated(
      regionChipItemVMs: _generateRegionChipItemVMs(
        regions: _regions,
        selectedRegions: _filter.regionIds,
      ),
      districtChipItemVMs: _generateDistrictChipItemVMs(
        districts: _districts,
        selectedDistricts: _filter.districtIds,
      ),
    ));
  }

  void _onAllDistrictChipSelected(
      AllDistrictChipSelected event, Emitter<LocationsFilterModalState> emit) {
    _filter = _filter.removeAllDistrict();

    emit(LocationsFilterModalDataUpdated(
      regionChipItemVMs: _generateRegionChipItemVMs(
        regions: _regions,
        selectedRegions: _filter.regionIds,
      ),
      districtChipItemVMs: _generateDistrictChipItemVMs(
        districts: _districts,
        selectedDistricts: _filter.districtIds,
      ),
    ));
  }

  void _onDistrictFilterUpdateRequested(DistrictFilterUpdateRequested event,
      Emitter<LocationsFilterModalState> emit) {
    if (event.isSelected) {
      _filter = _filter.add(districtId: event.districtId);
    } else {
      _filter = _filter.remove(districtId: event.districtId);
    }

    emit(LocationsFilterModalDataUpdated(
      regionChipItemVMs: _generateRegionChipItemVMs(
        regions: _regions,
        selectedRegions: _filter.regionIds,
      ),
      districtChipItemVMs: _generateDistrictChipItemVMs(
        districts: _districts,
        selectedDistricts: _filter.districtIds,
      ),
    ));
  }

  void _onApplyFilterRequested(
      ApplyFilterRequested event, Emitter<LocationsFilterModalState> emit) {
    event.onLocationsFilterApply?.call(_filter);
  }

  List<RegionChipItemVM> _generateRegionChipItemVMs({
    required List<Region> regions,
    required Set<int> selectedRegions,
  }) {
    return regions
        .map((region) => RegionChipItemVM.create(
              region: region,
              isSelected: selectedRegions.contains(region.id),
            ))
        .toList();
  }

  List<DistrictChipItemVM> _generateDistrictChipItemVMs({
    required List<District> districts,
    required Set<int> selectedDistricts,
  }) {
    return districts
        .map((district) => DistrictChipItemVM.create(
              district: district,
              isSelected: selectedDistricts.contains(district.id),
            ))
        .toList();
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
}

class RegionChipItemVM extends Equatable {
  final int regionId;
  final String _regionNameEn;
  final String _regionNameZh;
  final bool isSelected;

  factory RegionChipItemVM.create({
    required Region region,
    required bool isSelected,
  }) =>
      RegionChipItemVM._(
        regionId: region.id,
        regionNameEn: region.nameEn,
        regionNameZh: region.nameZh,
        isSelected: isSelected,
      );

  const RegionChipItemVM._({
    required this.regionId,
    required String regionNameEn,
    required String regionNameZh,
    this.isSelected = false,
  })  : _regionNameEn = regionNameEn,
        _regionNameZh = regionNameZh;

  String get itemId => '$regionId';

  String getRegionName(String langCode) => getLocalizedString(
        langCode,
        en: _regionNameEn,
        zh: _regionNameZh,
      );

  @override
  List<Object?> get props => [
        regionId,
        _regionNameEn,
        _regionNameZh,
        isSelected,
      ];

  RegionChipItemVM copyWith({
    Region? region,
    bool? isSelected,
  }) =>
      RegionChipItemVM._(
        regionId: region?.id ?? regionId,
        regionNameEn: region?.nameEn ?? _regionNameEn,
        regionNameZh: region?.nameZh ?? _regionNameZh,
        isSelected: isSelected ?? this.isSelected,
      );
}

class DistrictChipItemVM extends Equatable {
  final int districtId;
  final String _districtNameEn;
  final String _districtNameZh;
  final int regionId;
  final bool isSelected;

  factory DistrictChipItemVM.create({
    required District district,
    required bool isSelected,
  }) =>
      DistrictChipItemVM._(
        districtId: district.id,
        districtNameEn: district.nameEn,
        districtNameZh: district.nameZh,
        regionId: district.regionId,
        isSelected: isSelected,
      );

  const DistrictChipItemVM._({
    required this.districtId,
    required String districtNameEn,
    required String districtNameZh,
    required this.regionId,
    this.isSelected = false,
  })  : _districtNameEn = districtNameEn,
        _districtNameZh = districtNameZh;

  String get itemId => '$districtId';

  String getDistrictName(String langCode) => getLocalizedString(
        langCode,
        en: _districtNameEn,
        zh: _districtNameZh,
      );

  @override
  List<Object?> get props =>
      [regionId, districtId, _districtNameEn, _districtNameZh, isSelected];

  DistrictChipItemVM copyWith({
    District? district,
    bool? isSelected,
  }) =>
      DistrictChipItemVM._(
        districtId: district?.id ?? districtId,
        districtNameEn: district?.nameEn ?? _districtNameEn,
        districtNameZh: district?.nameZh ?? _districtNameZh,
        regionId: district?.regionId ?? regionId,
        isSelected: isSelected ?? this.isSelected,
      );
}
