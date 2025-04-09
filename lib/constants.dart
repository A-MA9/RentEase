import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

String get baseUrl {
  if (kIsWeb) {
    return "http://localhost:8000";
  } else if (Platform.isAndroid) {
    return "http://10.0.2.2:8000";
  } else {
    return "http://localhost:8000";
  }
}

const String otpUrl = "http://65.0.71.28:3000";
