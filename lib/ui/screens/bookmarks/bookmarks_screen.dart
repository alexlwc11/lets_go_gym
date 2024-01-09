import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/router.dart';
import 'package:lets_go_gym/ui/bloc/bookmarks/bookmarks_bloc.dart';
import 'package:lets_go_gym/ui/components/location_card.dart';
import 'package:lets_go_gym/ui/components/main_screen_sliver_app_bar.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.add),
        onPressed: () {
          context.goNamed(ScreenDetails.locations.name);
        },
      ),
      body: CustomScrollView(
        slivers: [
          MainScreenSliverAppBar(
            titleText: context.appLocalization.bookmarksScreen_title,
          ),
          BlocBuilder<BookmarksBloc, BookmarksState>(
            builder: (context, state) {
              switch (state) {
                case BookmarksLoadingInProgress():
                  return _buildLoadingContent();
                case BookmarksDataUpdated(displayItemVMs: final itemVMs):
                  return _buildBookmarkListContent(itemVMs);
                case BookmarksDataUpdateFailure():
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

  Widget _buildBookmarkListContent(List<BookmarkItemVM> bookmarkItemVMs) {
    if (bookmarkItemVMs.isEmpty) return _buildEmptyBody();

    return SliverList.builder(
      itemCount: bookmarkItemVMs.length,
      itemBuilder: (context, index) =>
          _bookmarkItemBuilder(bookmarkItemVMs[index]),
    );
  }

  Widget _bookmarkItemBuilder(BookmarkItemVM vm) {
    final langCode = context.appLocalization.localeName;

    return LocationCard(
      key: ValueKey(vm.itemId),
      heroTag: 'bookmarks-${vm.sportsCenterId}',
      sportsCenterName: vm.getSportsCenterName(langCode),
      sportsCenterAddress: vm.getSportsCenterAddress(langCode),
      regionName: vm.getRegionName(langCode),
      districtName: vm.getDistrictName(langCode),
      isBookmarked: true,
      onPressed: () {
        context.pushNamed(
          ScreenDetails.location.name,
          pathParameters: {
            'sports_center_id': '${vm.sportsCenterId}',
          },
          extra: 'fromBookmarks',
        );
      },
      onBookmarkPressed: () {
        context
            .read<BookmarksBloc>()
            .add(BookmarkUpdateRequested(itemId: vm.itemId));
      },
    );
  }

  Widget _buildEmptyBody() {
    return SliverFillRemaining(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bookmark_add_outlined,
            size: 120,
          ),
          Text(
            context.appLocalization.bookmarksScreen_emptyTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            context.appLocalization.bookmarksScreen_emptyHints,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
