import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/extensions/string_extension.dart';
import 'package:myoro_player/shared/helpers/platform_helper.dart';

void main() {
  final validPath = '${PlatformHelper.slash}directory${PlatformHelper.slash}name';
  final invalidPath = '${PlatformHelper.slash}***\\weqw${PlatformHelper.slash}\$%|';

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
