import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:frontend/shared/blocs/model_resolver_bloc/model_resolver_bloc.dart';
import 'package:frontend/shared/blocs/model_resolver_bloc/model_resolver_event.dart';
import 'package:frontend/shared/blocs/model_resolver_bloc/model_resolver_state.dart';
import 'package:frontend/shared/enums/bloc_status_enum.dart';
import 'package:frontend/shared/helpers/snack_bar_helper.dart';
import 'package:frontend/shared/widgets/loading/loading_circle.dart';

typedef ModelResolverRequest<T> = Future<T> Function();
typedef ModelResolverBuilder<T> = Function(BuildContext context, T? model);

final class ModelResolver<T> extends StatefulWidget {
  final ModelResolverRequest<T> request;
  final ModelResolverBuilder<T> builder;

  const ModelResolver({
    super.key,
    required this.request,
    required this.builder,
  });

  @override
  State<ModelResolver<T>> createState() => _ModelResolverState<T>();
}

class _ModelResolverState<T> extends State<ModelResolver<T>> {
  ModelResolverRequest<T> get _request => widget.request;
  ModelResolverBuilder<T> get _builder => widget.builder;

  final _bloc = ModelResolverBloc<T>();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc..add(ExecuteRequestEvent(_request)),
      child: BlocConsumer<ModelResolverBloc<T>, ModelResolverState<T>>(
        listener: (context, state) => _handleSnackBars(context, state),
        builder: (context, state) {
          if (state.status != BlocStatusEnum.completed) {
            return const Center(child: LoadingCircle());
          } else {
            return _builder.call(context, state.model);
          }
        },
      ),
    );
  }

  void _handleSnackBars(BuildContext context, ModelResolverState<T> state) {
    if (state.status != BlocStatusEnum.error) return;

    KiwiContainer().resolve<SnackBarHelper>().showErrorSnackBar(
          context,
          state.snackBarMessage!,
        );
  }
}
