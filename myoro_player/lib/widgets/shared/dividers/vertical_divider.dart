import 'package:flutter/material.dart';

class BaseVerticalDivider extends StatelessWidget {
  final bool isResizeButton;
  final Function(double)? onHorizontalDragUpdate;

  const BaseVerticalDivider({
    super.key,
    this.isResizeButton = false,
    this.onHorizontalDragUpdate,
  });

  @override
  Widget build(BuildContext context) {
    assert(isResizeButton && onHorizontalDragUpdate != null);

    return !isResizeButton
        ? _widget(context)
        : MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) =>
                  onHorizontalDragUpdate!(details.delta.dx), // TODO
              child: _widget(context),
            ),
          );
  }

  Widget _widget(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          color: Colors.transparent,
          width: 10.5,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      );
}
