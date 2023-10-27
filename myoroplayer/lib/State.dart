import "package:flutter/foundation.dart";

class _State {
  bool darkMode;

  _State({
    this.darkMode = false
  });
}

class State extends ChangeNotifier {
  _State state = _State();

  void setDarkMode() { state.darkMode = !state.darkMode; notifyListeners(); }
}
