import 'package:flutter/material.dart';

class IconButtonWithoutFeedback extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final double size;

  const IconButtonWithoutFeedback({
    super.key,
    required this.onTap,
    required this.icon,
    required this.size,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => onTap(),
        child: Icon(
          icon,
          size: size,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      );
}
