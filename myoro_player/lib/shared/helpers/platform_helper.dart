import 'dart:io';

class PlatformHelper {
  static bool get isDesktop => !Platform.isIOS && !Platform.isAndroid;
}
