import 'package:lets_go_gym/domain/repositories/app_settings_repository.dart';

class GetCurrentThemeSettings {
  final AppSettingsRepository repository;

  GetCurrentThemeSettings({required this.repository});

  Future<String> execute() => repository.getThemeSettings();
}
