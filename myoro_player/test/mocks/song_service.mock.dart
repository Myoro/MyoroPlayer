import 'package:myoro_player/shared/services/song_service/song_service.dart';
import 'package:mocktail/mocktail.dart';

final class SongServiceMock extends Mock implements SongService {
  static SongServiceMock preConfigured() {
    final mock = SongServiceMock();

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
