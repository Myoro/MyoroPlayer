import 'package:flutter/material.dart';

/// Use this whenever implements a [body] for a [Scaffold]
final class BaseBody extends StatelessWidget {
  final Widget child;

  const BaseBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(child: child);
}
