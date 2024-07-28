import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_bloc.dart';
import 'package:myoro_player/core/helpers/device_helper.dart';
import 'package:myoro_player/core/services/song_service/song_service.dart';
import 'package:myoro_player/core/services/song_service/song_service_api.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/widgets/main_screen.dart' as desktop;
import 'package:myoro_player/mobile/screens/main_screen/widgets/main_screen.dart' as mobile;
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:myoro_player/core/database.dart';
import 'package:myoro_player/core/design_system/theme_data.dart';
import 'package:myoro_player/core/helpers/file_system_helper.dart';
import 'package:myoro_player/core/helpers/platform_helper.dart';
import 'package:myoro_player/core/models/user_preferences.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service_api.dart';
import 'package:myoro_player/core/services/user_preferences_service/user_preferences_service.dart';
import 'package:myoro_player/core/services/user_preferences_service/user_preferences_service_api.dart';
import 'package:kplayer/kplayer.dart';
import 'package:window_manager/window_manager.dart';

// coverage:ignore-start
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// kplayer (the audio player) initialization
  Player.boot();

  /// Window Manager initialization
  if (PlatformHelper().isDesktop) {
    windowManager.ensureInitialized();
    windowManager.setTitle('MyoroPlayer');
    windowManager.setMinimumSize(const Size(600, 600));
  }

  /// KiwiContainer initialization #1
  KiwiContainer().registerFactory<PlatformHelper>((_) => PlatformHelper());

  /// Database initialization
  final database = Database();
  await database.init();
  // await database.deleteThenInit(); // For debugging

  /// KiwiContainer initialization #2
  KiwiContainer()

    /// Helpers
    ..registerFactory<FileSystemHelper>((_) => FileSystemHelper(database))
    ..registerFactory<DeviceHelper>((_) => DeviceHelper())

    /// (CRUD) services
    ..registerFactory<UserPreferencesService>((_) => UserPreferencesServiceApi(database))
    ..registerFactory<PlaylistService>((_) => PlaylistServiceApi(database))
    ..registerFactory<SongService>((_) => SongServiceApi(database));

  /// User preferences cubit initialized here to provide to [SongControlsBloc]
  final userPreferencesCubit = UserPreferencesCubit(
    (await KiwiContainer().resolve<UserPreferencesService>().get())!,
  );

  runApp(
    /// Global BloC initialization
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => userPreferencesCubit),
        BlocProvider(create: (context) => PlaylistListingBloc()),
        BlocProvider(create: (context) => SongListingBloc()),
        BlocProvider(create: (context) => SongControlsBloc(userPreferencesCubit)),
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
          home: KiwiContainer().resolve<PlatformHelper>().isDesktop ? const desktop.MainScreen() : const mobile.MainScreen(),
        );
      },
    );
  }
}
