import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/shared/models/user_preferences.dart';
import 'package:myoro_player/shared/services/user_preferences_service/user_preferences_service.dart';

final class UserPreferencesCubit extends Cubit<UserPreferences> {
  final _userPreferencesService = KiwiContainer().resolve<UserPreferencesService>();

  UserPreferencesCubit(super.userPreferences);

  Future<void> toggleTheme() async {
    emit((await _userPreferencesService.update(
      data: {
        UserPreferences.darkModeJsonKey: state.darkMode ? 0 : 1,
      },
    ))!);
  }

  Future<void> toggleShuffle() async {
    emit((await _userPreferencesService.update(
      data: {
        UserPreferences.shuffleJsonKey: state.shuffle ? 0 : 1,
      },
    ))!);
  }

  Future<void> toggleRepeat() async {
    emit((await _userPreferencesService.update(
      data: {
        UserPreferences.repeatJsonKey: state.repeat ? 0 : 1,
      },
    ))!);
  }

  Future<void> setVolume(double value) async {
    emit((await _userPreferencesService.update(
      data: {
        UserPreferences.volumeJsonKey: value.toInt(),
      },
    ))!);
  }
}
