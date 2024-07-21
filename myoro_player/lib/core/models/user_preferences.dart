import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';

/// User any type of option that will be saved to the local database
final class UserPreferences extends Equatable {
  static const darkModeJsonKey = 'dark_mode';
  static const shuffleJsonKey = 'shuffle';
  static const repeatJsonKey = 'repeat';
  static const volumeJsonKey = 'volume';

  final bool darkMode;
  final bool shuffle;
  final bool repeat;
  final double volume;

  const UserPreferences({
    required this.darkMode,
    required this.shuffle,
    required this.repeat,
    required this.volume,
  });

  UserPreferences copyWith({
    bool? darkMode,
    bool? shuffle,
    bool? repeat,
    double? volume,
  }) {
    return UserPreferences(
      darkMode: darkMode ?? this.darkMode,
      shuffle: shuffle ?? this.shuffle,
      repeat: repeat ?? this.repeat,
      volume: volume ?? this.volume,
    );
  }

  static UserPreferences get mock {
    return UserPreferences(
      darkMode: faker.randomGenerator.boolean(),
      shuffle: faker.randomGenerator.boolean(),
      repeat: faker.randomGenerator.boolean(),
      volume: faker.randomGenerator.decimal(),
    );
  }

  UserPreferences.fromJson(Map<String, dynamic> json)
      : darkMode = json[darkModeJsonKey] == 1 ? true : false,
        shuffle = json[shuffleJsonKey] == 1 ? true : false,
        repeat = json[repeatJsonKey] == 1 ? true : false,
        volume = json[volumeJsonKey];

  Map<String, dynamic> toJson() {
    return {
      darkModeJsonKey: darkMode ? 1 : 0,
      shuffleJsonKey: shuffle ? 1 : 0,
      repeatJsonKey: repeat ? 1 : 0,
      volumeJsonKey: volume,
    };
  }

  @override
  String toString() => 'UserPreferences(\n'
      '  darkMode: $darkMode,\n'
      '  shuffle: $shuffle,\n'
      '  repeat: $repeat,\n'
      '  volume: $volume,\n'
      ');';

  @override
  List<Object?> get props => [darkMode, shuffle, repeat, volume];
}
