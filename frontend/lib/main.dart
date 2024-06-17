import 'package:flutter/material.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen.dart';
import 'package:frontend/shared/design_system/theme_data.dart';

void main() => runApp(const _App());

final class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: createTheme(false),
      darkTheme: createTheme(true),
      home: const MainScreen(),
    );
  }
}
