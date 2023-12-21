import 'package:shared_preferences/shared_preferences.dart';

const _selectedLanguageKey = 'selectedLanguage';
const _selectedThemeKey = 'selectedTheme';

abstract class AppSettingsLocalDataSource {
  Future<String> getSelectedLanguage();
  Future<void> updateSelectedLanguage(String langCode);
  Future<String> getSelectedTheme();
  Future<void> updateSelectedTheme(String themeCode);
}

class AppSettingsLocalDataSourceImpl implements AppSettingsLocalDataSource {
  final SharedPreferences _sharedPreferences;

  AppSettingsLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<String> getSelectedLanguage() async {
    return _sharedPreferences.getString(_selectedLanguageKey) ?? '';
  }

  @override
  Future<void> updateSelectedLanguage(String langCode) async {
    await _sharedPreferences.setString(
      _selectedLanguageKey,
      langCode,
    );
  }

  @override
  Future<String> getSelectedTheme() async {
    return _sharedPreferences.getString(_selectedThemeKey) ?? '';
  }

  @override
  Future<void> updateSelectedTheme(String themeCode) async {
    await _sharedPreferences.setString(
      _selectedThemeKey,
      themeCode,
    );
  }
}
