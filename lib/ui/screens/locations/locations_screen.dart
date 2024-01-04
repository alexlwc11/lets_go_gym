import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/router.dart';
import 'package:lets_go_gym/ui/bloc/locations/locations_bloc.dart';
import 'package:lets_go_gym/ui/components/location_card.dart';
import 'package:lets_go_gym/ui/components/main_screen_sliver_app_bar.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationsScreen> {
  // final GlobalKey<SliverAnimatedListState> _listKey =
  //     GlobalKey<SliverAnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MainScreenSliverAppBar(
            titleText: context.appLocalization.locationsScreen_title,
          ),
          BlocBuilder<LocationsBloc, LocationsState>(
            builder: (context, state) {
              switch (state) {
                case LocationsDataLoadingInProgress():
                  return _buildLoadingContent();
                case LocationsDataUpdated(displayItemVMs: final itemVMs):
                  return _buildLocationListContent(itemVMs);
                case LocationsDataUpdateFailure():
                  // TODO Failure content
                  return _buildLoadingContent();
              }
            },
          ),
          // SliverAnimatedList(
          //   key: _listKey,
          //   itemBuilder: (context, index, animation) => Card(
          //     margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          //     clipBehavior: Clip.hardEdge,
          //     child: InkWell(
          //       onTap: () {},
          //       child: const SizedBox(
          //         height: 120,
          //         child: Padding(
          //           padding: EdgeInsets.all(12),
          //           child: Placeholder(),
          //         ),
          //       ),
          //     ),
          //   ),
          //   initialItemCount: 10,
          // ),
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

  Widget _buildLocationListContent(List<LocationItemVM> locationItemVMs) {
    return SliverList.builder(
      itemCount: locationItemVMs.length,
      itemBuilder: (context, index) =>
          _locationItemBuilder(locationItemVMs[index]),
    );
  }

  Widget _locationItemBuilder(LocationItemVM vm) {
    final langCode = context.appLocalization.localeName;

    return LocationCard(
      key: ValueKey(vm.itemId),
      heroTag: 'sports_center_id_${vm.sportsCenterId}',
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
        );
      },
      onBookmarkPressed: () {
        context
            .read<LocationsBloc>()
            .add(BookmarkUpdateRequested(itemId: vm.itemId));
      },
    );
  }
}
