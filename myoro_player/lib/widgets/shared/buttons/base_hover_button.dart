import 'package:flutter/material.dart';

class BaseHoverButton extends StatefulWidget {
  final Function? onTap;
  final IconData? icon;
  final double? iconSize;
  final String? text;
  final TextStyle? textStyle;
  final bool ellipsize;
  final double? textWidth;
  final EdgeInsets padding;

  BaseHoverButton({
    super.key,
    this.onTap,
    this.icon,
    this.iconSize,
    this.text,
    this.textStyle,
    this.ellipsize = false,
    this.textWidth,
    this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  }) {
    assert((icon != null && iconSize != null) || text != null);

    if (ellipsize) assert(textWidth != null);
  }

  @override
  State<BaseHoverButton> createState() => _BaseHoverButtonState();
}

class _BaseHoverButtonState extends State<BaseHoverButton> {
  final ValueNotifier<bool> _hovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: _hovered,
      builder: (context, hovered, child) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (value) => _hovered.value = true,
        onExit: (value) => _hovered.value = false,
        child: Container(
          decoration: BoxDecoration(
            color: !hovered ? Colors.transparent : theme.colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: GestureDetector(
            onTap: widget.onTap != null ? widget.onTap!() : null,
            child: Padding(
              padding: widget.padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null)
                    Icon(
                      widget.icon,
                      size: widget.iconSize,
                      color: !hovered
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.primary,
                    ),
                  if (widget.icon != null && widget.text != null)
                    const SizedBox(width: 5),
                  if (widget.text != null)
                    SizedBox(
                      width: widget.textWidth,
                      child: Text(
                        widget.text!,
                        textAlign: TextAlign.center,
                        maxLines: widget.ellipsize ? 1 : null,
                        overflow:
                            widget.ellipsize ? TextOverflow.ellipsis : null,
                        style: (widget.textStyle ?? theme.textTheme.bodyMedium)!
                            .copyWith(
                          color: !hovered
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
