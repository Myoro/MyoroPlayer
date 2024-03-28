class Song {
  /// Path to the file
  final String path;

  /// Name of the song
  final String name;

  /// Artist of the song
  final String artist;

  /// Album the song is apart of
  final String? album;

  /// Base 64 string of the song cover
  final String? cover;

  const Song({
    required this.path,
    required this.name,
    required this.artist,
    this.album,
    this.cover,
  });

  Song copyWith({
    String? path,
    String? name,
    String? artist,
    String? album,
    String? cover,
  }) =>
      Song(
        path: path ?? this.path,
        name: name ?? this.name,
        artist: artist ?? this.artist,
        album: album ?? this.album,
        cover: cover ?? this.cover,
      );
}
