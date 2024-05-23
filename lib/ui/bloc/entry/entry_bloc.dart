import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/core/utils/helper/uuid_helper.dart';
import 'package:lets_go_gym/domain/entities/app_info/data_info.dart';
import 'package:lets_go_gym/domain/entities/token/session_token.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_app_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_current_data_info.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_district_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_region_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/app_info/update_sports_center_data_last_updated.dart';
import 'package:lets_go_gym/domain/usecases/auth/get_device_uuid.dart';
import 'package:lets_go_gym/domain/usecases/auth/get_stored_session_token.dart';
import 'package:lets_go_gym/domain/usecases/auth/register_new_user.dart';
import 'package:lets_go_gym/domain/usecases/auth/save_device_uuid.dart';
import 'package:lets_go_gym/domain/usecases/auth/save_session_token.dart';
import 'package:lets_go_gym/domain/usecases/auth/user_sign_in.dart';
import 'package:lets_go_gym/domain/usecases/districts/update_districts_data.dart';
import 'package:lets_go_gym/domain/usecases/regions/update_regions_data.dart';
import 'package:lets_go_gym/domain/usecases/sports_centers/update_sports_centers_data.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'entry_event.dart';
part 'entry_state.dart';

class EntryBloc extends Bloc<EntryEvent, EntryState> {
  final RegisterNewUser registerNewUser;
  final UserSignIn userSignIn;
  final GetDeviceUUID getDeviceUUID;
  final SaveDeviceUUID saveDeviceUUID;
  final GetStoredSessionToken getStoredSessionToken;
  final SaveSessionToken saveSessionToken;
  final GetAppInfo getAppInfo;
  final GetCurrentDataInfo getCurrentDataInfo;
  final UpdateRegionsData updateRegionsData;
  final UpdateDistrictsData updateDistrictsData;
  final UpdateSportsCentersData updateSportsCentersData;
  final UpdateRegionDataLastUpdated updateRegionDataLastUpdated;
  final UpdateDistrictDataLastUpdated updateDistrictDataLastUpdated;
  final UpdateSportsCenterDataLastUpdated updateSportsCenterDataLastUpdated;

  EntryBloc({
    required this.registerNewUser,
    required this.userSignIn,
    required this.getDeviceUUID,
    required this.saveDeviceUUID,
    required this.getStoredSessionToken,
    required this.saveSessionToken,
    required this.getAppInfo,
    required this.getCurrentDataInfo,
    required this.updateRegionsData,
    required this.updateDistrictsData,
    required this.updateSportsCentersData,
    required this.updateRegionDataLastUpdated,
    required this.updateDistrictDataLastUpdated,
    required this.updateSportsCenterDataLastUpdated,
  }) : super(DataUpdating()) {
    on<AuthTokenRequested>(_onAuthTokenRequested);
    on<AppInfoRequested>(_onAppInfoRequested);
    on<CurrentDataInfoRequested>(_onCurrentDataInfoRequested);
    on<RegionDataUpdateRequested>(_onRegionDataUpdateRequested);
    on<DistrictDataUpdateRequested>(_onDistrictDataUpdateRequested);
    on<SportsCenterDataUpdateRequested>(_onSportsCenterDataUpdateRequested);
    on<RetryUpdateRequested>(_onRetryUpdateRequested);

    add(AuthTokenRequested());
  }

  DataInfo? _latestDataInfo;
  DataInfo? _dataInfo;

  Future<void> _onAuthTokenRequested(
      AuthTokenRequested event, Emitter<EntryState> emit) async {
    try {
      String? deviceUUID = await getDeviceUUID.execute();
      SessionToken? storedSessionToken = await getStoredSessionToken.execute();
      if (deviceUUID == null) {
        // no device UUID found, generate new UUID and register as new user
        final newDeviceUUID = generateUUID();
        final newSessionToken = await registerNewUser.execute(newDeviceUUID);
        await saveSessionToken.execute(newSessionToken);
        await saveDeviceUUID.execute(newDeviceUUID);
      } else if (storedSessionToken == null ||
          (storedSessionToken.sessionTokenExpiredAt.isBefore(DateTime.now()) &&
              storedSessionToken.refreshTokenExpiredAt
                  .isBefore(DateTime.now()))) {
        // sign in with the stored device UUID if:
        // 1. no session token found OR
        // 2. session token and refresh token are expired
        final newSessionToken = await userSignIn.execute(deviceUUID);
        await saveSessionToken.execute(newSessionToken);
      }

      emit(DataUpdating(finishedStep: AppInitStep.authToken));
      add(AppInfoRequested());
    } catch (_) {
      emit(FailedToUpdate(failedStep: AppInitStep.authToken));
    }
  }

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
        emit(DataUpdating(finishedStep: AppInitStep.appVersion));
        add(CurrentDataInfoRequested());
      } else {
        // TODO update store url
        // final storeUrl = Platform.isIOS
        //     ? latestAppInfo.iosAppLink ?? ''
        //     : latestAppInfo.androidAppLink ?? '';
        emit(AppOutdated(storeUrl: ''));
      }
    } catch (_) {
      emit(FailedToUpdate(failedStep: AppInitStep.appVersion));
    }
  }

  Future<void> _onCurrentDataInfoRequested(
      CurrentDataInfoRequested event, Emitter<EntryState> emit) async {
    try {
      _dataInfo = await getCurrentDataInfo.execute();

      emit(DataUpdating(finishedStep: AppInitStep.dataInfo));
      add(RegionDataUpdateRequested());
    } catch (_) {
      emit(FailedToUpdate(failedStep: AppInitStep.dataInfo));
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

      emit(DataUpdating(finishedStep: AppInitStep.region));
      add(DistrictDataUpdateRequested());
    } catch (_) {
      emit(FailedToUpdate(failedStep: AppInitStep.region));
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

      emit(DataUpdating(finishedStep: AppInitStep.district));
      add(SportsCenterDataUpdateRequested());
    } catch (_) {
      emit(FailedToUpdate(failedStep: AppInitStep.district));
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
      emit(FailedToUpdate(failedStep: AppInitStep.sportsCenter));
    }
  }

  Future<void> _onRetryUpdateRequested(
      RetryUpdateRequested event, Emitter<EntryState> emit) async {
    switch (event.retryStep) {
      case AppInitStep.authToken:
        emit(DataUpdating());
        add(AuthTokenRequested());
        break;
      case AppInitStep.appVersion:
        emit(DataUpdating(finishedStep: AppInitStep.authToken));
        add(AppInfoRequested());
        break;
      case AppInitStep.dataInfo:
        emit(DataUpdating(finishedStep: AppInitStep.appVersion));
        add(CurrentDataInfoRequested());
        break;
      case AppInitStep.region:
        emit(DataUpdating(finishedStep: AppInitStep.dataInfo));
        add(RegionDataUpdateRequested());
        break;
      case AppInitStep.district:
        emit(DataUpdating(finishedStep: AppInitStep.region));
        add(DistrictDataUpdateRequested());
        break;
      case AppInitStep.sportsCenter:
        emit(DataUpdating(finishedStep: AppInitStep.district));
        add(SportsCenterDataUpdateRequested());
        break;
    }
  }
}
