import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/core/enums/platform_enum.dart';
import 'package:myoro_player/core/extensions/string_extension.dart';
import 'package:myoro_player/core/helpers/platform_helper.dart';

import '../../mocks/platform_helper_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  const validPath = '/directory/name';
  const invalidPath = '/***\\weqw/\$%|';

  setUp(() => kiwiContainer.registerFactory<PlatformHelper>((_) => PlatformHelperMock.preConfigured(platform: PlatformEnum.linux)));
  tearDown(() => kiwiContainer.clear());

  test('StringExtension.getNameFromPath', () {
    expect(validPath.pathName, 'name');
  });

  test('StringExtension.isValidFolderName', () {
    expect(validPath.pathName.isValidFolderName, isTrue);
    expect(invalidPath.pathName.isValidFolderName, isFalse);
  });

  test('StringExtension.pathExists', () async {
    expect(validPath.folderExists, isFalse);
  });
}
