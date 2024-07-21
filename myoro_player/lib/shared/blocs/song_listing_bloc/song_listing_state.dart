import 'package:equatable/equatable.dart';
import 'package:myoro_player/core/enums/bloc_status_enum.dart';
import 'package:myoro_player/core/models/playlist.dart';
import 'package:myoro_player/core/models/song.dart';

final class SongListingState extends Equatable {
  /// Standard BloC status enum
  final BlocStatusEnum status;

  /// Standard snackbar response message
  final String? snackBarMessage;

  /// Loaded playlist
  final Playlist? loadedPlaylist;

  /// Loaded songs
  final List<Song>? loadedPlaylistSongs;

  const SongListingState({
    this.status = BlocStatusEnum.idle,
    this.snackBarMessage,
    this.loadedPlaylist,
    this.loadedPlaylistSongs,
  });

  SongListingState copyWith({
    BlocStatusEnum? status,
    String? snackBarMessage,
    Playlist? loadedPlaylist,
    List<Song>? loadedPlaylistSongs,
  }) {
    return SongListingState(
      status: status ?? this.status,
      snackBarMessage: snackBarMessage,
      loadedPlaylist: loadedPlaylist ?? this.loadedPlaylist,
      loadedPlaylistSongs: loadedPlaylistSongs ?? this.loadedPlaylistSongs,
    );
  }

  @override
  String toString() => 'SongListingState(\n'
      '  status: $status,\n'
      '  snackBarMessage: $snackBarMessage,\n'
      '  loadedPlaylist: $loadedPlaylist,\n'
      '  loadedPlaylistSongs: $loadedPlaylistSongs,\n'
      ');';

  @override
  List<Object?> get props {
    return [
      status,
      snackBarMessage,
      loadedPlaylist,
      loadedPlaylistSongs,
    ];
  }
}
