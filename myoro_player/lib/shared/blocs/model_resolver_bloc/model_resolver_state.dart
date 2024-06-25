import 'package:equatable/equatable.dart';
import 'package:myoro_player/shared/enums/bloc_status_enum.dart';
import 'package:myoro_player/shared/widgets/model_resolvers/model_resolver.dart';

final class ModelResolverState<T> extends Equatable {
  /// What [ModelResolver]'s [request] gave back
  final T? model;

  /// Standard BloC status enum as we're messing with requests
  final BlocStatusEnum status;

  /// Snack bar messages if the developer ever needs it
  final String? snackBarMessage;

  const ModelResolverState({
    this.model,
    this.status = BlocStatusEnum.idle,
    this.snackBarMessage,
  });

  ModelResolverState<T> copyWith({
    T? model,
    BlocStatusEnum? status,
    String? snackBarMessage,
  }) {
    return ModelResolverState<T>(
      model: model ?? this.model,
      status: status ?? this.status,
      snackBarMessage: snackBarMessage ?? this.snackBarMessage,
    );
  }

  @override
  String toString() => 'ModelResolverState<T>(\n'
      '  model: $model,\n'
      '  status: $status,\n'
      '  snackBarMessage: $snackBarMessage,\n'
      ');';

  @override
  List<Object?> get props => [model, status, snackBarMessage];
}
