import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/blocs/dark_mode_cubit.dart';
import 'package:myoro_player/database.dart';
import 'package:myoro_player/helpers/platform_helper.dart';
import 'package:myoro_player/theme.dart';
import 'package:myoro_player/widgets/desktop/home_screen/home_screen.dart'
    as Desktop;
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (PlatformHelper.isDesktop) {
    windowManager.ensureInitialized();
    windowManager.setMinimumSize(const Size(600, 600));
  }

  await Database.init();
  final bool isDarkMode =
      (await Database.get('dark_mode'))['enabled'] == 1 ? true : false;

  runApp(
    BlocProvider(
      create: (context) => DarkModeCubit(isDarkMode),
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
          theme: createTheme(isDarkMode),
          home: PlatformHelper.isDesktop
              ? const Desktop.HomeScreen()
              : const SizedBox.shrink(), // TODO: Mobile UI
        ),
      );
}
