part of 'entry_bloc.dart';

@immutable
sealed class EntryState {}

class LatestAppInfoLoadingInProgress extends EntryState {}

class AppOutdated extends EntryState {
  final String storeUrl;

  AppOutdated({required this.storeUrl});
}

class AppUpToDate extends EntryState {}

class DataUpdating extends EntryState {
  final DataUpdateStep finishedStep;

  DataUpdating({required this.finishedStep});
}

class AllUpToDate extends EntryState {}

class FailedToUpdate extends EntryState {
  final DataUpdateStep failedStep;

  FailedToUpdate({required this.failedStep});
}

enum DataUpdateStep {
  appVersion,
  region,
  district,
  sportsCenter;
}
