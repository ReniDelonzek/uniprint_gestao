import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' as Foundation;

class UtilsPlatform {
  static bool isDebug() {
    return !(Foundation.kReleaseMode);
  }

  static isMobile() {
    return (!Foundation.kIsWeb && (Platform.isAndroid || Platform.isIOS));
  }

  static isWeb() {
    return (Foundation.kIsWeb);
  }

  static isDesktop() {
    return (!Foundation.kIsWeb &&
        (Platform.isWindows || Platform.isMacOS || Platform.isLinux));
  }
}
