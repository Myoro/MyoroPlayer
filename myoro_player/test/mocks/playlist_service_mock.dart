import 'package:mocktail/mocktail.dart';
import 'package:myoro_player/core/models/playlist.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service.dart';

final class PlaylistServiceMock extends Mock implements PlaylistService {
  static final Playlist preConfiguredPlaylist = Playlist.mock;
  static final List<Playlist> preConfiguredPlaylists = Playlist.mockList();

  static PlaylistServiceMock preConfigured({
    Playlist? playlist,
    List<Playlist>? playlists,
  }) {
    final mock = PlaylistServiceMock();

    registerFallbackValue(playlist ?? preConfiguredPlaylist);

    when(
      () => mock.create(data: any(named: 'data')),
    ).thenAnswer(
      (_) async => playlist ?? preConfiguredPlaylist,
    );

    when(
      () => mock.get(
        conditions: any(named: 'conditions'),
      ),
    ).thenAnswer(
      (_) async => playlist ?? preConfiguredPlaylist,
    );

    when(
      () => mock.select(conditions: any(named: 'conditions')),
    ).thenAnswer(
      (_) async => playlists ?? preConfiguredPlaylists,
    );

    when(
      () => mock.renamePlaylist(
        playlist: any(named: 'playlist'),
        newName: any(named: 'newName'),
      ),
    ).thenAnswer(
      (_) async => playlist ?? preConfiguredPlaylist,
    );

    when(
      () => mock.delete(
        id: any(named: 'id'),
      ),
    ).thenAnswer(
      (_) async {},
    );

    return mock;
  }
}
