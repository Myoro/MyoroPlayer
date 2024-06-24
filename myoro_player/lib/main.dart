import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:myoro_player/screens/main_screen/widgets/main_screen.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:myoro_player/shared/database.dart';
import 'package:myoro_player/shared/design_system/theme_data.dart';
import 'package:myoro_player/shared/helpers/platform_helper.dart';
import 'package:myoro_player/shared/models/user_preferences.dart';
import 'package:myoro_player/shared/services/user_preferences_service/user_preferences_service.dart';
import 'package:myoro_player/shared/services/user_preferences_service/user_preferences_service_api.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (PlatformHelper.isDesktop) {
    windowManager.ensureInitialized();
    windowManager.setTitle('MyoroPlayer');
    windowManager.setMinimumSize(const Size(600, 600));
  }

  /// Database initialization
  final database = Database();
  await database.init();

  /// KiwiContainer initialization
  KiwiContainer().registerFactory<UserPreferencesService>((c) => UserPreferencesServiceApi(database));

  /// User preference initialization for it's cubit
  final UserPreferences userPreferences = await KiwiContainer().resolve<UserPreferencesService>().get();

  runApp(
    /// Global BloC initialization
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserPreferencesCubit(userPreferences)),
        BlocProvider(create: (context) => MainScreenBodyPlaylistSideBarBloc()),
      ],
      child: const App(),
    ),
  );
}

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPreferencesCubit, UserPreferences>(
      builder: (context, userPreferences) {
        return MaterialApp(
          title: 'MyoroPlayer',
          themeMode: userPreferences.darkMode ? ThemeMode.dark : ThemeMode.light,
          theme: createTheme(false),
          darkTheme: createTheme(true),
          home: const MainScreen(),
        );
      },
    );
  }
}
