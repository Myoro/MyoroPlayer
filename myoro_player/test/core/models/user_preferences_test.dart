import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/models/user_preferences.dart';

void main() {
  test('UserPreferences unit test', () {
    final userPreferences = UserPreferences.mock;

    // copyWith & props
    expect(userPreferences == userPreferences.copyWith(), isTrue);
    expect(userPreferences == userPreferences.copyWith(darkMode: !userPreferences.darkMode), isFalse);

    // fromJson
    expect(
      UserPreferences.fromJson(
        const {
          UserPreferences.darkModeJsonKey: false,
          UserPreferences.shuffleJsonKey: false,
          UserPreferences.repeatJsonKey: false,
          UserPreferences.volumeJsonKey: 0.5,
        },
      ),
      const UserPreferences(
        darkMode: false,
        shuffle: false,
        repeat: false,
        volume: 0.5,
      ),
    );

    // toJson
    expect(
      userPreferences.toJson(),
      {
        UserPreferences.darkModeJsonKey: userPreferences.darkMode ? 1 : 0,
        UserPreferences.shuffleJsonKey: userPreferences.shuffle ? 1 : 0,
        UserPreferences.repeatJsonKey: userPreferences.repeat ? 1 : 0,
        UserPreferences.volumeJsonKey: userPreferences.volume,
      },
    );

    // toString()
    expect(
      userPreferences.toString(),
      'UserPreferences(\n'
      '  darkMode: ${userPreferences.darkMode},\n'
      '  shuffle: ${userPreferences.shuffle},\n'
      '  repeat: ${userPreferences.repeat},\n'
      '  volume: ${userPreferences.volume},\n'
      ');',
    );
  });
}
