import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/get_current_language_settings.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/update_language_settings.dart';

class LanguageSettingsCubit extends Cubit<String> {
  final GetCurrentLanguageSettings _getCurrentLanguageSettings;
  final UpdateLanguageSettings _updateLanguageSettings;

  LanguageSettingsCubit({
    required GetCurrentLanguageSettings getCurrentLanguageSettings,
    required UpdateLanguageSettings updateLanguageSettings,
  })  : _updateLanguageSettings = updateLanguageSettings,
        _getCurrentLanguageSettings = getCurrentLanguageSettings,
        super('') {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final currentSettings = await _getCurrentLanguageSettings.execute();

    emit(currentSettings);
  }

  Future<void> updateSettings(String updatedLangCode) async {
    await _updateLanguageSettings.execute(updatedLangCode);

    emit(updatedLangCode);
  }
}
