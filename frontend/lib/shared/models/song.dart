import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';

final class Song extends Equatable {
  static const idJsonKey = 'id';
  static const playlistIdJsonKey = 'playlist_id';
  static const pathJsonKey = 'path';
  static const coverJsonKey = 'cover';
  static const nameJsonKey = 'name';
  static const artistJsonKey = 'artist';
  static const albumJsonKey = 'album';
  static const durationJsonKey = 'duration';

  final int id;
  final int playlistId;
  final String path;
  final Uint8List? cover;
  final String name;
  final String? artist;
  final String? album;
  final Duration duration;

  const Song({
    required this.id,
    required this.playlistId,
    required this.path,
    this.cover,
    required this.name,
    this.artist,
    this.album,
    required this.duration,
  });

  Song copyWith({
    int? id,
    int? playlistId,
    String? path,
    Uint8List? cover,
    String? name,
    String? artist,
    String? album,
    Duration? duration,
  }) {
    return Song(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      path: path ?? this.path,
      cover: cover ?? this.cover,
      name: name ?? this.name,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      duration: duration ?? this.duration,
    );
  }

  Song.fake()
      : id = faker.randomGenerator.integer(100),
        playlistId = faker.randomGenerator.integer(100),
        path = faker.internet.uri('https'),
        cover = null,
        name = faker.randomGenerator.string(50),
        artist = '${faker.person.firstName()} ${faker.person.lastName()}',
        album = faker.randomGenerator.string(50),
        duration = Duration(minutes: faker.date.dateTime().minute);

  Song.fromJson(Map<String, dynamic> json)
      : id = json[idJsonKey],
        playlistId = json[playlistIdJsonKey],
        path = json[pathJsonKey],
        cover = json[coverJsonKey],
        name = json[nameJsonKey],
        artist = json[artistJsonKey],
        album = json[albumJsonKey],
        duration = json[durationJsonKey];

  Map<String, dynamic> toJson() {
    return {
      idJsonKey: id,
      playlistIdJsonKey: playlistId,
      pathJsonKey: path,
      coverJsonKey: cover,
      nameJsonKey: name,
      artistJsonKey: artist,
      albumJsonKey: album,
      durationJsonKey: duration,
    };
  }

  @override
  String toString() => 'Song(\n'
      '  id: $id,\n'
      '  playlistId: $playlistId,\n'
      '  path: $path,\n'
      '  cover: $cover,\n'
      '  name: $name,\n'
      '  artist: $artist,\n'
      '  album: $album,\n'
      '  duration: $duration,\n'
      ');';

  @override
  List<Object?> get props {
    return [
      id,
      playlistId,
      path,
      cover,
      name,
      artist,
      album,
      duration,
    ];
  }
}
