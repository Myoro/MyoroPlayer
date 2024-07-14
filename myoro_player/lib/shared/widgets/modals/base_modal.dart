import 'package:flutter/material.dart';
import 'package:myoro_player/shared/controllers/base_form_controller.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/decoration_design_system.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/shared/widgets/forms/base_form.dart';

/// Modal used to create all modals. ALL MODALS MUST BE FORMS
///
/// Any modal must implement [BaseModal]'s [show] function like so:
/// ``` dart
/// final class FooModal extends StatelessWidget {
///   /// Always a private constructor forcing the use of the [show] function
///   const FooModal._();
///
///   static void show(BuildContext context) {
///     BaseModal.show(
///       context,
///       child: FooModal._(),
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
final class BaseModal<T> extends StatefulWidget {
  /// If the modal is not a simple (i.e. dialog) form
  final BaseFormValidationCallback? validationCallback;
  final BaseFormRequestCallback<T>? requestCallback;
  final BaseFormOnSuccessCallback<T>? onSuccessCallback;
  final BaseFormOnErrorCallback? onErrorCallback;

  /// Title of the modal
  final String? title;

  /// Contents of the modal
  final Widget child;

  const BaseModal._({
    required this.validationCallback,
    required this.requestCallback,
    required this.onSuccessCallback,
    required this.onErrorCallback,
    required this.title,
    required this.child,
  });

  static void show<T>(
    BuildContext context, {
    BaseFormValidationCallback? validationCallback,
    BaseFormRequestCallback<T>? requestCallback,
    BaseFormOnSuccessCallback<T>? onSuccessCallback,
    BaseFormOnErrorCallback? onErrorCallback,
    String? title,
    required Widget child,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BaseModal<T>._(
          validationCallback: validationCallback,
          requestCallback: requestCallback,
          onSuccessCallback: onSuccessCallback,
          onErrorCallback: onErrorCallback,
          title: title,
          child: child,
        );
      },
    );
  }

  @override
  State<BaseModal<T>> createState() => _BaseModalState<T>();
}

class _BaseModalState<T> extends State<BaseModal<T>> {
  BaseFormValidationCallback? get _validationCallback => widget.validationCallback;
  BaseFormRequestCallback<T>? get _requestCallback => widget.requestCallback;
  BaseFormOnSuccessCallback<T>? get _onSuccessCallback => widget.onSuccessCallback;
  BaseFormOnErrorCallback? get _onErrorCallback => widget.onErrorCallback;
  String? get _title => widget.title;
  Widget get _child => widget.child;

  final _formController = BaseFormController<T>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          // Needed to, for example, allow [IconTextHoverButton] to be within this modal
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorDesignSystem.background(context),
                borderRadius: DecorationDesignSystem.borderRadius,
                border: Border.all(
                  width: 2,
                  color: ColorDesignSystem.onBackground(context),
                ),
              ),
              constraints: BoxConstraints(
                maxWidth: 350,
                maxHeight: constraints.maxHeight - 100,
              ),
              child: BaseForm<T>(
                controller: _formController,
                validationCallback: _validationCallback,
                requestCallback: _requestCallback ?? () => null,
                onSuccessCallback: (T? model) {
                  _onSuccessCallback?.call(model);
                  Navigator.of(context).pop();
                },
                onErrorCallback: (error) => _onErrorCallback?.call(error),
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title & close button
                      Row(
                        children: [
                          if (_title != null)
                            Expanded(
                              child: Text(
                                _title!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          const SizedBox(width: 20),
                          IconTextHoverButton(
                            icon: Icons.close,
                            iconSize: ImageSizeEnum.small.size - 10,
                            onTap: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Content of the modal
                      _child,
                      // Form yes/no buttons
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: IconTextHoverButton(
                              text: 'Confirm',
                              textAlign: TextAlign.center,
                              bordered: true,
                              onTap: () => _formController.finishForm(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: IconTextHoverButton(
                              text: 'Cancel',
                              textAlign: TextAlign.center,
                              bordered: true,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
