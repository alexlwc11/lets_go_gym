import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_go_gym/core/utils/localization/localization_helper.dart';
import 'package:lets_go_gym/core/router/router.dart';
import 'package:lets_go_gym/ui/bloc/locations/locations_bloc.dart';
import 'package:lets_go_gym/ui/components/location_card.dart';
import 'package:lets_go_gym/ui/components/main_screen_sliver_app_bar.dart';
import 'package:lets_go_gym/ui/components/modals/locations_filter_modal.dart';
import 'package:lets_go_gym/ui/cubits/locations_filter/locations_filter_cubit.dart';
import 'package:lets_go_gym/ui/models/animated_list_model.dart';
import 'package:lets_go_gym/ui/models/locations_filter.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationsScreen> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  late final AnimatedListModel<LocationItemVM> _list = AnimatedListModel(
    listKey: _listKey,
    removedItemBuilder: _buildRemovedItem,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MainScreenSliverAppBar(
            titleText: context.appLocalization.locationsScreen_title,
            actions: [
              BlocConsumer<LocationsFilterCubit, LocationsFilter>(
                listenWhen: (old, newValue) {
                  return old != newValue;
                },
                listener: (_, filter) {
                  context
                      .read<LocationsBloc>()
                      .add(LocationsFilterUpdated(updateFilter: filter));
                },
                builder: (context, filter) {
                  return IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        enableDrag: false,
                        builder: (_) => LocationsFilterModal(
                          filter: filter,
                          onLocationsFilterApply: context
                              .read<LocationsFilterCubit>()
                              .updateFilters,
                        ),
                      );
                    },
                    icon: filter.isEmpty
                        ? const Icon(Icons.filter_alt_off)
                        : const Icon(Icons.filter_alt),
                  );
                },
              ),
            ],
          ),
          BlocBuilder<LocationsBloc, LocationsState>(
            builder: (context, state) {
              switch (state) {
                case LocationsDataLoadingInProgress():
                  return _buildLoadingContent();
                case LocationsDataUpdated(displayItemVMs: final itemVMs):
                  _list.update(itemVMs);
                  return _buildLocationListContent();
                case LocationsDataUpdateFailure():
                  // TODO Failure content
                  return _buildLoadingContent();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() => const SliverFillRemaining(
        child: Center(
          child: SizedBox.square(
            dimension: 40,
            child: CircularProgressIndicator(),
          ),
        ),
      );

  Widget _buildLocationListContent() => SliverAnimatedList(
        key: _listKey,
        initialItemCount: _list.length,
        itemBuilder: _itemBuilder,
      );

  Widget _itemBuilder(BuildContext _, int index, Animation<double> animation) =>
      _buildLocationCard(_list[index], animation);

  Widget _buildRemovedItem(LocationItemVM vm, Animation<double> animation) =>
      _buildLocationCard(vm, animation);

  Widget _buildLocationCard(LocationItemVM vm, Animation<double> animation) {
    final langCode = context.appLocalization.localeName;

    return FadeTransition(
      opacity: animation.drive(
        Tween(begin: 0.0, end: 1.0),
      ),
      child: LocationCard(
        key: ValueKey(vm.itemId),
        heroTag: 'locations-${vm.sportsCenterId}',
        sportsCenterName: vm.getSportsCenterName(langCode),
        sportsCenterAddress: vm.getSportsCenterAddress(langCode),
        regionName: vm.getRegionName(langCode),
        districtName: vm.getDistrictName(langCode),
        isBookmarked: vm.isBookmarked,
        onPressed: () {
          context.pushNamed(
            ScreenDetails.location.name,
            pathParameters: {
              'sports_center_id': '${vm.sportsCenterId}',
            },
            extra: 'fromLocations',
          );
        },
        onBookmarkPressed: () {
          context
              .read<LocationsBloc>()
              .add(BookmarkUpdateRequested(itemId: vm.itemId));
        },
      ),
    );
  }
}
