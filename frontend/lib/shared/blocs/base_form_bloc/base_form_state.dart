import 'package:equatable/equatable.dart';
import 'package:frontend/shared/enums/bloc_status_enum.dart';

final class BaseFormState<T> extends Equatable {
  final BlocStatusEnum status;
  final String? errorMessage;
  final T? model;

  const BaseFormState({
    this.status = BlocStatusEnum.idle,
    this.errorMessage,
    this.model,
  });

  BaseFormState<T> copyWith({
    BlocStatusEnum? status,
    String? errorMessage,
    T? model,
  }) {
    return BaseFormState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      model: model ?? this.model,
    );
  }

  @override
  String toString() => 'BaseFormState(\n'
      '  status: $status,\n'
      '  errorMessage: $errorMessage,\n'
      '  model: $model,\n'
      ');';

  @override
  List<Object?> get props => [status, errorMessage, model];
}
