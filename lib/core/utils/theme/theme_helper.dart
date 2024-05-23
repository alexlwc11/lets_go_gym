import 'dart:ui';

enum ThemeItem {
  system(''),
  light('light'),
  dark('dark');

  final String themeCode;
  const ThemeItem(this.themeCode);
}

Brightness? getBrightnessFromThemeCode(String code) {
  return switch (code) {
    '' => null,
    'light' => Brightness.light,
    'dark' => Brightness.dark,
    _ => null,
  };
}
