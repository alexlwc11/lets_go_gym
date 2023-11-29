import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  AuthManager._();

  bool? _signedIn;

  factory AuthManager() {
    return _instance;
  }

  static final AuthManager _instance = AuthManager._();
  final _storage = const FlutterSecureStorage();

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final hasRunBefore = prefs.getBool(key);

    if (hasRunBefore == null) {
      await _storage.deleteAll();
      prefs.setBool(key, true);
    }
  }
}
