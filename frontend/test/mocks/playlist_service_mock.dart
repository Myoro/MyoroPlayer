import 'package:mocktail/mocktail.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';

final class PlaylistServiceMock extends Mock implements PlaylistService {
  static final List<Playlist> preConfiguredPlaylists = Playlist.mockList();

  static PlaylistServiceMock preConfigured({List<Playlist>? playlists}) {
    final mock = PlaylistServiceMock();
    when(
      () => mock.select(conditions: any(named: 'conditions')),
    ).thenAnswer(
      (_) async => playlists ?? preConfiguredPlaylists,
    );
    return mock;
  }
}
