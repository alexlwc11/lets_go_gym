import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _hasRunBeforeKey = 'letsGoGym_hasRunBefore';

Future<void> clearSecureStorageOnReinstall({
  required FlutterSecureStorage secureStorage,
  required SharedPreferences sharedPreferences,
}) async {
  final hasRunBefore = sharedPreferences.getBool(_hasRunBeforeKey);

  if (hasRunBefore == null) {
    await secureStorage.deleteAll();
    await sharedPreferences.clear();
    sharedPreferences.setBool(_hasRunBeforeKey, true);
  }
}
