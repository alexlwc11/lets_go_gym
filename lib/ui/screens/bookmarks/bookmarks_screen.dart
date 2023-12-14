import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/router.dart';
import 'package:lets_go_gym/ui/components/main_screen_sliver_app_bar.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.add),
        onPressed: () {
          context.go(ScreenPaths.locations);
        },
      ),
      body: CustomScrollView(
        slivers: [
          MainScreenSliverAppBar(
            titleText: context.appLocalization.bookmarksScreen_title,
          ),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // TODO bloc
    return SliverFillRemaining(
      child: _buildEmptyBody(context),
    );
  }

  // TODO implement
  Widget _buildListBody(BuildContext context) {
    return const Placeholder();
  }

  Widget _buildEmptyBody(BuildContext context) {
    return Column(
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
    );
  }
}
