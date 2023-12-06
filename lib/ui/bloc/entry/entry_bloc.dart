import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/domain/entities/app_info/data_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_app_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_current_data_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_district_data.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_region_data.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_sports_center_data.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'entry_event.dart';
part 'entry_state.dart';

class EntryBloc extends Bloc<EntryEvent, EntryState> {
  final GetAppInfo getAppInfo;
  final GetCurrentDataInfo getCurrentDataInfo;
  final UpdateRegionData updateRegionData;
  final UpdateDistrictData updateDistrictData;
  final UpdateSportsCenterData updateSportsCenterData;

  EntryBloc({
    required this.getAppInfo,
    required this.getCurrentDataInfo,
    required this.updateRegionData,
    required this.updateDistrictData,
    required this.updateSportsCenterData,
  }) : super(LatestAppInfoLoadingInProgress()) {
    on<AppInfoRequested>(_onAppInfoRequested);
    on<RegionDataUpdateRequested>(_onRegionDataUpdateRequested);
    on<DistrictDataUpdateRequested>(_onDistrictDataUpdateRequested);
    on<SportsCenterDataUpdateRequested>(_onSportsCenterDataUpdateRequested);

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
        add(RegionDataUpdateRequested());
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

  Future<void> _onRegionDataUpdateRequested(
      RegionDataUpdateRequested event, Emitter<EntryState> emit) async {
    try {
      final latestUpdatedAt = _latestDataInfo?.regionDataLastUpdatedAt;
      if (latestUpdatedAt != null) {
        final lastUpdatedAt = _dataInfo?.regionDataLastUpdatedAt;
        if (lastUpdatedAt?.isBefore(latestUpdatedAt) != false) {
          await updateRegionData.execute();
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
          await updateDistrictData.execute();
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
          await updateSportsCenterData.execute();
        }
      }

      emit(AllUpToDate());
    } catch (_) {
      emit(FailedToUpdate(failedStep: DataUpdateStep.sportsCenter));
    }
  }
}
