part of 'entry_bloc.dart';

@immutable
sealed class EntryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DataUpdating extends EntryState {
  final DataUpdateStep? finishedStep;

  DataUpdating({this.finishedStep});

  @override
  List<Object?> get props => [finishedStep];
}

class AppOutdated extends EntryState {
  final String storeUrl;

  AppOutdated({required this.storeUrl});
}

class AppUpToDate extends EntryState {}

class AllUpToDate extends EntryState {}

class FailedToUpdate extends EntryState {
  final DataUpdateStep failedStep;

  FailedToUpdate({required this.failedStep});

  @override
  List<Object?> get props => [failedStep];
}

enum DataUpdateStep {
  appVersion(0.2),
  dataInfo(0.3),
  region(0.4),
  district(0.6),
  sportsCenter(0.8);

  final double progress;
  const DataUpdateStep(this.progress);
}
