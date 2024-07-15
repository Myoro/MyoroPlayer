import 'package:myoro_player/shared/models/song.dart';
import 'package:myoro_player/shared/services/song_service/song_service.dart';
import 'package:mocktail/mocktail.dart';

final class SongServiceMock extends Mock implements SongService {
  static final preConfiguredSongList = Song.mockList();

  static SongServiceMock preConfigured({
    List<Song>? songList,
  }) {
    final mock = SongServiceMock();

    when(
      () => mock.delete(
        id: any(named: 'id'),
      ),
    ).thenAnswer(
      (_) async {},
    );

    when(
      () => mock.select(
        conditions: any(named: 'conditions'),
      ),
    ).thenAnswer(
      (_) async => songList ?? preConfiguredSongList,
    );

    return mock;
  }
}
