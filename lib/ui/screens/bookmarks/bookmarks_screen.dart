import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/router.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.appLocalization.bookmarksScreen_title),
      ),
      floatingActionButton: FloatingActionButton.large(
        child: const Icon(Icons.add),
        onPressed: () {
          context.go(ScreenPaths.location);
        },
      ),
      // TODO bloc
      body: _buildEmptyBody(context),
    );
  }

  Widget _buildEmptyBody(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
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
            // Text(
            //   context.appLocalization.bookmarksScreen_emptyHints,
            //   style: Theme.of(context).textTheme.bodyMedium,
            //   textAlign: TextAlign.center,
            // )
          ],
        ),
      ),
    );
  }

  // TODO implement
  Widget _buildListBody(BuildContext context) {
    return const Placeholder();
  }
}
