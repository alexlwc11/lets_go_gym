import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/domain/entities/app_info/data_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_app_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_current_data_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_district_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_region_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_sports_center_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/districts/update_districts_data.dart';
import 'package:lets_go_gym/domain/usecases/regions/update_regions_data.dart';
import 'package:lets_go_gym/domain/usecases/sports_centers/update_sports_centers_data.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'entry_event.dart';
part 'entry_state.dart';

class EntryBloc extends Bloc<EntryEvent, EntryState> {
  final GetAppInfo getAppInfo;
  final GetCurrentDataInfo getCurrentDataInfo;
  final UpdateRegionsData updateRegionsData;
  final UpdateDistrictsData updateDistrictsData;
  final UpdateSportsCentersData updateSportsCentersData;
  final UpdateRegionDataLastUpdated updateRegionDataLastUpdated;
  final UpdateDistrictDataLastUpdated updateDistrictDataLastUpdated;
  final UpdateSportsCenterDataLastUpdated updateSportsCenterDataLastUpdated;

  EntryBloc({
    required this.getAppInfo,
    required this.getCurrentDataInfo,
    required this.updateRegionsData,
    required this.updateDistrictsData,
    required this.updateSportsCentersData,
    required this.updateRegionDataLastUpdated,
    required this.updateDistrictDataLastUpdated,
    required this.updateSportsCenterDataLastUpdated,
  }) : super(DataUpdating()) {
    on<AppInfoRequested>(_onAppInfoRequested);
    on<CurrentDataInfoRequested>(_onCurrentDataInfoRequested);
    on<RegionDataUpdateRequested>(_onRegionDataUpdateRequested);
    on<DistrictDataUpdateRequested>(_onDistrictDataUpdateRequested);
    on<SportsCenterDataUpdateRequested>(_onSportsCenterDataUpdateRequested);
    on<RetryUpdateRequested>(_onRetryUpdateRequested);

    add(AppInfoRequested());
  }

  DataInfo? _latestDataInfo;
  DataInfo? _dataInfo;

  Future<void> _onAppInfoRequested(
      AppInfoRequested event, Emitter<EntryState> emit) async {
    try {
      final latestAppInfo = await getAppInfo.execute();
      _latestDataInfo = latestAppInfo.dataInfo;

      final packageInfo = await PackageInfo.fromPlatform();
      final minimumBuildVersion = latestAppInfo.minimumBuildVersion;
      final currentBuildVersion = int.parse(packageInfo.buildNumber);

      // TODO check whether data up to date in next step
      if (currentBuildVersion >= minimumBuildVersion) {
        emit(DataUpdating(finishedStep: DataUpdateStep.appVersion));
        add(CurrentDataInfoRequested());
      } else {
        // TODO update store url
        // final storeUrl = Platform.isIOS
        //     ? latestAppInfo.iosAppLink ?? ''
        //     : latestAppInfo.androidAppLink ?? '';
        emit(AppOutdated(storeUrl: ''));
      }
    } catch (_) {
      emit(FailedToUpdate(failedStep: DataUpdateStep.appVersion));
    }
  }

  Future<void> _onCurrentDataInfoRequested(
      CurrentDataInfoRequested event, Emitter<EntryState> emit) async {
    try {
      _dataInfo = await getCurrentDataInfo.execute();

      emit(DataUpdating(finishedStep: DataUpdateStep.dataInfo));
      add(RegionDataUpdateRequested());
    } catch (_) {
      emit(FailedToUpdate(failedStep: DataUpdateStep.dataInfo));
    }
  }

  Future<void> _onRegionDataUpdateRequested(
      RegionDataUpdateRequested event, Emitter<EntryState> emit) async {
    try {
      final latestUpdatedAt = _latestDataInfo?.regionDataLastUpdatedAt;
      if (latestUpdatedAt != null) {
        final lastUpdatedAt = _dataInfo?.regionDataLastUpdatedAt;
        if (lastUpdatedAt?.isBefore(latestUpdatedAt) != false) {
          await updateRegionsData.execute();

          await updateRegionDataLastUpdated.execute();
        }
      }

      emit(DataUpdating(finishedStep: DataUpdateStep.region));
      add(DistrictDataUpdateRequested());
    } catch (_) {
      emit(FailedToUpdate(failedStep: DataUpdateStep.region));
    }
  }

  Future<void> _onDistrictDataUpdateRequested(
      DistrictDataUpdateRequested event, Emitter<EntryState> emit) async {
    try {
      final latestUpdatedAt = _latestDataInfo?.districtDataLastUpdatedAt;
      if (latestUpdatedAt != null) {
        final lastUpdatedAt = _dataInfo?.districtDataLastUpdatedAt;
        if (lastUpdatedAt?.isBefore(latestUpdatedAt) != false) {
          await updateDistrictsData.execute();

          await updateDistrictDataLastUpdated.execute();
        }
      }

      emit(DataUpdating(finishedStep: DataUpdateStep.district));
      add(SportsCenterDataUpdateRequested());
    } catch (_) {
      emit(FailedToUpdate(failedStep: DataUpdateStep.district));
    }
  }

  Future<void> _onSportsCenterDataUpdateRequested(
      SportsCenterDataUpdateRequested event, Emitter<EntryState> emit) async {
    try {
      final latestUpdatedAt = _latestDataInfo?.sportsCenterDataLastUpdatedAt;
      if (latestUpdatedAt != null) {
        final lastUpdatedAt = _dataInfo?.sportsCenterDataLastUpdatedAt;
        if (lastUpdatedAt?.isBefore(latestUpdatedAt) != false) {
          await updateSportsCentersData.execute();

          await updateSportsCenterDataLastUpdated.execute();
        }
      }

      emit(AllUpToDate());
    } catch (_) {
      emit(FailedToUpdate(failedStep: DataUpdateStep.sportsCenter));
    }
  }

  Future<void> _onRetryUpdateRequested(
      RetryUpdateRequested event, Emitter<EntryState> emit) async {
    switch (event.retryStep) {
      case DataUpdateStep.appVersion:
        emit(DataUpdating());
        add(AppInfoRequested());
        break;
      case DataUpdateStep.dataInfo:
        emit(DataUpdating(finishedStep: DataUpdateStep.appVersion));
        add(CurrentDataInfoRequested());
        break;
      case DataUpdateStep.region:
        emit(DataUpdating(finishedStep: DataUpdateStep.dataInfo));
        add(RegionDataUpdateRequested());
        break;
      case DataUpdateStep.district:
        emit(DataUpdating(finishedStep: DataUpdateStep.region));
        add(DistrictDataUpdateRequested());
        break;
      case DataUpdateStep.sportsCenter:
        emit(DataUpdating(finishedStep: DataUpdateStep.district));
        add(SportsCenterDataUpdateRequested());
        break;
    }
  }
}
