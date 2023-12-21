import 'package:lets_go_gym/domain/repositories/app_settings_repository.dart';

class GetCurrentLanguageSettings {
  final AppSettingsRepository repository;

  GetCurrentLanguageSettings({required this.repository});

  Future<String> execute() => repository.getLanguageSettings();
}
