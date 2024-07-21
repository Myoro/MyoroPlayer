import 'package:myoro_player/core/abstracts/crud_service.dart';
import 'package:myoro_player/core/models/playlist.dart';

abstract interface class PlaylistService implements CrudService<Playlist> {
  Future<Playlist> renamePlaylist({required Playlist playlist, required String newName});
}
