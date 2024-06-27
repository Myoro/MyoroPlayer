import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/theme_data.dart';

enum TestTypeEnum {
  /// Any type of widget
  widget,

  /// Specifically [AppBar] widgets
  appBar,

  /// Specifically [Scaffold] widgets
  screen,
}

/// Use this widget for every widget/integration test
final class BaseTestWidget extends StatelessWidget {
  final TestTypeEnum testType;
  final ThemeMode themeMode;
  final Widget child;

  const BaseTestWidget({
    super.key,
    this.testType = TestTypeEnum.widget,
    this.themeMode = ThemeMode.dark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    late final Widget widget;

    switch (testType) {
      case TestTypeEnum.widget:
        widget = Scaffold(body: child);
        break;
      case TestTypeEnum.appBar:
        widget = Scaffold(appBar: child as PreferredSizeWidget);
        break;
      case TestTypeEnum.screen:
        widget = child;
        break;
    }

    return MaterialApp(
      themeMode: themeMode,
      theme: createTheme(false),
      darkTheme: createTheme(true),
      home: widget,
    );
  }
}
