import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/scaffolds/base_scaffold.dart';
import 'package:frontend/shared/widgets/app_bars/base_app_bar.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_app_bar/main_screen_app_bar.dart';

enum TestTypeEnum {
  /// A [Widget] with a [BaseScaffold], i.e. [MainScreen]
  screen,

  /// A [Widget] with a [BaseAppBar], i.e. [MainScreenAppBar]
  appBar,

  /// A normal [Widget]
  widget,
}

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
      case TestTypeEnum.screen:
        widget = child;
        break;
      case TestTypeEnum.appBar:
        widget = Scaffold(appBar: child as PreferredSizeWidget);
        break;
      case TestTypeEnum.widget:
        widget = Scaffold(body: child);
        break;
    }

    return MaterialApp(
      themeMode: themeMode,
      home: widget,
    );
  }
}
