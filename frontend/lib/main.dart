import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_bloc.dart';
import 'package:frontend/shared/helpers/device_helper.dart';
import 'package:frontend/shared/services/song_service/song_service.dart';
import 'package:frontend/shared/services/song_service/song_service_api.dart';
import 'package:kiwi/kiwi.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen.dart';
import 'package:frontend/shared/blocs/user_preferences_cubit.dart';
import 'package:frontend/shared/database.dart';
import 'package:frontend/shared/design_system/theme_data.dart';
import 'package:frontend/shared/helpers/file_system_helper.dart';
import 'package:frontend/shared/helpers/platform_helper.dart';
import 'package:frontend/shared/models/user_preferences.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service_api.dart';
import 'package:frontend/shared/services/user_preferences_service/user_preferences_service.dart';
import 'package:frontend/shared/services/user_preferences_service/user_preferences_service_api.dart';
import 'package:kplayer/kplayer.dart';
import 'package:window_manager/window_manager.dart';

// coverage:ignore-start
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// kplayer (the audio player) initialization
  Player.boot();

  /// Window Manager initialization
  if (PlatformHelper.isDesktop) {
    windowManager.ensureInitialized();
    windowManager.setTitle('MyoroPlayer');
    windowManager.setMinimumSize(const Size(600, 600));
  }

  /// Database initialization
  final database = Database();
  await database.init();
  // await database.deleteThenInit(); // For debugging

  /// KiwiContainer initialization
  KiwiContainer()

    /// Helpers
    ..registerFactory<FileSystemHelper>((_) => FileSystemHelper(database))
    ..registerFactory<DeviceHelper>((_) => DeviceHelper())

    /// (CRUD) services
    ..registerFactory<UserPreferencesService>((_) => UserPreferencesServiceApi(database))
    ..registerFactory<PlaylistService>((_) => PlaylistServiceApi(database))
    ..registerFactory<SongService>((_) => SongServiceApi(database));

  /// User preference initialization for it's cubit
  final UserPreferences userPreferences = (await KiwiContainer().resolve<UserPreferencesService>().get())!;

  runApp(
    /// Global BloC initialization
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserPreferencesCubit(userPreferences)),
        BlocProvider(create: (context) => MainScreenBodyPlaylistSideBarBloc()),
        BlocProvider(create: (context) => MainScreenBodySongListBloc()),
        BlocProvider(create: (context) => MainScreenBodyFooterBloc()),
      ],
      child: const App(),
    ),
  );
}
// coverage:ignore-end

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPreferencesCubit, UserPreferences>(
      builder: (context, userPreferences) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
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
