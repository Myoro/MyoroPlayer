import 'dart:io';

final class PlatformHelper {
  static final bool isDesktop = !Platform.isIOS && !Platform.isAndroid;
}
