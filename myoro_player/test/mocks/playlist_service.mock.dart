import 'package:mocktail/mocktail.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';

final class PlaylistServiceMock extends Mock implements PlaylistService {
  static PlaylistServiceMock preConfigured({Playlist? model}) {
    return PlaylistServiceMock();
  }
}
