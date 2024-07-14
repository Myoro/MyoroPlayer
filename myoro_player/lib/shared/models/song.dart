import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';

final class Song extends Equatable {
  static const idJsonKey = 'id';
  static const playlistIdJsonKey = 'playlist_id';
  static const pathJsonKey = 'path';
  static const coverJsonKey = 'cover';
  static const titleJsonKey = 'title';
  static const artistJsonKey = 'artist';
  static const albumJsonKey = 'album';
  static const durationJsonKey = 'duration';

  final int? id;
  final int playlistId;
  final String path;
  final Uint8List? cover;
  final String title;
  final String? artist;
  final String? album;
  final Duration duration;

  const Song({
    this.id,
    required this.playlistId,
    required this.path,
    this.cover,
    required this.title,
    this.artist,
    this.album,
    required this.duration,
  });

  Song copyWith({
    int? id,
    int? playlistId,
    String? path,
    Uint8List? cover,
    String? title,
    String? artist,
    String? album,
    Duration? duration,
  }) {
    return Song(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      path: path ?? this.path,
      cover: cover ?? this.cover,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      duration: duration ?? this.duration,
    );
  }

  static Song get mock {
    return Song(
      id: faker.randomGenerator.integer(100),
      playlistId: faker.randomGenerator.integer(100),
      path: faker.internet.uri('https'),
      cover: null,
      title: faker.randomGenerator.string(50),
      artist: '${faker.person.firstName()} ${faker.person.lastName()}',
      album: faker.randomGenerator.string(50),
      duration: Duration(minutes: faker.date.dateTime().minute),
    );
  }

  static List<Song> mockList([int size = 10]) {
    return List.generate(
      size,
      (index) => Song.mock,
    );
  }

  Song.fromJson(Map<String, dynamic> json)
      : id = json[idJsonKey],
        playlistId = json[playlistIdJsonKey],
        path = json[pathJsonKey],
        cover = json[coverJsonKey] != null ? Uint8List.fromList(json[coverJsonKey]) : null,
        title = json[titleJsonKey],
        artist = json[artistJsonKey].isNotEmpty ? json[artistJsonKey] : null,
        album = json[albumJsonKey].isNotEmpty ? json[albumJsonKey] : null,
        duration = Duration(milliseconds: json[durationJsonKey]);

  Map<String, dynamic> toJson({bool buildId = false}) {
    return {
      if (buildId) idJsonKey: id,
      playlistIdJsonKey: playlistId,
      pathJsonKey: path,
      coverJsonKey: cover,
      titleJsonKey: title,
      artistJsonKey: artist ?? '', // sqflite doesn't like null values
      albumJsonKey: album ?? '', // sqflite doesn't like null values
      durationJsonKey: duration.inMilliseconds,
    };
  }

  @override
  String toString() => 'Song(\n'
      '  id: $id,\n'
      '  playlistId: $playlistId,\n'
      '  path: $path,\n'
      '  cover: $cover,\n'
      '  title: $title,\n'
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
      title,
      artist,
      album,
      duration,
    ];
  }
}
