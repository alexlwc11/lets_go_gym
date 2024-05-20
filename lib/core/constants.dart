import 'dart:io';

// TODO update
class ApiConstants {
  static String get baseUrl =>
      '${Platform.isIOS ? _localhostIOS : _localhostAndroid}/api/v1';
  static const String _prodBaseUrl = '';
  static const String _devBaseUrl = '';
  static const String _localhostAndroid = 'http://10.0.2.2:8080';
  static const String _localhostIOS = 'http://localhost:8080';
}
