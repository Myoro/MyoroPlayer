import 'dart:io';

class PlatformHelper {
  final bool isDesktop = !Platform.isIOS && !Platform.isAndroid;
  final bool isMobile = Platform.isIOS || Platform.isAndroid;
  final bool isWindows = Platform.isWindows;
  final String slash = Platform.isWindows ? '\\' : '/';
}
