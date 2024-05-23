import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/core/utils/localization/localization_helper.dart';
import 'package:lets_go_gym/domain/entities/district/district.dart';
import 'package:lets_go_gym/domain/entities/region/region.dart';
import 'package:lets_go_gym/domain/entities/sports_center/sports_center.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/get_all_bookmarks_as_stream.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/remove_bookmark.dart';
import 'package:lets_go_gym/domain/usecases/districts/get_districts_by_ids.dart';
import 'package:lets_go_gym/domain/usecases/regions/get_regions_by_ids.dart';
import 'package:lets_go_gym/domain/usecases/sports_centers/get_sports_centers_by_ids.dart';
import 'package:rxdart/rxdart.dart';

part 'bookmarks_event.dart';
part 'bookmarks_state.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final GetAllBookmarksAsStream getAllBookmarksAsStream;
  final RemoveBookmark removeBookmark;
  final GetRegionsByIds getRegionsByIds;
  final GetDistrictsByIds getDistrictsByIds;
  final GetSportsCentersByIds getSportsCentersByIds;

  late final StreamSubscription _bookmarksSubscription;

  BookmarksBloc({
    required this.getAllBookmarksAsStream,
    required this.removeBookmark,
    required this.getRegionsByIds,
    required this.getDistrictsByIds,
    required this.getSportsCentersByIds,
  }) : super(BookmarksLoadingInProgress()) {
    on<BookmarkUpdateRequested>(_onBookmarkUpdateRequested);
    on<BookmarkDataUpdateReceived>(_onBookmarkDataUpdateReceived);

    _setupSubscription();
  }

  final Map<int, Region> _cachedRegions = {};
  final Map<int, District> _cachedDistricts = {};
  final Map<int, SportsCenter> _cachedSportsCenters = {};

  List<BookmarkItemVM> _bookmarkItemVMs = [];
  Set<int> _bookmarkedIds = {};
  // TODO filter
  // for display
  List<BookmarkItemVM> _displayItemVMs = [];

  void _setupSubscription() {
    _bookmarksSubscription = getAllBookmarksAsStream
        .execute()
        .throttleTime(
          const Duration(milliseconds: 300),
          trailing: true,
        )
        .distinct()
        .map((bookmarks) => bookmarks.map((e) => e.sportsCenterId).toSet())
        .listen(
          (bookmarkedIds) =>
              add(BookmarkDataUpdateReceived(bookmarkedIds: bookmarkedIds)),
        );
  }

  Future<void> _onBookmarkUpdateRequested(
      BookmarkUpdateRequested event, Emitter<BookmarksState> emit) async {
    try {
      final item =
          _displayItemVMs.firstWhereOrNull((vm) => vm.itemId == event.itemId);
      if (item == null) throw Exception('item not found');

      await removeBookmark.execute(item.sportsCenterId);
    } catch (_) {
      // TODO handle error
      // emit(LocationsDataUpdateFailure());
    }
  }

  Future<void> _onBookmarkDataUpdateReceived(
      BookmarkDataUpdateReceived event, Emitter<BookmarksState> emit) async {
    _bookmarkedIds = event.bookmarkedIds;

    try {
      await _getRequiredData(_bookmarkedIds);

      final List<BookmarkItemVM> updatedVMs = [];
      for (final id in _bookmarkedIds) {
        final sportsCenter = _cachedSportsCenters[id];
        if (sportsCenter == null) continue;

        final district = _cachedDistricts[sportsCenter.districtId];
        if (district == null) continue;

        final region = _cachedRegions[district.regionId];
        if (region == null) continue;

        updatedVMs.add(BookmarkItemVM.create(
          region: region,
          district: district,
          sportsCenter: sportsCenter,
        ));
      }
      _bookmarkItemVMs = updatedVMs;

      _displayItemVMs = _bookmarkItemVMs;
      emit(BookmarksDataUpdated(displayItemVMs: _displayItemVMs.toList()));
    } catch (error) {
      // TODO handle error
      // emit(BookmarksDataUpdateFailure());
    }
  }

  Future<void> _getRequiredData(Set<int> bookmarkedIds) async {
    // Get missing sports center data
    final sportsCenterIdsToBeLoaded = bookmarkedIds
        .whereNot((id) => _cachedSportsCenters.keys.contains(id))
        .toList();
    final sportsCenters =
        await _getSportsCentersByIds(sportsCenterIdsToBeLoaded);
    for (final sportsCenter in sportsCenters) {
      _cachedSportsCenters[sportsCenter.id] = sportsCenter;
    }

    // Get missing district data
    final districtIdsToBeLoaded = _cachedSportsCenters.values
        .map((sportsCenter) => sportsCenter.districtId)
        .whereNot((id) => _cachedDistricts.keys.contains(id))
        .toList();
    final districts = await _getDistrictsByIds(districtIdsToBeLoaded);
    for (final district in districts) {
      _cachedDistricts[district.id] = district;
    }

    // Get missing region data
    final regionIdsToBeLoaded = _cachedDistricts.values
        .map((district) => district.regionId)
        .whereNot((id) => _cachedRegions.keys.contains(id))
        .toList();
    final regions = await _getRegionsByIds(regionIdsToBeLoaded);
    for (final region in regions) {
      _cachedRegions[region.id] = region;
    }
  }

  Future<List<Region>> _getRegionsByIds(List<int> ids) async {
    try {
      if (ids.isEmpty) return [];

      return await getRegionsByIds.execute(ids);
    } catch (_) {
      log("Failed to get regions");
      rethrow;
    }
  }

  Future<List<District>> _getDistrictsByIds(List<int> ids) async {
    try {
      if (ids.isEmpty) return [];

      return await getDistrictsByIds.execute(ids);
    } catch (_) {
      log("Failed to get districts");
      rethrow;
    }
  }

  Future<List<SportsCenter>> _getSportsCentersByIds(List<int> ids) async {
    try {
      if (ids.isEmpty) return [];

      return await getSportsCentersByIds.execute(ids);
    } catch (_) {
      log("Failed to get sports centers");
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    await _bookmarksSubscription.cancel();
    super.close();
  }
}

class BookmarkItemVM extends Equatable {
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

  factory BookmarkItemVM.create({
    required Region region,
    required District district,
    required SportsCenter sportsCenter,
  }) =>
      BookmarkItemVM._(
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

  const BookmarkItemVM._({
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

  BookmarkItemVM copyWith({
    Region? region,
    District? district,
    SportsCenter? sportsCenter,
  }) =>
      BookmarkItemVM._(
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
