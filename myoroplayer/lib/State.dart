import "package:flutter/foundation.dart";
import "Database.dart";

class _State {
  late bool darkMode;
  late Database database;

  _State() {
    this.darkMode = false;
    if(!kIsWeb)
      this.database = Database(initialized: () => database.getDarkMode().then((value) => this.darkMode = value));
  }
}

class State extends ChangeNotifier {
  _State state = _State();

  void setDarkMode() {
    if(!kIsWeb) state.database.setDarkMode(!state.darkMode);
    state.darkMode = !state.darkMode;
    notifyListeners();
  }
}
