import 'package:lets_go_gym/data/datasources/local/app_settings_local_data_source.dart';
import 'package:lets_go_gym/domain/repositories/app_settings_repository.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppSettingsLocalDataSource localDataSource;

  AppSettingsRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<String> getLanguageSettings() => localDataSource.getSelectedLanguage();

  @override
  Future<void> updateLanguageSettings(String langCode) =>
      localDataSource.updateSelectedLanguage(langCode);

  @override
  Future<String> getThemeSettings() => localDataSource.getSelectedTheme();

  @override
  Future<void> updateThemeSettings(String themeCode) =>
      localDataSource.updateSelectedTheme(themeCode);
}
