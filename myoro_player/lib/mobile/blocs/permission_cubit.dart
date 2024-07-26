// coverage:ignore-file

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/mobile/helpers/permission_helper.dart';
import 'package:myoro_player/mobile/screens/permission_screen/widgets/permission_screen.dart';

/// Cubit to redirect to [PermissionScreen]
final class PermissionCubit extends Cubit<bool> {
  PermissionCubit() : super(false);

  Future<void> checkPermissions() async {
    emit(false);
    emit(!(await PermissionHelper.permissionsGranted));
  }
}
