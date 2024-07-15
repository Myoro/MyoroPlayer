import 'package:myoro_player/shared/database.dart';
import 'package:myoro_player/shared/models/conditions.dart';
import 'package:myoro_player/shared/models/song.dart';
import 'package:myoro_player/shared/services/song_service/song_service.dart';

final class SongServiceApi implements SongService {
  final Database database;

  const SongServiceApi(this.database);

  @override
  Future<Song?> create({required Map<String, dynamic> data}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<List<Song>> select({Conditions? conditions}) async {
    final rows = await database.select(Database.songsTableName, conditions: conditions);
    return rows.map<Song>((row) => Song.fromJson(row)).toList();
  }

  @override
  Future<Song?> get({Conditions? conditions}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Song?> update({int? id, Map<String, dynamic>? data}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> delete({required int id}) async {
    await database.delete(Database.songsTableName, id: id);
  }
}
