import 'package:equatable/equatable.dart';
import 'package:myoro_player/shared/enums/bloc_status_enum.dart';

final class MainScreenBodyPlaylistSideBarState extends Equatable {
  final BlocStatusEnum status;
  final String? snackBarMessage;

  const MainScreenBodyPlaylistSideBarState({
    this.status = BlocStatusEnum.idle,
    this.snackBarMessage,
  });

  MainScreenBodyPlaylistSideBarState copyWith({
    BlocStatusEnum? status,
    String? snackBarMessage,
  }) {
    return MainScreenBodyPlaylistSideBarState(
      status: status ?? this.status,
      snackBarMessage: snackBarMessage ?? this.snackBarMessage,
    );
  }

  @override
  String toString() => 'MainScreenBodyPlaylistSideBarState(\n'
      '  status: $status,\n'
      '  snackBarMessage: $snackBarMessage,\n'
      ');';

  @override
  List<Object?> get props => [status, snackBarMessage];
}
