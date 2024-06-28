import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:frontend/shared/models/user_preferences.dart';
import 'package:frontend/shared/services/user_preferences_service/user_preferences_service.dart';

final class UserPreferencesCubit extends Cubit<UserPreferences> {
  final _userPreferencesService = KiwiContainer().resolve<UserPreferencesService>();

  UserPreferencesCubit(super.userPreferences);

  Future<void> toggleTheme() async {
    emit((await _userPreferencesService.update())!);
  }
}
