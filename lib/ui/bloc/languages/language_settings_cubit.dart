import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/get_current_language_settings.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/update_language_settings.dart';

class LanguageSettingsCubit extends Cubit<String> {
  final GetCurrentLanguageSettings getCurrentLanguageSettings;
  final UpdateLanguageSettings updateLanguageSettings;

  LanguageSettingsCubit({
    required this.getCurrentLanguageSettings,
    required this.updateLanguageSettings,
  }) : super('') {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final currentSettings = await getCurrentLanguageSettings.execute();

    emit(currentSettings);
  }

  Future<void> updateSettings(String updatedLangCode) async {
    await updateLanguageSettings.execute(updatedLangCode);

    emit(updatedLangCode);
  }
}
