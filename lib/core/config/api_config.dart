import 'package:flutter/foundation.dart';

class ApiConfig {
  // IP for Web / Physical Device (User provided)
  static const String _localIp = "http://192.168.1.14:8000/";

  // IP for Android Emulator
  static const String _emulatorIp = "http://10.0.2.2:8000/";

  static String get baseUrl {
    if (kIsWeb) {
      return "${_localIp}api/";
    }
    // Default to emulator for mobile, or change to _localIp if using physical device
    return "${_emulatorIp}api/";
  }

  static String get imageBaseUrl {
    // Images must be accessed from actual network IP, not emulator localhost
    // because they are static files served by the web server
    return _localIp;
  }
}
