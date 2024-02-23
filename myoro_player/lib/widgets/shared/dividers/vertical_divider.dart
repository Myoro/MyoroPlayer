import 'package:flutter/material.dart';

class VerticalDivider extends StatelessWidget {
  final bool resizeButton;

  const VerticalDivider({ super.key, this.resizeButton = false });

  @override
  Widget build(BuildContext context) => !resizeButton
    ? _widget(context)
    : GestureDetector(
      onPanUpdate: (details) => print(details),
      child: _widget(context),
    );

  Widget _widget(BuildContext context) => Container(
    width: 0.5,
    height: double.infinity,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}