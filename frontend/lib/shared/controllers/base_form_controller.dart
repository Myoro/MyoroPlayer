import 'package:frontend/shared/blocs/base_form_bloc/base_form_bloc.dart';
import 'package:frontend/shared/blocs/base_form_bloc/base_form_event.dart';
import 'package:frontend/shared/widgets/forms/base_form.dart';

/// Used to activate a [BaseForm]'s validation/request process
final class BaseFormController<T> {
  late final BaseFormBloc<T> bloc;

  void finishForm() => bloc.add(const FinishFormEvent());
}
