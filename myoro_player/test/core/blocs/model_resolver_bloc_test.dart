import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/blocs/model_resolver_bloc/model_resolver_bloc.dart';
import 'package:myoro_player/core/blocs/model_resolver_bloc/model_resolver_event.dart';
import 'package:myoro_player/core/blocs/model_resolver_bloc/model_resolver_state.dart';
import 'package:myoro_player/core/enums/bloc_status_enum.dart';

void main() {
  test('ModelResolverBloc.ExecuteRequestEvent error case', () {
    final bloc = ModelResolverBloc<String>();

    expectLater(
      bloc.stream,
      emitsInOrder([
        // Redundant [copyWith] is for line coverage
        const ModelResolverState<String>().copyWith().copyWith(
              status: BlocStatusEnum.loading,
            ),
        const ModelResolverState<String>(
          status: BlocStatusEnum.error,
          snackBarMessage: '[ModelResolverBloc.ExecuteRequestEvent]: Error executing [request] provided.',
        ),
      ]),
    );

    bloc.add(ExecuteRequestEvent(() async => throw Exception()));
  });

  test('ModelResolverBloc.ExecuteRequestEvent passing case', () {
    final bloc = ModelResolverBloc<String>();

    expectLater(
      bloc.stream,
      emitsInOrder([
        const ModelResolverState<String>(
          status: BlocStatusEnum.loading,
        ),
        const ModelResolverState<String>(
          model: 'Response',
          status: BlocStatusEnum.completed,
        ),
      ]),
    );

    bloc.add(ExecuteRequestEvent(() async => 'Response'));
  });
}
