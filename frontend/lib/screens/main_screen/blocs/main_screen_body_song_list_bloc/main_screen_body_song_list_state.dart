import 'package:equatable/equatable.dart';
import 'package:frontend/shared/enums/bloc_status_enum.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen_body/main_screen_body_song_list.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/models/song.dart';

/// BloC for [MainScreenBodySongList]
final class MainScreenBodySongListState extends Equatable {
  /// Standard BloC status enum
  final BlocStatusEnum status;

  /// Loaded playlist
  final Playlist? loadedPlaylist;

  /// Loaded songs
  final List<Song>? loadedPlaylistSongs;

  const MainScreenBodySongListState({
    this.status = BlocStatusEnum.idle,
    this.loadedPlaylist,
    this.loadedPlaylistSongs,
  });

  MainScreenBodySongListState copyWith({
    BlocStatusEnum? status,
    Playlist? loadedPlaylist,
    List<Song>? loadedPlaylistSongs,
  }) {
    return MainScreenBodySongListState(
      status: status ?? this.status,
      loadedPlaylist: loadedPlaylist ?? this.loadedPlaylist,
      loadedPlaylistSongs: loadedPlaylistSongs ?? this.loadedPlaylistSongs,
    );
  }

  @override
  String toString() => 'MainScreenBodySongListState(\n'
      '  status: $status,\n'
      '  loadedPlaylist: $loadedPlaylist,\n'
      '  loadedPlaylistSongs: $loadedPlaylistSongs,\n'
      ');';

  @override
  List<Object?> get props {
    return [
      status,
      loadedPlaylist,
      loadedPlaylistSongs,
    ];
  }
}
