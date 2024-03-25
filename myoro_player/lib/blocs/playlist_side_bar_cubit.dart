import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/database.dart';
import 'package:myoro_player/models/playlist.dart';

class PlaylistSideBarCubit extends Cubit<List<Playlist>> {
  PlaylistSideBarCubit() : super([]);

  void getPlaylists() async {
    // TODO: Might have to remove this (never widget test on windows ever again)
    if (!isClosed) return;

    final List<Map<String, Object?>> rows = await Database.select('playlists');
    emit(rows.map((json) => Playlist.fromJson(json)).toList());
  }
}
