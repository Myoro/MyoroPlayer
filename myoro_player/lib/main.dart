import 'package:flutter/material.dart';
import 'package:myoro_player/screens/main_screen/widgets/main_screen.dart';
import 'package:myoro_player/shared/design_system/theme_data.dart';
import 'package:myoro_player/shared/helpers/platform_helper.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (PlatformHelper.isDesktop) {
    windowManager.ensureInitialized();
    windowManager.setTitle('MyoroPlayer');
    windowManager.setMinimumSize(const Size(600, 600));
  }

  runApp(const App());
}

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyoroPlayer',
      themeMode: ThemeMode.dark,
      theme: createTheme(false),
      darkTheme: createTheme(true),
      home: MainScreen(),
    );
  }
}
