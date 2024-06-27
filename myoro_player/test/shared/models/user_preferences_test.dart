import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/models/user_preferences.dart';

void main() {
  test('UserPreferences unit test', () {
    final userPreferences = UserPreferences.mock;

    // copyWith & props
    expect(userPreferences == userPreferences.copyWith(), isTrue);
    expect(userPreferences == userPreferences.copyWith(darkMode: !userPreferences.darkMode), isFalse);

    // fromJson
    expect(
      UserPreferences.fromJson(const {UserPreferences.darkModeJsonKey: false}),
      const UserPreferences(darkMode: false),
    );

    // toJson
    expect(
      userPreferences.toJson(),
      {UserPreferences.darkModeJsonKey: userPreferences.darkMode ? 1 : 0},
    );

    // toString()
    expect(
      userPreferences.toString(),
      'UserPreferences(darkMode: ${userPreferences.darkMode});',
    );
  });
}
