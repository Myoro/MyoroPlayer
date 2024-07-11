import 'package:flutter/material.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/models/song.dart';

/// A singleton controller that interactions with MyoroPlayer's audio player and manages songs
class SongController extends ChangeNotifier {
  /// Loaded [Playlist] that is used to, for example, pick/choose new songs
  Playlist? _loadedPlaylist;

  /// The [Song] that is loaded and, for example, could be playing
  Song? _loadedSong;

  /// Queued [Song]s
  final List<Song> _queue = [];

  /// Previously played (cached) songs
  final List<Song> _cache = [];

  void addToQueue(Song song) => _queue.add(song);

  Playlist? get loadedPlaylist => _loadedPlaylist;
  Song? get loadedSong => _loadedSong;
  List<Song> get queue => _queue;
  List<Song> get cache => _cache;
}
