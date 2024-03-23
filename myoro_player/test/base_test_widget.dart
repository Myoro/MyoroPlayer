import 'package:flutter/material.dart';

enum TestTypeEnum {
  widget,

  /// i.e. [BaseBody], [MainScreenBody], [ResizeDivider]
  appBar,

  /// i.e. [MainScreenAppBar]
  screen

  /// i.e. [MainScreen]
}

class BaseTestWidget extends StatelessWidget {
  final TestTypeEnum testType;
  final Widget child;

  const BaseTestWidget({
    super.key,
    required this.testType,
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
      home: widget,
    );
  }
}
