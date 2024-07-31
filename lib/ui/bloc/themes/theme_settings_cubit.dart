import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/get_current_theme_settings.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/update_theme_settings.dart';

class ThemeSettingsCubit extends Cubit<String> {
  final GetCurrentThemeSettings _getCurrentThemeSettings;
  final UpdateThemeSettings _updateThemeSettings;

  ThemeSettingsCubit({
    required GetCurrentThemeSettings getCurrentThemeSettings,
    required UpdateThemeSettings updateThemeSettings,
  })  : _updateThemeSettings = updateThemeSettings,
        _getCurrentThemeSettings = getCurrentThemeSettings,
        super('') {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final currentSettings = await _getCurrentThemeSettings.execute();

    emit(currentSettings);
  }

  Future<void> updateSettings(String updatedThemeCode) async {
    await _updateThemeSettings.execute(updatedThemeCode);

    emit(updatedThemeCode);
  }
}
