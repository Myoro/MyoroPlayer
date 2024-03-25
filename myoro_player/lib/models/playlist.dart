class Playlist {
  final String directory;
  final String name;

  const Playlist({
    required this.directory,
    required this.name,
  });

  Playlist copyWith({
    String? directory,
    String? name,
  }) =>
      Playlist(
        directory: directory ?? this.directory,
        name: name ?? this.name,
      );

  Playlist.fromJson(Map<String, dynamic> json)
      : directory = json['directory'],
        name = json['name'];
}
