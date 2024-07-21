import 'dart:io';

final class PlatformHelper {
  static final bool isDesktop = !Platform.isIOS && !Platform.isAndroid;
  static final bool isMobile = Platform.isIOS || Platform.isAndroid;
  static final bool isWindows = Platform.isWindows;
  static final String slash = isWindows ? '\\' : '/';
}
