import 'package:mocktail/mocktail.dart';
import 'package:frontend/shared/models/user_preferences.dart';
import 'package:frontend/shared/services/user_preferences_service/user_preferences_service.dart';

final class UserPreferencesServiceMock extends Mock implements UserPreferencesService {
  static UserPreferencesServiceMock preConfigured({
    UserPreferences? model,
  }) {
    final mock = UserPreferencesServiceMock();

    when(
      () => mock.update(id: any(named: 'id'), data: any(named: 'data')),
    ).thenAnswer((_) async => model ?? UserPreferences.mock);

    return mock;
  }
}
