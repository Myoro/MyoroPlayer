import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/blocs/dark_mode_cubit.dart';
import 'package:myoro_player/database.dart';
import 'package:myoro_player/enums/dark_mode_enum.dart';
import 'package:myoro_player/theme/theme_data.dart';
import 'package:myoro_player/widgets/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Database.init();
  final int isDarkMode = (await Database.get('dark_mode'))['enabled'] as int;

  runApp(
    BlocProvider(
        create: (context) => DarkModeCubit(
            DarkModeEnum.values.firstWhere((e) => e.databaseId == isDarkMode)),
        child: const App()),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DarkModeCubit, DarkModeEnum>(
        builder: (context, darkModeEnum) => MaterialApp(
          title: 'MyoroPlayer',
          theme: createTheme(isDarkMode: false),
          darkTheme: createTheme(isDarkMode: true),
          themeMode: darkModeEnum.themeMode,
          home: const MainScreen(),
        ),
      );
}
