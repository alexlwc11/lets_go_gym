import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/domain/entities/district/district.dart';
import 'package:lets_go_gym/domain/entities/region/region.dart';
import 'package:lets_go_gym/domain/entities/sports_center/sports_center.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/add_bookmark.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/check_if_bookmarked.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/check_if_bookmarked_as_stream.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/remove_bookmark.dart';
import 'package:lets_go_gym/domain/usecases/districts/get_district_by_id.dart';
import 'package:lets_go_gym/domain/usecases/regions/get_region_by_id.dart';
import 'package:lets_go_gym/domain/usecases/sports_centers/get_sports_center_by_id.dart';
import 'package:rxdart/rxdart.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final int sportsCenterId;

  final GetRegionById getRegionById;
  final GetDistrictById getDistrictById;
  final GetSportsCenterById getSportsCenterById;
  final CheckIfBookmarked checkIfBookmarked;
  final CheckIfBookmarkedAsStream checkIfBookmarkedAsStream;
  final AddBookmark addBookmark;
  final RemoveBookmark removeBookmark;

  late final StreamSubscription _subscription;

  LocationBloc({
    required this.sportsCenterId,
    required this.getRegionById,
    required this.getDistrictById,
    required this.getSportsCenterById,
    required this.checkIfBookmarked,
    required this.checkIfBookmarkedAsStream,
    required this.addBookmark,
    required this.removeBookmark,
  }) : super(LocationDataLoadingInProgress()) {
    on<LocationDataRequested>(_onLocationDataLoadRequested);
    on<LocationIsBookmarkedUpdateReceived>(
        _onLocationIsBookmarkedUpdateReceived);
    on<BookmarkUpdateRequested>(_onBookmarkUpdateRequested);

    add(LocationDataRequested(sportsCenterId: sportsCenterId));
  }

  late LocationVM _locationVM;

  void _setupSubscription() {
    _subscription = checkIfBookmarkedAsStream
        .execute(sportsCenterId)
        .throttleTime(
          const Duration(milliseconds: 300),
          trailing: true,
        )
        .distinct()
        .listen(
          (isBookmarked) => add(
              LocationIsBookmarkedUpdateReceived(isBookmarked: isBookmarked)),
        );
  }

  Future<void> _onLocationDataLoadRequested(
      LocationDataRequested event, Emitter<LocationState> emit) async {
    try {
      final sportsCenter = await _getSportsCenterById(sportsCenterId);
      final district = await _getDistrictById(sportsCenter.districtId);
      final region = await _getRegionById(district.regionId);
      final isBookmarked = await _checkIfBookmarked(sportsCenterId);

      _locationVM = LocationVM.create(
        region: region,
        district: district,
        sportsCenter: sportsCenter,
        isBookmarked: isBookmarked,
      );

      emit(LocationDataUpdated(vm: _locationVM));
    } catch (_) {
      // TODO handle error
      // emit(LocationDataUpdateFailure());
    } finally {
      _setupSubscription();
    }
  }

  Future<void> _onBookmarkUpdateRequested(
      BookmarkUpdateRequested event, Emitter<LocationState> emit) async {
    try {
      if (_locationVM.isBookmarked) {
        await removeBookmark.execute(sportsCenterId);
      } else {
        await addBookmark.execute(sportsCenterId);
      }
    } catch (_) {
      // TODO handle error
      // emit(LocationsDataUpdateFailure());
    }
  }

  void _onLocationIsBookmarkedUpdateReceived(
      LocationIsBookmarkedUpdateReceived event, Emitter<LocationState> emit) {
    _locationVM = _locationVM.copyWith(isBookmarked: event.isBookmarked);
    emit(LocationDataUpdated(vm: _locationVM));
  }

  Future<Region> _getRegionById(int regionId) async {
    try {
      final region = await getRegionById.execute(regionId);
      if (region == null) throw Exception('Cannot find region');

      return region;
    } catch (error) {
      log("Failed to get region");
      rethrow;
    }
  }

  Future<District> _getDistrictById(int districtId) async {
    try {
      final district = await getDistrictById.execute(districtId);
      if (district == null) throw Exception('Cannot find district');

      return district;
    } catch (error) {
      log("Failed to get district");
      rethrow;
    }
  }

  Future<SportsCenter> _getSportsCenterById(int sportsCenterId) async {
    try {
      final sportsCenter = await getSportsCenterById.execute(sportsCenterId);
      if (sportsCenter == null) throw Exception('Cannot find sports center');

      return sportsCenter;
    } catch (error) {
      log("Failed to get sports center");
      rethrow;
    }
  }

  Future<bool> _checkIfBookmarked(int sportsCenterId) async {
    try {
      return await checkIfBookmarked.execute(sportsCenterId);
    } catch (_) {
      log("Failed to get bookmark data");
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}

class LocationVM extends Equatable {
  final String _regionNameEn;
  final String _regionNameZh;
  final String _districtNameEn;
  final String _districtNameZh;
  final String _sportsCenterNameEn;
  final String _sportsCenterNameZh;
  final String _sportsCenterAddressEn;
  final String _sportsCenterAddressZh;
  final List<String> phoneNumbers;
  final int? hourlyQuota;
  final int? monthlyQuota;
  final double? latitude;
  final double? longitude;
  final bool isBookmarked;

  factory LocationVM.create({
    required Region region,
    required District district,
    required SportsCenter sportsCenter,
    required bool isBookmarked,
  }) {
    final phoneNumbers = sportsCenter.phoneNumbers.split('/');

    return LocationVM._(
      regionNameEn: region.nameEn,
      regionNameZh: region.nameZh,
      districtNameEn: district.nameEn,
      districtNameZh: district.nameZh,
      sportsCenterNameEn: sportsCenter.nameEn,
      sportsCenterNameZh: sportsCenter.nameZh,
      sportsCenterAddressEn: sportsCenter.addressEn,
      sportsCenterAddressZh: sportsCenter.addressZh,
      phoneNumbers: phoneNumbers,
      hourlyQuota: sportsCenter.hourlyQuota,
      monthlyQuota: sportsCenter.monthlyQuota,
      latitude: sportsCenter.latitude,
      longitude: sportsCenter.longitude,
      isBookmarked: isBookmarked,
    );
  }

  const LocationVM._({
    required String regionNameEn,
    required String regionNameZh,
    required String districtNameEn,
    required String districtNameZh,
    required String sportsCenterNameEn,
    required String sportsCenterNameZh,
    required String sportsCenterAddressEn,
    required String sportsCenterAddressZh,
    required this.phoneNumbers,
    this.hourlyQuota,
    this.monthlyQuota,
    this.latitude,
    this.longitude,
    this.isBookmarked = false,
  })  : _regionNameEn = regionNameEn,
        _regionNameZh = regionNameEn,
        _districtNameEn = districtNameEn,
        _districtNameZh = districtNameZh,
        _sportsCenterNameEn = sportsCenterNameEn,
        _sportsCenterNameZh = sportsCenterNameZh,
        _sportsCenterAddressEn = sportsCenterAddressEn,
        _sportsCenterAddressZh = sportsCenterAddressZh;

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
        _regionNameEn,
        _regionNameZh,
        _districtNameEn,
        _districtNameZh,
        _sportsCenterNameEn,
        _sportsCenterNameZh,
        _sportsCenterAddressEn,
        _sportsCenterAddressZh,
        phoneNumbers.join('/'),
        hourlyQuota,
        monthlyQuota,
        latitude,
        longitude,
        isBookmarked
      ];

  LocationVM copyWith({
    bool? isBookmarked,
  }) =>
      LocationVM._(
        regionNameEn: _regionNameEn,
        regionNameZh: _regionNameZh,
        districtNameEn: _districtNameEn,
        districtNameZh: _districtNameZh,
        sportsCenterNameEn: _sportsCenterNameEn,
        sportsCenterNameZh: _sportsCenterNameZh,
        sportsCenterAddressEn: _sportsCenterAddressEn,
        sportsCenterAddressZh: _sportsCenterAddressZh,
        phoneNumbers: phoneNumbers,
        hourlyQuota: hourlyQuota,
        monthlyQuota: monthlyQuota,
        latitude: latitude,
        longitude: longitude,
        isBookmarked: isBookmarked ?? this.isBookmarked,
      );
}
