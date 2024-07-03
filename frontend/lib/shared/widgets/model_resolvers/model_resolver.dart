import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/shared/controllers/model_resolver_controller.dart';
import 'package:frontend/shared/blocs/model_resolver_bloc/model_resolver_bloc.dart';
import 'package:frontend/shared/blocs/model_resolver_bloc/model_resolver_event.dart';
import 'package:frontend/shared/blocs/model_resolver_bloc/model_resolver_state.dart';
import 'package:frontend/shared/enums/bloc_status_enum.dart';
import 'package:frontend/shared/helpers/snack_bar_helper.dart';
import 'package:frontend/shared/widgets/loading/loading_circle.dart';

typedef ModelResolverRequest<T> = Future<T> Function();
typedef ModelResolverBuilder<T> = Function(BuildContext context, T? model);

final class ModelResolver<T> extends StatefulWidget {
  /// To dynamically refresh the [ModelResolver]
  final ModelResolverController<T>? controller;

  /// Request that [ModelResolver] will make to get the data
  final ModelResolverRequest<T> request;

  /// [Widget] builder of [ModelResolver]
  final ModelResolverBuilder<T> builder;

  const ModelResolver({
    super.key,
    this.controller,
    required this.request,
    required this.builder,
  });

  @override
  State<ModelResolver<T>> createState() => _ModelResolverState<T>();
}

class _ModelResolverState<T> extends State<ModelResolver<T>> {
  ModelResolverController<T>? get _controller => widget.controller;
  ModelResolverRequest<T> get _request => widget.request;
  ModelResolverBuilder<T> get _builder => widget.builder;

  final _bloc = ModelResolverBloc<T>();

  @override
  void initState() {
    super.initState();
    if (_controller == null) return;
    _controller!.bloc = _bloc;
    _controller!.request = _request;
  }

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

    SnackBarHelper.showErrorSnackBar(
      context,
      state.snackBarMessage!,
    );
  }
}
