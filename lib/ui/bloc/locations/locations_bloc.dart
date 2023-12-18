import 'dart:async';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/domain/entities/district/district.dart';
import 'package:lets_go_gym/domain/entities/region/region.dart';
import 'package:lets_go_gym/domain/entities/sports_center/sports_center.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/add_bookmark.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/get_all_bookmarks.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/get_all_bookmarks_as_stream.dart';
import 'package:lets_go_gym/domain/usecases/bookmarks/remove_bookmark.dart';
import 'package:lets_go_gym/domain/usecases/districts/get_all_districts.dart';
import 'package:lets_go_gym/domain/usecases/regions/get_all_regions.dart';
import 'package:lets_go_gym/domain/usecases/sports_centers/get_all_sports_centers.dart';
import 'package:rxdart/rxdart.dart';

part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final GetAllRegions getAllRegions;
  final GetAllDistricts getAllDistricts;
  final GetAllSportsCenters getAllSportsCenters;
  final GetAllBookmarks getAllBookmarks;
  final GetAllBookmarksAsStream getAllBookmarksAsStream;
  final AddBookmark addBookmark;
  final RemoveBookmark removeBookmark;

  late final StreamSubscription _subscription;

  LocationsBloc({
    required this.getAllRegions,
    required this.getAllDistricts,
    required this.getAllSportsCenters,
    required this.getAllBookmarks,
    required this.getAllBookmarksAsStream,
    required this.addBookmark,
    required this.removeBookmark,
  }) : super(LocationsDataLoadingInProgress()) {
    on<LocationsDataRequested>(_onLocationsDataRequested);
    on<BookmarkUpdateRequested>(_onBookmarkUpdateRequested);
    on<BookmarkDataUpdateReceived>(_onBookmarkDataUpdateReceived);

    add(LocationsDataRequested());
    _setupSubscription();
  }

  List<LocationItemVM> _locationItemVMs = [];
  Set<int> _bookmarkedIds = {};
  // TODO filter
  // for display
  List<LocationItemVM> _displayItemVMs = [];

  void _setupSubscription() {
    _subscription = getAllBookmarksAsStream
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

  Future<void> _onLocationsDataRequested(
      LocationsDataRequested event, Emitter<LocationsState> emit) async {
    try {
      final regions = await _getAllRegions();
      final districts = await _getAllDistricts();
      final sportsCenters = await _getAllSportsCenters();

      _bookmarkedIds = await _getAllBookmarkedIds();

      _locationItemVMs = _convertDataToVMs(
        regions: regions,
        districts: districts,
        sportsCenters: sportsCenters,
        bookmarkedIds: _bookmarkedIds,
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
      final item =
          _displayItemVMs.firstWhereOrNull((vm) => vm.itemId == event.itemId);
      if (item == null) throw Exception('item not found');

      if (item.bookmarked) {
        await removeBookmark.execute(item.sportsCenter.id);
      } else {
        await addBookmark.execute(item.sportsCenter.id);
      }
    } catch (_) {
      // TODO handle error
      // emit(LocationsDataUpdateFailure());
    }
  }

  Future<void> _onBookmarkDataUpdateReceived(
      BookmarkDataUpdateReceived event, Emitter<LocationsState> emit) async {
    _bookmarkedIds = event.bookmarkedIds;
    _displayItemVMs = _displayItemVMs
        .map((item) => item.copyWith(
            bookmarked: _bookmarkedIds.contains(item.sportsCenter.id)))
        .toList();

    emit(LocationsDataUpdated(displayItemVMs: _displayItemVMs.toList()));
  }

  Future<List<Region>> _getAllRegions() async {
    try {
      return await getAllRegions.execute();
    } catch (_) {
      log("Failed to get all regions");
      rethrow;
    }
  }

  Future<List<District>> _getAllDistricts() async {
    try {
      return await getAllDistricts.execute();
    } catch (_) {
      log("Failed to get all districts");
      rethrow;
    }
  }

  Future<List<SportsCenter>> _getAllSportsCenters() async {
    try {
      return await getAllSportsCenters.execute();
    } catch (_) {
      log("Failed to get all sports centers");
      rethrow;
    }
  }

  Future<Set<int>> _getAllBookmarkedIds() async {
    try {
      final bookmarks = await getAllBookmarks.execute();

      return bookmarks.map((e) => e.sportsCenterId).toSet();
    } catch (_) {
      log("Failed to get all bookmarks");
    }

    return {};
  }

  List<LocationItemVM> _convertDataToVMs({
    required List<Region> regions,
    required List<District> districts,
    required List<SportsCenter> sportsCenters,
    required Set<int> bookmarkedIds,
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
            region: region,
            district: district,
            sportsCenter: sportsCenter,
            bookmarked: bookmarkedIds.contains(sportsCenter.id),
          );
        })
        .whereType<LocationItemVM>()
        .toList();
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
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
