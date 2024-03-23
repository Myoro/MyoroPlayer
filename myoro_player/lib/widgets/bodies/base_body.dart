import 'package:flutter/material.dart';

class BaseBody extends StatelessWidget {
  final Widget child;

  const BaseBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: SizedBox.expand(
          child: child,
        ),
      );
}
