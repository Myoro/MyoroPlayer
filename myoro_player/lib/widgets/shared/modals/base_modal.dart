import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/shared/buttons/base_hover_button.dart';
import 'package:myoro_player/widgets/shared/modals/login_signup_modal.dart';

/// [Widget] that all modals will derive from
///
/// Always use [showDialog] witin the modal's file to avoid filler code elsewhere, see [LoginSignupModal]
class BaseModal extends StatelessWidget {
  final Size size;
  final String? title;
  final bool showFooterButtons;
  final String? yesText;
  final Function? yesOnTap;
  final Widget content;

  BaseModal({
    super.key,
    required this.size,
    required this.content,
    this.title,
    this.showFooterButtons = false,
    this.yesText,
    this.yesOnTap,
  }) {
    assert(showFooterButtons && yesOnTap != null);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Center(
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Material(
            // Allows custom widgets to work
            child: Column(
              children: [
                Row(
                  children: [
                    if (title != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          title!,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    const Spacer(),
                    BaseHoverButton(
                      icon: Icons.close,
                      iconSize: 25,
                      padding: const EdgeInsets.all(3),
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
                content,
                const SizedBox(height: 20),
                if (showFooterButtons) ...[
                  Row(
                    children: [
                      Expanded(
                        child: BaseHoverButton(
                          text: yesText ?? 'Confirm',
                          onTap: () => yesOnTap!(),
                          bordered: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: BaseHoverButton(
                          text: 'Cancel',
                          onTap: () => Navigator.pop(context),
                          bordered: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
