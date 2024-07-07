import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/models/song.dart';

void main() {
  test('Song model unit test.', () {
    final song = Song.mock;
    final songCopy = song.copyWith();
    final songUnique = Song.fromJson(song.toJson()).copyWith(title: 'Catch me outside');

    expect(song == songCopy, isTrue);
    expect(song == songUnique, isFalse);

    expect(
      song.toJson(buildId: true),
      {
        Song.idJsonKey: song.id,
        Song.playlistIdJsonKey: song.playlistId,
        Song.pathJsonKey: song.path,
        Song.coverJsonKey: song.cover,
        Song.titleJsonKey: song.title,
        Song.artistJsonKey: song.artist,
        Song.albumJsonKey: song.album,
        Song.durationJsonKey: song.duration.inMilliseconds,
      },
    );

    expect(
      song.toString(),
      'Song(\n'
      '  id: ${song.id},\n'
      '  playlistId: ${song.playlistId},\n'
      '  path: ${song.path},\n'
      '  cover: ${song.cover},\n'
      '  title: ${song.title},\n'
      '  artist: ${song.artist},\n'
      '  album: ${song.album},\n'
      '  duration: ${song.duration},\n'
      ');',
    );
  });
}
