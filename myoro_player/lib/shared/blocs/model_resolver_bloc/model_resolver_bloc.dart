import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/model_resolver_bloc/model_resolver_event.dart';
import 'package:myoro_player/shared/blocs/model_resolver_bloc/model_resolver_state.dart';
import 'package:myoro_player/shared/enums/bloc_status_enum.dart';

final class ModelResolverBloc<T> extends Bloc<ModelResolverEvent, ModelResolverState<T>> {
  ModelResolverBloc() : super(ModelResolverState<T>()) {
    on<ExecuteRequestEvent>((event, emit) async {
      try {
        final T? model = await event.request.call();

        emit(
          state.copyWith(
            model: model,
            status: BlocStatusEnum.completed,
          ),
        );
      } catch (error) {
        if (kDebugMode) {
          print('[ModelResolverBloc.ExecuteRequestEvent]: Error executing [request] provided.');
        }

        emit(
          state.copyWith(
            status: BlocStatusEnum.error,
            snackBarMessage: '[ModelResolverBloc.ExecuteRequestEvent]: Error executing [request] provided.',
          ),
        );
      }
    });
  }
}
