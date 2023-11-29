import 'package:flutter/material.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) => _EntryScreenBody();
}

class _EntryScreenBody extends StatelessWidget {
  final Widget _loadingContent = const SizedBox.square(
    dimension: 40,
    child: CircularProgressIndicator(),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
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
            // TODO wrap with bloc
            SizedBox(
              height: 120,
              child: Center(
                child: _loadingContent,
              ),
            ),
          ],
        ),
      );
}
