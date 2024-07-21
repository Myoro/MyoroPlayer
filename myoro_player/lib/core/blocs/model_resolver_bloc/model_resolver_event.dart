import 'package:flutter/material.dart';
import 'package:myoro_player/core/widgets/model_resolvers/model_resolver.dart';

@immutable
abstract class ModelResolverEvent {
  const ModelResolverEvent();
}

/// Execute [ModelResolver]'s [request] to get the model
final class ExecuteRequestEvent extends ModelResolverEvent {
  final ModelResolverRequest request;

  const ExecuteRequestEvent(this.request);
}
