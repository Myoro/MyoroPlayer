enum PlatformEnum {
  windows,
  mac,
  linux,
  android,
  ios;

  bool get isWindows => this == windows;
  bool get isMac => this == mac;
  bool get isLinux => this == linux;
  bool get isAndroid => this == android;
  bool get isIos => this == ios;

  bool get isDesktop => this == windows || this == mac || this == linux;
  bool get isMobile => this == android || this == ios;
}
