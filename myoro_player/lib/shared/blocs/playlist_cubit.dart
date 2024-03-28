import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/database.dart';
import 'package:myoro_player/shared/helpers/playlist_helper.dart';
import 'package:myoro_player/shared/models/playlist.dart';

/// Controls all playlist logic in the application
///
/// i.e. Adding playlists, opening playlists, etc
class PlaylistCubit extends Cubit<List<Playlist>> {
  PlaylistCubit() : super([]);

  void getPlaylists() async {
    final List<Map<String, Object?>> rows = await Database.select('playlists');
    emit(rows.map((json) => Playlist.fromJson(json)).toList());
  }

  void createNewPlaylist() async {
    final Playlist? playlist = await PlaylistHelper.createNewPlaylist();
    if (playlist == null) return;
    _savePlaylistToDbAndEmitChanges(playlist);
  }

  void addPlaylist() async {
    final Playlist? playlist = await PlaylistHelper.addPlaylist();
    if (playlist == null) return;
    _savePlaylistToDbAndEmitChanges(playlist);
  }

  void _savePlaylistToDbAndEmitChanges(Playlist playlist) async {
    await Database.insert(
      'playlists',
      {
        'directory': playlist.directory,
        'name': playlist.name,
      },
    );
    getPlaylists();
  }
}
