import 'dart:io';

import 'package:myoro_player/shared/database.dart';
import 'package:myoro_player/shared/models/conditions.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';

final class PlaylistServiceApi implements PlaylistService {
  final Database database;

  const PlaylistServiceApi(this.database);

  @override
  Future<Playlist?> create({required Map<String, dynamic> data}) async {
    /// Validating if the playlist already exists
    final Map<String, dynamic>? playlistAlreadyExists = await database.get(
      Database.playlistsTableName,
      conditions: Conditions(data),
    );

    if (playlistAlreadyExists != null) return null;

    final int id = (await database.insert(
      Database.playlistsTableName,
      data: data,
    ))!;

    final Map<String, dynamic> newRow = (await database.get(
      Database.playlistsTableName,
      conditions: Conditions({
        Playlist.idJsonKey: id,
      }),
    ))!;

    return Playlist.fromJson(newRow);
  }

  @override
  Future<List<Playlist>> select({Map<String, dynamic>? conditions}) async {
    final rows = await database.select(Database.playlistsTableName);
    final List<Playlist> playlists = rows.map<Playlist>((row) => Playlist.fromJson(row)).toList();
    final List<Playlist> existentPlaylists = [];

    // Validating that all of the playlists still exists on the device
    for (final playlist in playlists) {
      if (!File(playlist.path).existsSync()) {
        await database.delete(Database.playlistsTableName, id: playlist.id!);
      } else {
        existentPlaylists.add(playlist);
      }
    }

    return existentPlaylists;
  }

  @override
  Future<Playlist> get({int? id}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Playlist> update({int? id, Map<String, dynamic>? data}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> delete({required int id}) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
