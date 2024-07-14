import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/base_form_bloc/base_form_bloc.dart';
import 'package:myoro_player/shared/blocs/base_form_bloc/base_form_state.dart';
import 'package:myoro_player/shared/controllers/base_form_controller.dart';
import 'package:myoro_player/shared/enums/bloc_status_enum.dart';

typedef BaseFormValidationCallback = String? Function();
typedef BaseFormRequestCallback<T> = FutureOr<T>? Function();
typedef BaseFormOnSuccessCallback<T> = void Function(T? model);
typedef BaseFormOnErrorCallback = void Function(String error);
typedef BaseFormBuilder = Widget Function(BuildContext context);

/// This widget must be used in EVERY form in MyoroPlayer
final class BaseForm<T> extends StatefulWidget {
  final BaseFormController<T> controller;
  final BaseFormValidationCallback? validationCallback;
  final BaseFormRequestCallback<T> requestCallback;
  final BaseFormOnSuccessCallback<T> onSuccessCallback;
  final BaseFormOnErrorCallback? onErrorCallback;
  final BaseFormBuilder builder;

  const BaseForm({
    super.key,
    required this.controller,
    this.validationCallback,
    required this.requestCallback,
    required this.onSuccessCallback,
    this.onErrorCallback,
    required this.builder,
  });

  @override
  State<BaseForm<T>> createState() => _BaseFormState<T>();
}

class _BaseFormState<T> extends State<BaseForm<T>> {
  BaseFormController<T> get _controller => widget.controller;
  BaseFormValidationCallback? get _validationCallback => widget.validationCallback;
  BaseFormRequestCallback<T> get _requestCallback => widget.requestCallback;
  BaseFormOnSuccessCallback<T> get _onSuccessCallback => widget.onSuccessCallback;
  BaseFormOnErrorCallback? get _onErrorCallback => widget.onErrorCallback;
  BaseFormBuilder get _builder => widget.builder;

  late final BaseFormBloc<T> _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BaseFormBloc<T>(
      validationCallback: _validationCallback,
      requestCallback: _requestCallback,
    );
    _controller.bloc = _bloc;
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<BaseFormBloc<T>, BaseFormState>(
        listener: (context, state) {
          if (state.status == BlocStatusEnum.completed) {
            _onSuccessCallback.call(state.model);
          } else if (state.status == BlocStatusEnum.error) {
            _onErrorCallback?.call(state.errorMessage!);
          }
        },
        child: Form(
          key: _controller.formKey,
          child: _builder.call(context),
        ),
      ),
    );
  }
}
