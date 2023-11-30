part of 'entry_bloc.dart';

@immutable
sealed class EntryState {}

class LatestAppInfoLoadingInProgress extends EntryState {}

class AppOutdated extends EntryState {
  final String storeUrl;

  AppOutdated({required this.storeUrl});
}

class AppUpToDate extends EntryState {}
