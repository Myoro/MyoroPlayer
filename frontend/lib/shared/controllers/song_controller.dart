import 'package:flutter/foundation.dart';
import 'package:frontend/shared/models/conditions.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/models/song.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';
import 'package:kiwi/kiwi.dart';

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

  /// Adds a [Song] to [_queue]
  void addToQueue(Song song) => _queue.add(song);

  /// In order to get a [Song]'s playlist from [Song.playlistId]
  final _playlistService = KiwiContainer().resolve<PlaylistService>();

  /// Case for when the user clicks on a [Song] to play it
  ///
  /// Steps for direct play
  /// 1. Cache the current [_loadedSong] (if it is not null)
  /// 2. Set [_loadedSong] as incoming [song]
  /// 3. Set [_loadedPlaylist] as incoming [song]'s playlist
  Future<void> directPlay(Song song) async {
    _loadedSong = song;
    _loadedPlaylist = await _playlistService.get(conditions: Conditions({Playlist.idJsonKey: _loadedSong?.playlistId}));

    notifyListeners();
  }

  /// Getters
  Playlist? get loadedPlaylist => _loadedPlaylist;
  Song? get loadedSong => _loadedSong;
  List<Song> get queue => _queue;
  List<Song> get cache => _cache;
}
