import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/extensions/string_extension.dart';
import 'package:frontend/shared/helpers/platform_helper.dart';

void main() {
  final slash = PlatformHelper.isWindows ? '\\' : '/';
  final validPath = '${slash}directory${slash}name';
  final invalidPath = '$slash***\\weqw$slash\$%|';

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
