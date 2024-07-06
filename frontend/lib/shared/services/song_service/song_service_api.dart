import 'package:frontend/shared/database.dart';
import 'package:frontend/shared/models/conditions.dart';
import 'package:frontend/shared/models/song.dart';
import 'package:frontend/shared/services/song_service/song_service.dart';

final class SongServiceApi implements SongService {
  final Database database;

  const SongServiceApi(this.database);

  @override
  Future<Song?> create({required Map<String, dynamic> data}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<List<Song>> select({Conditions? conditions}) {
    // TODO: implement select
    throw UnimplementedError();
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
  Future<void> delete({required int id}) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}
