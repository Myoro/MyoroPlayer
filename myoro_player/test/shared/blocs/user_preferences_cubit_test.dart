import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:myoro_player/shared/models/user_preferences.dart';
import 'package:myoro_player/shared/services/user_preferences_service/user_preferences_service.dart';

import '../../mocks/user_preferences_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  final userPreferences = UserPreferences.mock;

  setUp(
    () => kiwiContainer.registerFactory<UserPreferencesService>(
      (_) => UserPreferencesServiceMock.preConfigured(
        model: userPreferences,
      ),
    ),
  );
  tearDown(() => kiwiContainer.clear());

  test('UserPreferencesCubit.toggleTheme', () {
    final cubit = UserPreferencesCubit(UserPreferences.mock);
    expect(cubit.stream, emits(userPreferences));
    cubit.toggleTheme();
  });
}
