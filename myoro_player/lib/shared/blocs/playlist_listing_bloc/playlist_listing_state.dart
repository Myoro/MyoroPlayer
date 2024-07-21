import 'package:equatable/equatable.dart';
import 'package:myoro_player/core/enums/bloc_status_enum.dart';

final class PlaylistListingState extends Equatable {
  final BlocStatusEnum status;
  final String? snackBarMessage;

  const PlaylistListingState({
    this.status = BlocStatusEnum.idle,
    this.snackBarMessage,
  });

  PlaylistListingState copyWith({
    BlocStatusEnum? status,
    String? snackBarMessage,
  }) {
    return PlaylistListingState(
      status: status ?? this.status,
      snackBarMessage: snackBarMessage ?? this.snackBarMessage,
    );
  }

  @override
  String toString() => 'PlaylistListingState(\n'
      '  status: $status,\n'
      '  snackBarMessage: $snackBarMessage,\n'
      ');';

  @override
  List<Object?> get props => [status, snackBarMessage];
}
