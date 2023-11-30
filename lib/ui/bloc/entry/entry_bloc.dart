import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/domain/usecases/app_info/get_app_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'entry_event.dart';
part 'entry_state.dart';

class EntryBloc extends Bloc<EntryEvent, EntryState> {
  final GetAppInfo getAppInfo;

  EntryBloc({required this.getAppInfo})
      : super(LatestAppInfoLoadingInProgress()) {
    on<AppInfoRequested>(_onAppInfoRequested);

    add(AppInfoRequested());
  }

  Future<void> _onAppInfoRequested(
      AppInfoRequested event, Emitter<EntryState> emit) async {
    try {
      final latestAppInfo = await getAppInfo.execute();
      final packageInfo = await PackageInfo.fromPlatform();
      final minimumBuildVersion = latestAppInfo.minimumBuildVersion ?? 0;
      final currentBuildVersion = int.parse(packageInfo.buildNumber);

      if (currentBuildVersion >= minimumBuildVersion) {
        emit(AppUpToDate());
      } else {
        // TODO update store url
        // final storeUrl = Platform.isIOS
        //     ? latestAppInfo.iosAppLink ?? ''
        //     : latestAppInfo.androidAppLink ?? '';
        emit(AppOutdated(storeUrl: ''));
      }
    } catch (_) {
      emit(AppUpToDate());
    }
  }
}
