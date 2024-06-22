import 'package:flutter/material.dart';

/// When creating a new screen, it must use [BaseScaffold]
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
