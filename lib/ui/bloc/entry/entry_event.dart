part of 'entry_bloc.dart';

@immutable
abstract class EntryEvent {}

class AppInfoRequested extends EntryEvent {}

class CurrentDataInfoRequested extends EntryEvent {}

class RegionDataUpdateRequested extends EntryEvent {}

class DistrictDataUpdateRequested extends EntryEvent {}

class SportsCenterDataUpdateRequested extends EntryEvent {}

class RetryUpdateRequested extends EntryEvent {
  final DataUpdateStep retryStep;

  RetryUpdateRequested({required this.retryStep});
}
