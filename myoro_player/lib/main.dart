import 'package:flutter/material.dart';
import 'package:myoro_player/theme/theme_data.dart';
import 'package:myoro_player/widgets/screens/main_screen.dart';

void main() {
  runApp(
    const App(),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'MyoroPlayer',
        theme: createTheme(isDarkMode: false),
        darkTheme: createTheme(isDarkMode: true),
        home: const MainScreen(),
      );
}
