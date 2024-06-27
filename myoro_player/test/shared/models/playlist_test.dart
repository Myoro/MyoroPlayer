import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/models/playlist.dart';

void main() {
  test('Playlist unit test', () {
    final playlist = Playlist.mock;

    // copyWith & props
    expect(playlist == playlist.copyWith(), isTrue);
    expect(
      playlist.copyWith(
            id: faker.randomGenerator.integer(100),
            path: faker.internet.uri('/'),
            name: faker.person.firstName(),
            image: faker.internet.uri('/'),
          ) !=
          playlist,
      isTrue,
    );

    // fromJson & toJson
    final playlistFromJson = Playlist.fromJson(const {
      Playlist.idJsonKey: 0,
      Playlist.pathJsonKey: '/Name',
      Playlist.nameJsonKey: 'Name',
      Playlist.imageJsonKey: null,
    });
    expect(
      playlistFromJson.toJson(),
      {
        Playlist.idJsonKey: 0,
        Playlist.pathJsonKey: '/Name',
        Playlist.nameJsonKey: 'Name',
        Playlist.imageJsonKey: '',
      },
    );

    // toString
    expect(
      playlist.toString(),
      'Playlist(\n'
      '  id: ${playlist.id},\n'
      '  path: ${playlist.path},\n'
      '  name: ${playlist.name},\n'
      '  image: ${playlist.image},\n'
      ');',
    );
  });
}
