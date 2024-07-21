import 'package:flutter/material.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/extensions/build_context_extension.dart';
import 'package:myoro_player/core/models/menu_item.dart';
import 'package:myoro_player/core/widgets/dividers/basic_divider.dart';
import 'package:myoro_player/core/widgets/modals/base_modal.dart';

/// Modal used for dropdown menu modals on mobile
///
/// Differing from [BaseModal], this spawns at the bottom of the screen
/// and should be treated like a context menu, thus is not a form at all
///
/// Any modal must implement [BaseDropdownModal]'s [show] function like so:
/// ``` dart
/// final class FooModal {
///   /// Always a private constructor forcing the use of the [show] function
///   const FooModal._();
///
///   static void show(BuildContext context) {
///     BaseDropdownModal.show(
///       context,
///       options: [...], /// Your menu options here
///     );
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     /// Content of the modal
///     return ...;
///   }
/// }
/// ```
final class BaseDropdownModal extends StatelessWidget {
  final List<MenuItem> items;

  const BaseDropdownModal._(this.items);

  static void show(BuildContext context, List<MenuItem> items) {
    showDialog(
      context: context,
      builder: (context) => BaseDropdownModal._(items),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const BasicDivider(direction: Axis.horizontal),
          Container(
            height: 200,
            color: ColorDesignSystem.background(context),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: items.map<Widget>(
                  (item) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            size: ImageSizeEnum.small.size,
                            color: ColorDesignSystem.onBackground(context),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item.text,
                              style: context.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
