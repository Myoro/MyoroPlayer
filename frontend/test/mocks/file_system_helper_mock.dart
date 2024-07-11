import 'package:faker/faker.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/models/song.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/shared/helpers/file_system_helper.dart';

final class FileSystemHelperMock extends Mock implements FileSystemHelper {
  static final preConfiguredPath = faker.internet.uri('https');
  static final preConfiguredSongList = Song.mockList(10);

  static FileSystemHelperMock preConfigured({
    String? path,
    List<Song>? songList,
  }) {
    final mock = FileSystemHelperMock();

    registerFallbackValue(Playlist.mock);

    when(
      () => mock.openFolderDialogWindow(
        title: any(named: 'title'),
      ),
    ).thenAnswer(
      (_) async => path ?? preConfiguredPath,
    );

    when(
      () => mock.createFolderDialogWindow(),
    ).thenAnswer(
      (_) async => path ?? preConfiguredPath,
    );

    when(
      () => mock.openImageDialogWindow(),
    ).thenAnswer(
      (_) async => path ?? preConfiguredPath,
    );

    when(
      () => mock.createFolder(
        any(),
      ),
    ).thenReturn(
      true,
    );

    when(
      () => mock.deleteFolder(
        any(),
      ),
    ).thenReturn(
      true,
    );

    when(
      () => mock.getMp3FilesFromFolder(any()),
    ).thenAnswer(
      (_) async => songList ?? preConfiguredSongList,
    );

    when(
      () => mock.deleteFile(
        any(),
      ),
    ).thenReturn(
      true,
    );

    return mock;
  }
}
