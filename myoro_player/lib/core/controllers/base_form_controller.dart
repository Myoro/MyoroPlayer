import 'package:flutter/material.dart';
import 'package:myoro_player/core/blocs/base_form_bloc/base_form_bloc.dart';
import 'package:myoro_player/core/blocs/base_form_bloc/base_form_event.dart';
import 'package:myoro_player/core/widgets/forms/base_form.dart';

/// Used to activate a [BaseForm]'s validation/request process
final class BaseFormController<T> {
  final _formKey = GlobalKey<FormState>();
  late final BaseFormBloc<T> bloc;

  void finishForm() {
    // Triggers [BaseInput]'s [TextFormField]'s [validator]
    _formKey.currentState?.validate();

    bloc.add(const FinishFormEvent());
  }

  GlobalKey<FormState> get formKey => _formKey;
}
