import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/shared/buttons/base_hover_button.dart';

/// Not an autocomplete, a classic dropdown triggered by a static button
class BaseDropdown extends StatelessWidget {
  final List<String> items;
  final Widget child;

  const BaseDropdown({
    super.key,
    required this.items,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return PopupMenuButton(
      tooltip: '',
      offset: const Offset(0, 45),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: theme.colorScheme.onPrimary,
          width: 2,
        ),
      ),
      child: ClipRRect(child: child),
      itemBuilder: (context) => items
          .map((item) => PopupMenuItem(
                child: BaseHoverButton(text: item),
              ))
          .toList(),
    );
  }
}
