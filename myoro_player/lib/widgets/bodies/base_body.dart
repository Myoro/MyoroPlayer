import 'package:flutter/material.dart';

class BaseBody extends StatelessWidget {
  final Widget child;

  const BaseBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [child],
        ),
      );
}
