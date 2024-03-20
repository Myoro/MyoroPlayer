import 'package:flutter/material.dart';

class BaseBody extends StatelessWidget {
  final Widget child;

  const BaseBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) => SizedBox(
        child: child,
      );
}
