import 'package:flutter/material.dart';

/// SliverAppBar component for tabs in main screen, fixed the style for consistency
class MainScreenSliverAppBar extends StatelessWidget {
  final double _defaultExpandedHeight = 120;

  final String titleText;

  const MainScreenSliverAppBar({
    super.key,
    required this.titleText,
  });

  @override
  Widget build(BuildContext context) => SliverAppBar.large(
        pinned: true,
        expandedHeight: _defaultExpandedHeight,
        title: Text(
          titleText,
          style: Theme.of(context).appBarTheme.toolbarTextStyle,
          maxLines: 2,
          overflow: TextOverflow.fade,
        ),
      );
}
