import 'package:equatable/equatable.dart';

/// Model for a folder or playlist from the API
final class Playlist extends Equatable {
  static const pathJsonKey = 'path';
  static const nameJsonKey = 'name';
  static const imageJsonKey = 'image';

  /// Path to the playlist
  final String path;

  /// Name of the playlist
  final String name;

  /// Image of the playlist that the user has set in MyoroPlayer
  final String? image;

  const Playlist({
    required this.path,
    required this.name,
    this.image,
  });

  Playlist copyWith({
    String? path,
    String? name,
    String? image,
  }) {
    return Playlist(
      path: path ?? this.path,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }

  Playlist.fromJson(Map<String, dynamic> json)
      : path = json[pathJsonKey],
        name = json[nameJsonKey],
        image = json[imageJsonKey];

  Map<String, dynamic> toJson() {
    return {
      pathJsonKey: path,
      nameJsonKey: name,
      imageJsonKey: image,
    };
  }

  @override
  String toString() => 'Playlist(\n'
      '  path: $path,\n'
      '  name: $name,\n'
      '  image: $image,\n'
      ');';

  @override
  List<Object?> get props => [path, name, image];
}
