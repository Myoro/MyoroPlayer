import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_event.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_state.dart';

final class MainScreenBodyPlaylistSideBarBloc extends Bloc<MainScreenBodyPlaylistSideBarEvent, MainScreenBodyPlaylistSideBarState> {
  MainScreenBodyPlaylistSideBarBloc() : super(const MainScreenBodyPlaylistSideBarState()) {
    on<CreatePlaylistEvent>((event, emit) => print('Use FilePicker now'));
  }
}
