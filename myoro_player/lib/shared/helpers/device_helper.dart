// coverage:ignore-file

import 'dart:io';

/// To mock commands such as [exit(0)]
class DeviceHelper {
  void quit() => exit(0);
}
