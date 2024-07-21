import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/blocs/base_form_bloc/base_form_bloc.dart';
import 'package:myoro_player/core/blocs/base_form_bloc/base_form_event.dart';
import 'package:myoro_player/core/blocs/base_form_bloc/base_form_state.dart';
import 'package:myoro_player/core/enums/bloc_status_enum.dart';

void main() {
  const errorMessage = 'Error';

  test('BaseFormBloc.FinishFormEvent validation error case.', () {
    final bloc = BaseFormBloc<String>(
      validationCallback: () => errorMessage,
      requestCallback: () => null,
    );

    expectLater(
      bloc.stream,
      emitsInOrder([
        // Double [copyWith] is for line coverage
        const BaseFormState<String>().copyWith().copyWith(
              status: BlocStatusEnum.loading,
            ),
        const BaseFormState<String>(
          status: BlocStatusEnum.error,
          errorMessage: errorMessage,
        ),
      ]),
    );

    bloc.add(const FinishFormEvent());
  });

  test('BaseFormBloc.FinishFormEvent request exception error case.', () {
    final bloc = BaseFormBloc<String>(
      validationCallback: () => null,
      requestCallback: () => throw Exception(errorMessage),
    );

    expectLater(
      bloc.stream,
      emitsInOrder([
        const BaseFormState<String>(
          status: BlocStatusEnum.loading,
        ),
        const BaseFormState<String>(
          status: BlocStatusEnum.error,
          errorMessage: 'Error executing request: "Exception: $errorMessage".',
        ),
      ]),
    );

    bloc.add(const FinishFormEvent());
  });

  test('BaseFormBloc.FinishFormEvent success case.', () {
    const response = 'Response';

    final bloc = BaseFormBloc<String>(
      validationCallback: () => null,
      requestCallback: () async => response,
    );

    expectLater(
      bloc.stream,
      emitsInOrder([
        const BaseFormState<String>(
          status: BlocStatusEnum.loading,
        ),
        const BaseFormState<String>(
          status: BlocStatusEnum.completed,
          model: response,
        ),
      ]),
    );

    bloc.add(const FinishFormEvent());
  });
}
