import 'package:myoro_player/shared/blocs/model_resolver_bloc/model_resolver_bloc.dart';
import 'package:myoro_player/shared/blocs/model_resolver_bloc/model_resolver_event.dart';
import 'package:myoro_player/shared/widgets/model_resolvers/model_resolver.dart';

/// In order to dynamically refresh a [ModelResolver] when needed
final class ModelResolverController<T> {
  late final ModelResolverBloc<T> bloc;
  late final ModelResolverRequest<T> request;

  void refresh() => bloc.add(ExecuteRequestEvent(request));
}
