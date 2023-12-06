part of 'entry_bloc.dart';

@immutable
abstract class EntryEvent {}

class AppInfoRequested extends EntryEvent {}

class RegionDataUpdateRequested extends EntryEvent {}

class DistrictDataUpdateRequested extends EntryEvent {}

class SportsCenterDataUpdateRequested extends EntryEvent {}
