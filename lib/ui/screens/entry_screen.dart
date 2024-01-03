import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_go_gym/core/utils/localization_helper.dart';
import 'package:lets_go_gym/router.dart';
import 'package:lets_go_gym/ui/bloc/entry/entry_bloc.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

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
                  if (state is AllUpToDate) {
                    context.goNamed(ScreenDetails.bookmarks.name);
                  }
                },
                listenWhen: (state, newState) =>
                    state != newState && newState is AllUpToDate,
                buildWhen: (state, newState) =>
                    state != newState && newState is! AllUpToDate,
                builder: (context, state) {
                  switch (state) {
                    case AppOutdated():
                      return _buildOutdatedContent(context, state.storeUrl);
                    case DataUpdating(finishedStep: final finishedStep):
                      return _buildLoadingContent(
                        context,
                        finishedStep: finishedStep,
                      );
                    case FailedToUpdate(failedStep: final failedStep):
                      return _buildFailedToUpdateContent(
                        context,
                        failedStep,
                      );
                    default:
                      return _buildLoadingContent(context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent(
    BuildContext context, {
    DataUpdateStep? finishedStep,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox.square(
          dimension: 40,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: finishedStep?.progress ?? 0),
            duration: const Duration(milliseconds: 250),
            builder: (context, value, _) => CircularProgressIndicator(
              value: finishedStep == null ? null : value,
            ),
          ),
        ),
        Text(
          finishedStep == null
              ? context.appLocalization.entryScreen_fetchingSystemInfo
              : context.appLocalization.entryScreen_updatingData,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
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

  Widget _buildFailedToUpdateContent(
    BuildContext context,
    DataUpdateStep failedStep,
  ) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            context.appLocalization.entryScreen_failedToUpdate,
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
            onPressed: () {
              context
                  .read<EntryBloc>()
                  .add(RetryUpdateRequested(retryStep: failedStep));
            },
            child: Text(
              context.appLocalization.entryScreen_retry,
            ),
          ),
        ],
      );
}
