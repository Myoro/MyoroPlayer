import 'package:flutter/material.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen.dart';
import 'package:frontend/shared/design_system/theme_data.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  windowManager.ensureInitialized();
  windowManager.setTitle('MyoroPlayer');
  windowManager.setMinimumSize(const Size(500, 500));

  runApp(const App());
}

final class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: createTheme(false),
      darkTheme: createTheme(true),
      home: const MainScreen(),
    );
  }
}
