import 'package:flutter/material.dart';

class BaseHoverButton extends StatefulWidget {
  final Function onTap;
  final IconData? icon;
  final double? iconSize;
  final String? text;
  final TextStyle? textStyle;
  final bool ellipsize;
  final double? textWidth;

  BaseHoverButton({
    super.key,
    required this.onTap,
    this.icon,
    this.iconSize,
    this.text,
    this.textStyle,
    this.ellipsize = false,
    this.textWidth,
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
      builder: (context, hovered, child) => Container(
        decoration: BoxDecoration(
          color: !hovered ? Colors.transparent : theme.colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onHover: (value) => _hovered.value = value,
            onTap: () => widget.onTap(),
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
                      overflow: widget.ellipsize ? TextOverflow.ellipsis : null,
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
    );
  }
}
