import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  final SharedPreferences _sharedPreferences;
  final FlutterSecureStorage _storage;

  AuthManager({
    required SharedPreferences sharedPreferences,
    required FlutterSecureStorage flutterSecureStorage,
  })  : _sharedPreferences = sharedPreferences,
        _storage = flutterSecureStorage;

  bool? _signedIn;

  Future<bool> get isSignedIn async {
    _signedIn ??= (await getToken()) != null;

    return _signedIn!;
  }

  Future<String> get authHeader async {
    final token = await getToken();
    return 'Bearer $token';
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: 'token');
    return token;
  }

  Future<void> saveToken({required String token}) async {
    await _storage.write(key: 'token', value: token);
    _signedIn = true;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
    _signedIn = false;
  }

  Future<void> clearSecureStorageOnReinstall() async {
    String key = 'hasRunBefore';
    final hasRunBefore = _sharedPreferences.getBool(key);

    if (hasRunBefore == null) {
      await _storage.deleteAll();
      _sharedPreferences.setBool(key, true);
    }
  }
}
