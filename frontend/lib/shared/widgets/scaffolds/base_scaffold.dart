import 'package:flutter/material.dart';

/// Use this whenever creating a new screen (i.e. MainScreen, any widget with a [Scaffold])
final class BaseScaffold extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget body;

  const BaseScaffold({
    super.key,
    required this.appBar,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
