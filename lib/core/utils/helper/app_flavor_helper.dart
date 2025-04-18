const String appFlavor = String.fromEnvironment('FLUTTER_APP_FLAVOR');
const String _devFlavor = 'develop';
const String _stagingFlavor = 'staging';
const String _prodFlavor = 'production';

String get appFlavorLabel => appFlavor == _prodFlavor ? '' : appFlavor;
