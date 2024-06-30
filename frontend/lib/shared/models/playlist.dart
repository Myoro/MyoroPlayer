import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';

/// Model for a folder or playlist from the API
final class Playlist extends Equatable {
  static const idJsonKey = 'id';
  static const pathJsonKey = 'path';
  static const nameJsonKey = 'name';
  static const imageJsonKey = 'image';

  /// ID of the playlist
  final int? id;

  /// Path to the playlist
  final String path;

  /// Name of the playlist
  final String name;

  /// Image of the playlist that the user has set in MyoroPlayer
  final String? image;

  const Playlist({
    this.id,
    required this.path,
    required this.name,
    this.image,
  });

  Playlist copyWith({
    int? id,
    String? path,
    String? name,
    String? image,
  }) {
    return Playlist(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  static Playlist get mock {
    return Playlist(
      id: faker.randomGenerator.integer(100),
      path: faker.internet.uri('/'),
      name: faker.person.firstName(),
      image: faker.internet.uri('/'),
    );
  }

  static List<Playlist> mockList({int size = 10}) {
    return List.generate(
      size,
      (index) {
        return Playlist.mock;
      },
    );
  }

  Playlist.fromJson(Map<String, dynamic> json)
      : id = json[idJsonKey],
        path = json[pathJsonKey],
        name = json[nameJsonKey],
        image = json[imageJsonKey];

  Map<String, dynamic> toJson({bool buildId = false}) {
    return {
      if (buildId) idJsonKey: id,
      pathJsonKey: path,
      nameJsonKey: name,
      imageJsonKey: image ?? '', // sqflite likes to complain about null
    };
  }

  @override
  String toString() => 'Playlist(\n'
      '  id: $id,\n'
      '  path: $path,\n'
      '  name: $name,\n'
      '  image: $image,\n'
      ');';

  @override
  List<Object?> get props => [id, path, name, image];
}
