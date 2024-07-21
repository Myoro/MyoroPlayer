import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/core/blocs/base_form_bloc/base_form_event.dart';
import 'package:myoro_player/core/blocs/base_form_bloc/base_form_state.dart';
import 'package:myoro_player/core/enums/bloc_status_enum.dart';
import 'package:myoro_player/core/widgets/forms/base_form.dart';

final class BaseFormBloc<T> extends Bloc<BaseFormEvent, BaseFormState> {
  BaseFormBloc({
    BaseFormValidationCallback? validationCallback,
    required BaseFormRequestCallback<T> requestCallback,
  }) : super(BaseFormState<T>()) {
    on<FinishFormEvent>((event, emit) async {
      emit(state.copyWith(status: BlocStatusEnum.loading));

      final String? validationResult = validationCallback?.call();

      if (validationResult != null) {
        emit(
          state.copyWith(
            status: BlocStatusEnum.error,
            errorMessage: validationResult,
          ),
        );

        return;
      }

      try {
        final T? model = await requestCallback.call();

        emit(
          state.copyWith(
            status: BlocStatusEnum.completed,
            model: model,
          ),
        );
      } catch (error, stackTrace) {
        if (kDebugMode) {
          print('[BaseFormBloc.FinishFormEvent]: Error executing [requestCallback]: "$error".');
          print('Stack trace:\n$stackTrace');
        }

        emit(
          state.copyWith(
            status: BlocStatusEnum.error,
            errorMessage: 'Error executing request: "$error".',
          ),
        );
      }
    });
  }
}
