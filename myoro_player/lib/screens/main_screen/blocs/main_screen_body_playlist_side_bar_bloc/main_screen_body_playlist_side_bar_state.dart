import 'package:equatable/equatable.dart';
import 'package:myoro_player/shared/enums/bloc_status_enum.dart';

final class MainScreenBodyPlaylistSideBarState extends Equatable {
  final BlocStatusEnum status;
  final String? errorMessage;

  const MainScreenBodyPlaylistSideBarState({
    this.status = BlocStatusEnum.idle,
    this.errorMessage,
  });

  MainScreenBodyPlaylistSideBarState copyWith({
    BlocStatusEnum? status,
    String? errorMessage,
  }) {
    return MainScreenBodyPlaylistSideBarState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() => 'MainScreenBodyPlaylistSideBarState(\n'
      '  status: $status,\n'
      '  errorMessage: $errorMessage,\n'
      ');';

  @override
  List<Object?> get props => [status, errorMessage];
}
