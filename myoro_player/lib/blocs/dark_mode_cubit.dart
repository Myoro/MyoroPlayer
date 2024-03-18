import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/database.dart';
import 'package:myoro_player/enums/dark_mode_enum.dart';
import 'package:myoro_player/helpers/build_context_helper.dart';

class DarkModeCubit extends Cubit<DarkModeEnum> {
  DarkModeCubit(super.isDarkMode);

  Future<void> toggle(BuildContext context) async {
    late final DarkModeEnum newDarkModeEnum;

    switch (state) {
      case DarkModeEnum.light:
        newDarkModeEnum = DarkModeEnum.dark;
        break;
      case DarkModeEnum.dark:
        newDarkModeEnum = DarkModeEnum.light;
        break;
      case DarkModeEnum.system:
        newDarkModeEnum =
            context.isDarkMode ? DarkModeEnum.light : DarkModeEnum.dark;
        break;
    }

    emit(newDarkModeEnum);
    await Database.update('dark_mode', {'enabled': newDarkModeEnum.databaseId});
  }
}
