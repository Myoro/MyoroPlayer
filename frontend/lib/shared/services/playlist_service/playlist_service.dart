import 'package:frontend/shared/abstracts/crud_service.dart';
import 'package:frontend/shared/models/playlist.dart';

abstract interface class PlaylistService implements CrudService<Playlist> {
  Future<Playlist> renamePlaylist({required Playlist playlist, required String newName});
}
