import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/router.dart';
import 'package:lets_go_gym/ui/bloc/entry/entry_bloc.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  final Widget _loadingContent = const SizedBox.square(
    dimension: 40,
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = constraints.maxWidth * 0.5;

                // TODO show app icon
                return SizedBox.square(
                  dimension: size,
                  child: const Placeholder(
                    child: Center(
                      child: Text("AppIcon"),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 120,
            child: Center(
              child: BlocConsumer<EntryBloc, EntryState>(
                  listener: (context, state) {
                    if (state is AppUpToDate) {
                      context.go(ScreenPaths.bookmarks);
                    }
                  },
                  listenWhen: (oldState, newState) =>
                      oldState != newState && newState is AppUpToDate,
                  buildWhen: (oldState, newState) =>
                      oldState != newState && newState is AppOutdated,
                  builder: (context, state) {
                    switch (state) {
                      case AppOutdated():
                        return _buildOutdatedContent(context, state.storeUrl);
                      default:
                        return _loadingContent;
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutdatedContent(
    BuildContext context,
    String storeUrl,
  ) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            context.appLocalization.entryScreen_pleaseUpdateToContinue,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 62)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
            onPressed: () async {
              // await _launchUrl(context, storeUrl);
            },
            child: Text(
              context.appLocalization.entryScreen_update,
            ),
          ),
        ],
      );
}
