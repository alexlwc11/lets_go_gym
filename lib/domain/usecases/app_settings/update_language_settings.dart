import 'package:lets_go_gym/domain/repositories/app_settings_repository.dart';

class UpdateLanguageSettings {
  final AppSettingsRepository repository;

  UpdateLanguageSettings({required this.repository});

  Future<void> execute(String langCode) =>
      repository.updateLanguageSettings(langCode);
}
