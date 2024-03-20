import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/desktop/main_screen/main_screen/main_screen.dart';
import 'package:myoro_player/shared/blocs/dark_mode_cubit.dart';
import 'package:myoro_player/shared/database.dart';
import 'package:myoro_player/shared/design_system/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Database.init();
  final bool isDarkMode =
      (await Database.get('dark_mode'))['enabled'] == 1 ? true : false;

  runApp(BlocProvider(
    create: (context) => DarkModeCubit(isDarkMode),
    child: const App(),
  ));
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
          home: const MainScreen(),
        ),
      );
}
