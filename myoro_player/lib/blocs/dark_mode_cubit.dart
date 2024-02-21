import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/database.dart';

class DarkModeCubit extends Cubit<bool> {
  DarkModeCubit(super.isDarkMode);

  void toggle() async {
    Database.update('dark_mode', {'enabled': state ? 0 : 1});
    emit(!state);
  }
}
