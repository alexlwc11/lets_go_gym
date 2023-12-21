import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/get_current_theme_settings.dart';
import 'package:lets_go_gym/domain/usecases/app_settings/update_theme_settings.dart';

class ThemeSettingsCubit extends Cubit<String> {
  final GetCurrentThemeSettings getCurrentThemeSettings;
  final UpdateThemeSettings updateThemeSettings;

  ThemeSettingsCubit({
    required this.getCurrentThemeSettings,
    required this.updateThemeSettings,
  }) : super('') {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final currentSettings = await getCurrentThemeSettings.execute();

    emit(currentSettings);
  }

  Future<void> updateSettings(String updatedThemeCode) async {
    await updateThemeSettings.execute(updatedThemeCode);

    emit(updatedThemeCode);
  }
}
