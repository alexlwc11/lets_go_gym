import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_go_gym/core/utils/localization/localization_helper.dart';
import 'package:lets_go_gym/core/utils/helper/url_launcher_helper.dart';
import 'package:lets_go_gym/ui/bloc/location/location_bloc.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langCode = context.appLocalization.localeName;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar.medium(
              pinned: true,
              surfaceTintColor: Colors.transparent,
              leading: IconButton.filledTonal(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              actions: [
                BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, state) {
                    switch (state) {
                      case LocationDataLoadingInProgress():
                        return const SizedBox();
                      case LocationDataUpdated(vm: final vm):
                      case LocationDataUpdateFailure(vm: final vm):
                        return IconButton.filledTonal(
                          isSelected: vm.isBookmarked,
                          selectedIcon: const Icon(Icons.bookmark),
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {
                            context
                                .read<LocationBloc>()
                                .add(BookmarkUpdateRequested());
                          },
                        );
                    }
                  },
                ),
                // add spacing here to match with the leading spacing
                const SizedBox(width: 4),
              ],
              centerTitle: true,
              title: BlocBuilder<LocationBloc, LocationState>(
                builder: (context, state) {
                  switch (state) {
                    case LocationDataLoadingInProgress():
                      return const SizedBox();
                    case LocationDataUpdated(vm: final vm):
                    case LocationDataUpdateFailure(vm: final vm):
                      return Text(
                        vm.getSportsCenterName(langCode),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                  }
                },
              ),
              bottom: AppBar(
                automaticallyImplyLeading: false,
                surfaceTintColor: Colors.transparent,
                title: _BottomDetailsAppBarContent(),
              ),
            ),
            BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                switch (state) {
                  case LocationDataLoadingInProgress():
                    return _buildLoadingContent();
                  case LocationDataUpdated(vm: final vm):
                  case LocationDataUpdateFailure(vm: final vm):
                    return SliverList.list(
                      children: [
                        _AddressCard(vm.getSportsCenterAddress(langCode)),
                        if (vm.detailsUrl?.isNotEmpty == true)
                          _MoreDetailsCard(vm.detailsUrl!),
                      ],
                    );
                }
              },
            ),
          ],
        ),
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
}

class _BottomDetailsAppBarContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final langCode = context.appLocalization.localeName;

    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        switch (state) {
          case LocationDataLoadingInProgress():
            return const SizedBox();
          case LocationDataUpdated(vm: final vm):
          case LocationDataUpdateFailure(vm: final vm):
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (vm.hourlyQuota != null)
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              context.appLocalization
                                  .locationScreen_hourlyQuota(vm.hourlyQuota!),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      if (vm.hourlyQuota != null && vm.monthlyQuota != null)
                        Text(context.appLocalization.general_dot,
                            style: Theme.of(context).textTheme.bodySmall),
                      if (vm.monthlyQuota != null)
                        Row(
                          children: [
                            const Icon(Icons.calendar_month, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              context.appLocalization
                                  .locationScreen_monthlyQuota(
                                      vm.monthlyQuota!),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_pin, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${vm.getDistrictName(langCode)}, ${vm.getRegionName(langCode)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String address;

  const _AddressCard(this.address);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          ListTile(
            titleTextStyle: Theme.of(context).textTheme.titleMedium,
            title: Row(
              children: [
                const Icon(Icons.map),
                const SizedBox(width: 4),
                Text(context.appLocalization.locationScreen_addressCard_title),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                address,
                overflow: TextOverflow.fade,
                maxLines: 3,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Placeholder(
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Map',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreDetailsCard extends StatelessWidget {
  final String url;

  const _MoreDetailsCard(this.url);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          ListTile(
            titleTextStyle: Theme.of(context).textTheme.titleMedium,
            title: Row(
              children: [
                const Icon(Icons.info_outline),
                const SizedBox(width: 4),
                Text(context
                    .appLocalization.locationScreen_moreDetailsCard_title),
              ],
            ),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () => launchUrl(url),
          ),
        ],
      ),
    );
  }
}
