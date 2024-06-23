import 'package:equatable/equatable.dart';

/// User any type of option that will be saved to the local database
final class UserPreferences extends Equatable {
  static const darkModeJsonKey = 'dark_mode';

  final bool darkMode;

  const UserPreferences({required this.darkMode});

  UserPreferences copyWith({
    bool? darkMode,
  }) {
    return UserPreferences(
      darkMode: darkMode ?? this.darkMode,
    );
  }

  UserPreferences.fromJson(Map<String, dynamic> json) : darkMode = json[darkModeJsonKey] == 1 ? true : false;

  Map<String, dynamic> toJson() => {'dark_mode': darkMode ? 1 : 0};

  @override
  String toString() => 'UserPreferences(darkMode: $darkMode);';

  @override
  List<Object?> get props => [darkMode];
}
