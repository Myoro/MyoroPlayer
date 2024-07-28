import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/mobile/blocs/permission_cubit.dart';
import 'package:myoro_player/mobile/screens/main_screen/widgets/main_screen_app_bar/main_screen_app_bar.dart';
import 'package:myoro_player/mobile/screens/main_screen/widgets/main_screen_body.dart';
import 'package:myoro_player/core/widgets/scaffolds/base_scaffold.dart';
import 'package:myoro_player/mobile/screens/permission_screen/widgets/permission_screen.dart';

final class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _permissionCubit = PermissionCubit()..checkPermissions();

  @override
  void dispose() {
    _permissionCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _permissionCubit,
      child: BlocListener<PermissionCubit, bool>(
        // coverage:ignore-start
        listener: (context, showPermissionScreen) {
          if (!showPermissionScreen) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PermissionScreen(
                _permissionCubit,
              ),
            ),
          );
        },
        // coverage:ignore-end
        child: const BaseScaffold(
          appBar: MainScreenAppBar(),
          body: MainScreenBody(),
        ),
      ),
    );
  }
}
