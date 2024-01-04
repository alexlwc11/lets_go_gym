import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/ui/bloc/location/location_bloc.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langCode = context.appLocalization.localeName;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              switch (state) {
                case LocationDataLoadingInProgress():
                  return const _SliverAppBar(titleText: '');
                case LocationDataUpdated(vm: final vm):
                case LocationDataUpdateFailure(vm: final vm):
                  return _SliverAppBar(
                    titleText: vm.getSportsCenterName(langCode),
                    actions: [
                      IconButton(
                        isSelected: vm.isBookmarked,
                        selectedIcon: const Icon(Icons.bookmark),
                        icon: const Icon(Icons.bookmark_border),
                        onPressed: () {
                          context
                              .read<LocationBloc>()
                              .add(BookmarkUpdateRequested());
                        },
                      ),
                    ],
                  );
              }
            },
          ),
          BlocBuilder<LocationBloc, LocationState>(
            builder: (context, state) {
              switch (state) {
                case LocationDataLoadingInProgress():
                  return _buildLoadingContent();
                case LocationDataUpdated(vm: final vm):
                case LocationDataUpdateFailure(vm: final vm):
                  return _buildLocationContent(vm, langCode);
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

  Widget _buildLocationContent(LocationVM vm, String langCode) => SliverList(
        delegate: SliverChildListDelegate(
          [
            _InfoSection(vm),
          ],
        ),
      );
}

class _InfoSection extends StatelessWidget {
  final LocationVM vm;

  const _InfoSection(this.vm);

  @override
  Widget build(BuildContext context) {
    final langCode = context.appLocalization.localeName;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              children: [
                const Icon(Icons.info_outline),
                const SizedBox(width: 8),
                Text(
                  'Info',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.keyboard_arrow_up),
                )
              ],
            ),
          ),
          // Divider(),
          // const SizedBox(height: 12),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     const Icon(Icons.people, size: 16),
          //     const SizedBox(width: 4),
          //     Expanded(
          //       child: Text(
          //         'Hourly quota: ${vm.hourlyQuota} | Monthly quota: ${vm.monthlyQuota}',
          //         style: Theme.of(context).textTheme.bodySmall,
          //         overflow: TextOverflow.fade,
          //         maxLines: 1,
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(height: 4),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     const Icon(Icons.location_pin, size: 16),
          //     const SizedBox(width: 4),
          //     Expanded(
          //       child: Text(
          //         '${vm.getDistrictName(langCode)}, ${vm.getRegionName(langCode)}',
          //         style: Theme.of(context).textTheme.bodySmall,
          //         overflow: TextOverflow.fade,
          //         maxLines: 1,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class _SliverAppBar extends StatelessWidget {
  final double _defaultExpandedHeight = 130;

  final String titleText;
  final List<Widget>? actions;

  const _SliverAppBar({
    required this.titleText,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.large(
      pinned: true,
      expandedHeight: _defaultExpandedHeight,
      title: Text(
        titleText,
        style: Theme.of(context).appBarTheme.toolbarTextStyle,
        maxLines: 2,
        overflow: TextOverflow.fade,
      ),
      actions: actions,
    );
  }
}
