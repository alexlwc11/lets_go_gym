abstract class AppSettingsRepository {
  Future<String> getLanguageSettings();
  Future<void> updateLanguageSettings(String langCode);
  Future<String> getThemeSettings();
  Future<void> updateThemeSettings(String themeCode);
}
