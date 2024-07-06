import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/shared/helpers/file_system_helper.dart';

final class FileSystemHelperMock extends Mock implements FileSystemHelper {
  static final preConfiguredPath = faker.internet.uri('https');

  static FileSystemHelperMock preConfigured({
    String? path,
  }) {
    final mock = FileSystemHelperMock();

    when(
      () => mock.openFolderDialogWindow(),
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

    return mock;
  }
}
