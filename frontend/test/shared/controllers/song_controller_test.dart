import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/controllers/song_controller.dart';
import 'package:frontend/shared/models/song.dart';

void main() {
  test('SongController initialization unit test.', () {
    final controller = SongController();
    expect(controller.loadedPlaylist, isNull);
    expect(controller.loadedSong, isNull);
    expect(controller.queue, isEmpty);
    expect(controller.cache, isEmpty);
    controller.dispose();
  });

  test('SongController.addToQueue unit test.', () {
    final controller = SongController();
    final song = Song.mock;
    controller.addToQueue(song);
    expect(controller.queue.length, 1);
    expect(controller.queue.first, song);
  });
}
