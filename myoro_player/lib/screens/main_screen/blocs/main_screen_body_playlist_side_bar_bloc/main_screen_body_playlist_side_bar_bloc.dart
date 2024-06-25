import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_event.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_state.dart';
import 'package:myoro_player/shared/enums/bloc_status_enum.dart';
import 'package:myoro_player/shared/extensions/string_extension.dart';
import 'package:myoro_player/shared/helpers/file_system_helper.dart';

final class MainScreenBodyPlaylistSideBarBloc extends Bloc<MainScreenBodyPlaylistSideBarEvent, MainScreenBodyPlaylistSideBarState> {
  final _fileSystemHelper = KiwiContainer().resolve<FileSystemHelper>();

  MainScreenBodyPlaylistSideBarBloc() : super(const MainScreenBodyPlaylistSideBarState()) {
    on<CreatePlaylistEvent>((event, emit) async {
      emit(state.copyWith(status: BlocStatusEnum.loading));

      final String? folderPath = await _fileSystemHelper.createDirectoryDialogWindow();

      if (folderPath == null) return;

      final String folderName = folderPath.getNameFromPath();

      if (!folderName.isValidFolderName) {
        emit(
          state.copyWith(
            status: BlocStatusEnum.error,
            snackBarMessage: 'Playlist contain these characters: \\/:*?"<>|',
          ),
        );

        return;
      }

      // TODO
      print('need to cover this still');
    });
  }
}
