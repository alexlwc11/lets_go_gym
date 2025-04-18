const String appFlavor = String.fromEnvironment('FLUTTER_APP_FLAVOR');

enum AppFlavor {
  develop(name: 'develop'),
  staging(name: 'staging'),
  production(name: 'production');

  final String name;

  const AppFlavor({
    required this.name,
  });

  static String get appFlavorLabel =>
      appFlavor == AppFlavor.production.name ? '' : appFlavor;
}
