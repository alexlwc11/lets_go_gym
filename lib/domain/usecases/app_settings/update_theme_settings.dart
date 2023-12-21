import 'package:lets_go_gym/domain/repositories/app_settings_repository.dart';

class UpdateThemeSettings {
  final AppSettingsRepository repository;

  UpdateThemeSettings({required this.repository});

  Future<void> execute(String themeCode) =>
      repository.updateThemeSettings(themeCode);
}
