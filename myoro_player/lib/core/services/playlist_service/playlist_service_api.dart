import 'dart:io';

import 'package:myoro_player/core/database.dart';
import 'package:myoro_player/core/extensions/string_extension.dart';
import 'package:myoro_player/core/helpers/file_system_helper.dart';
import 'package:myoro_player/core/models/conditions.dart';
import 'package:myoro_player/core/models/playlist.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service.dart';
import 'package:kiwi/kiwi.dart';

final class PlaylistServiceApi implements PlaylistService {
  final Database database;
  final _fileSystemHelper = KiwiContainer().resolve<FileSystemHelper>();

  PlaylistServiceApi(this.database);

  @override
  Future<Playlist?> create({required Map<String, dynamic> data}) async {
    /// Validating if the playlist already exists
    final Map<String, dynamic>? playlistAlreadyExists = await database.get(
      Database.playlistsTableName,
      conditions: Conditions({Playlist.pathJsonKey: data[Playlist.pathJsonKey]}),
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
  Future<List<Playlist>> select({Conditions? conditions}) async {
    final rows = await database.select(Database.playlistsTableName);
    final List<Playlist> playlists = rows.map<Playlist>((row) => Playlist.fromJson(row)).toList();
    final List<Playlist> existentPlaylists = [];

    // Validating that all of the playlists still exists on the device (and if the image exists on the device)
    for (var playlist in playlists) {
      if (!playlist.path.folderExists) {
        await database.delete(Database.playlistsTableName, id: playlist.id!);
      } else {
        if (playlist.image != null && !File(playlist.image!).existsSync()) {
          await update(
            id: playlist.id,
            data: {Playlist.imageJsonKey: null},
          );

          playlist = (await get(conditions: Conditions({Playlist.idJsonKey: playlist.id})))!;
        }

        existentPlaylists.add(playlist);
      }
    }

    return existentPlaylists;
  }

  @override
  Future<Playlist?> get({Conditions? conditions}) async {
    final Map<String, dynamic>? row = await database.get(
      Database.playlistsTableName,
      conditions: conditions,
    );
    if (row == null) return null;
    return Playlist.fromJson(row);
  }

  @override
  Future<Playlist> update({int? id, Map<String, dynamic>? data}) async {
    assert(id != null && data != null);

    final conditions = Conditions({Playlist.idJsonKey: id});

    await database.update(
      Database.playlistsTableName,
      data: data!,
      conditions: conditions,
    );

    return Playlist.fromJson(
      (await database.get(
        Database.playlistsTableName,
        conditions: conditions,
      ))!,
    );
  }

  @override
  Future<void> delete({required int id}) async {
    await database.delete(Database.playlistsTableName, id: id);
  }

  @override
  Future<Playlist> renamePlaylist({required Playlist playlist, required String newName}) async {
    final newPath = _fileSystemHelper.renameFolder(playlist.path, newName);

    await database.update(
      Database.playlistsTableName,
      data: {
        Playlist.nameJsonKey: newName,
        Playlist.pathJsonKey: newPath,
      },
      conditions: Conditions({
        Playlist.idJsonKey: playlist.id,
      }),
    );

    final row = await database.get(
      Database.playlistsTableName,
      conditions: Conditions({Playlist.idJsonKey: playlist.id}),
    );

    return Playlist.fromJson(row!);
  }
}
