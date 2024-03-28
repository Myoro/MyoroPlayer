import 'package:flutter/material.dart';
import 'package:myoro_player/shared/blocs/playlist_cubit.dart';
import 'package:myoro_player/shared/blocs/song_cubit.dart';
import 'package:myoro_player/shared/widgets/shortcuts/global_keyboard_shortcuts.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/dark_mode_cubit.dart';
import 'package:myoro_player/shared/database.dart';
import 'package:myoro_player/shared/design_system/theme_data.dart';
import 'package:myoro_player/desktop/main_screen/main_screen.dart';
import 'package:myoro_player/shared/helpers/platform_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (PlatformHelper.isDesktop) {
    windowManager.ensureInitialized();
    windowManager.setMinimumSize(const Size(450, 450));
    windowManager.setTitle('MyoroPlayer');
  }

  await Database.init();

  runApp(
    /// GLOBAL BLOCS
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DarkModeCubit()..getDarkMode()),
        BlocProvider(create: (context) => PlaylistCubit()..getPlaylists()),
        BlocProvider(create: (context) => SongCubit()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<DarkModeCubit, bool>(
        builder: (context, isDarkMode) => MaterialApp(
          title: 'MyoroPlayer',
          theme: createTheme(isDarkMode: false),
          darkTheme: createTheme(isDarkMode: true),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const GlobalKeyboardShortcuts(
            child: Focus(
              autofocus: true,
              child: MainScreen(),
            ),
          ),
        ),
      );
}
