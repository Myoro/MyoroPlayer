import 'package:equatable/equatable.dart';
import 'package:myoro_player/shared/enums/bloc_status_enum.dart';
import 'package:myoro_player/screens/main_screen/widgets/main_screen_body/main_screen_body_song_list.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/models/song.dart';

/// BloC for [MainScreenBodySongList]
final class MainScreenBodySongListState extends Equatable {
  /// Standard BloC status enum
  final BlocStatusEnum status;

  /// Standard snackbar response message
  final String? snackBarMessage;

  /// Loaded playlist
  final Playlist? loadedPlaylist;

  /// Loaded songs
  final List<Song>? loadedPlaylistSongs;

  const MainScreenBodySongListState({
    this.status = BlocStatusEnum.idle,
    this.snackBarMessage,
    this.loadedPlaylist,
    this.loadedPlaylistSongs,
  });

  MainScreenBodySongListState copyWith({
    BlocStatusEnum? status,
    String? snackBarMessage,
    Playlist? loadedPlaylist,
    List<Song>? loadedPlaylistSongs,
  }) {
    return MainScreenBodySongListState(
      status: status ?? this.status,
      snackBarMessage: snackBarMessage,
      loadedPlaylist: loadedPlaylist ?? this.loadedPlaylist,
      loadedPlaylistSongs: loadedPlaylistSongs ?? this.loadedPlaylistSongs,
    );
  }

  @override
  String toString() => 'MainScreenBodySongListState(\n'
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
