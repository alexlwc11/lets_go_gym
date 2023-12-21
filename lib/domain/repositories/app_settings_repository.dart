abstract class AppSettingsRepository {
  Future<String> getLanguageSettings();
  Future<void> updateLanguageSettings(String langCode);
}
