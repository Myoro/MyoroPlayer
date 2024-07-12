// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:frontend/shared/models/conditions.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/models/song.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:kplayer/kplayer.dart';

/// A singleton controller that interactions with MyoroPlayer's audio player and manages songs
class SongController extends ChangeNotifier {
  /// The audio player
  PlayerController? _player;

  /// Loaded [Playlist] that is used to, for example, pick/choose new songs
  Playlist? _loadedPlaylist;

  /// The [Song] that is loaded and, for example, could be playing
  (Song song, bool cacheSong)? _loadedSong;

  /// Queued [Song]s
  final List<Song> _queue = [];

  /// Previously played (cached) songs
  final List<Song> _cache = [];

  /// Easy [bool] to keep track of if the audio player is playing or not
  ///
  /// [kplayer] has some shitty logic regarding this
  bool _isPlaying = false;

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
    if (_loadedSong?.$2 == true) _cache.add(_loadedSong!.$1);
    _loadedSong = (song, true);
    _loadedPlaylist = await _playlistService.get(
      conditions: Conditions({Playlist.idJsonKey: _loadedSong?.$1.playlistId}),
    );
    _loadSong(_loadedSong!.$1);
    notifyListeners();
  }

  /// Pauses or resumes a song
  ///
  /// Returns [true] if the song is playing now, [false] otherwise
  bool togglePlayPause() {
    if (_player?.ready == true) {
      if (_player?.playing == true) {
        _player?.pause();
        _isPlaying = false;
        notifyListeners();
        return false;
      } else {
        _player?.play();
        _isPlaying = true;
        notifyListeners();
        return true;
      }
    }

    notifyListeners();
    return false;
  }

  /// Function that loads the [Song] into [_player] to play the song
  void _loadSong(Song song) {
    _player?.dispose();
    if (_player != null) _player = null;
    _player = Player.file(song.path);
    _isPlaying = true;
  }

  /// Getters
  Playlist? get loadedPlaylist => _loadedPlaylist;
  (Song song, bool cacheSong)? get loadedSong => _loadedSong;
  List<Song> get queue => _queue;
  List<Song> get cache => _cache;
  bool get isPlaying => _isPlaying;
}
