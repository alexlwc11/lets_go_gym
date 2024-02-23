import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/di.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/ui/bloc/locations_filter_modal/locations_filter_modal_bloc.dart';
import 'package:lets_go_gym/ui/cubits/locations_filter/locations_filter_cubit.dart';
import 'package:lets_go_gym/ui/models/locations_filter.dart';

class LocationsFilterModal extends StatelessWidget {
  final LocationsFilter filter;
  final ValueSetter<LocationsFilter>? onLocationsFilterApply;

  const LocationsFilterModal(
      {super.key, required this.filter, this.onLocationsFilterApply});

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: di.sl.get<LocationsFilterModalBloc>(param1: filter),
        child: _LocationsFilterModalBody(
          onLocationsFilterApply: onLocationsFilterApply,
        ),
      );
}

class _LocationsFilterModalBody extends StatefulWidget {
  final ValueSetter<LocationsFilter>? onLocationsFilterApply;

  const _LocationsFilterModalBody({this.onLocationsFilterApply});

  @override
  State<_LocationsFilterModalBody> createState() =>
      _LocationsFilterModalBodyState();
}

class _LocationsFilterModalBodyState extends State<_LocationsFilterModalBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationsFilterModalBloc, LocationsFilterModalState>(
      builder: (context, state) {
        switch (state) {
          case LocationsFilterModalDataUpdated(
              regionChipItemVMs: List<RegionChipItemVM> regionChipItemVMs,
              districtChipItemVMs: List<DistrictChipItemVM> districtChipItemVMs
            ):
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  scrolledUnderElevation: 0,
                  title: Text('Filter'),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        context
                            .read<LocationsFilterModalBloc>()
                            .add(ApplyFilterRequested(
                              onLocationsFilterApply:
                                  widget.onLocationsFilterApply,
                            ));
                        context.pop();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRegionSection(
                            regionChipItemVMs: regionChipItemVMs),
                        _buildDistrictSection(
                            districtChipItemVM: districtChipItemVMs),
                      ],
                    ),
                  ),
                )
              ],
            );
          default:
            return const Center(
              child: SizedBox.square(
                dimension: 40,
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }

  Widget _buildRegionSection(
      {required List<RegionChipItemVM> regionChipItemVMs}) {
    final langCode = context.appLocalization.localeName;
    final noFilterSelected =
        regionChipItemVMs.firstWhereOrNull((vm) => vm.isSelected) == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Regions',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Wrap(
          spacing: 4,
          children: [
            FilterChip.elevated(
              key: const ValueKey('all-region-chip'),
              padding: const EdgeInsets.all(4),
              label: Text('All'),
              selected: noFilterSelected,
              onSelected: (_) {
                context
                    .read<LocationsFilterModalBloc>()
                    .add(AllRegionChipSelected());
              },
            ),
            ...regionChipItemVMs.map(
              (vm) => FilterChip.elevated(
                key: ValueKey(vm.itemId),
                padding: const EdgeInsets.all(4),
                label: Text(vm.getRegionName(langCode)),
                selected: vm.isSelected,
                onSelected: (selected) {
                  context
                      .read<LocationsFilterModalBloc>()
                      .add(RegionFilterUpdateRequested(
                        regionId: vm.regionId,
                        isSelected: selected,
                      ));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDistrictSection(
      {required List<DistrictChipItemVM> districtChipItemVM}) {
    final langCode = context.appLocalization.localeName;
    final noFilterSelected =
        districtChipItemVM.firstWhereOrNull((vm) => vm.isSelected) == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Districts',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Wrap(
          spacing: 4,
          children: [
            FilterChip.elevated(
              key: const ValueKey('all-district-chip'),
              padding: const EdgeInsets.all(4),
              label: Text('All'),
              selected: noFilterSelected,
              onSelected: (_) {
                context
                    .read<LocationsFilterModalBloc>()
                    .add(AllDistrictChipSelected());
              },
            ),
            ...districtChipItemVM.map(
              (vm) => FilterChip.elevated(
                key: ValueKey(vm.itemId),
                padding: const EdgeInsets.all(4),
                label: Text(vm.getDistrictName(langCode)),
                selected: vm.isSelected,
                onSelected: (selected) {
                  context
                      .read<LocationsFilterModalBloc>()
                      .add(DistrictFilterUpdateRequested(
                        districtId: vm.districtId,
                        isSelected: selected,
                      ));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
