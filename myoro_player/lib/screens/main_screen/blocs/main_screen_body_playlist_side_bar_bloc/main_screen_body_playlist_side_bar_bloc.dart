import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_event.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_state.dart';
import 'package:myoro_player/shared/enums/bloc_status_enum.dart';
import 'package:myoro_player/shared/extensions/string_extension.dart';
import 'package:myoro_player/shared/helpers/file_system_helper.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';

final class MainScreenBodyPlaylistSideBarBloc extends Bloc<MainScreenBodyPlaylistSideBarEvent, MainScreenBodyPlaylistSideBarState> {
  late final FileSystemHelper _fileSystemHelper;
  late final PlaylistService _playlistService;

  MainScreenBodyPlaylistSideBarBloc() : super(const MainScreenBodyPlaylistSideBarState()) {
    final kiwiContainer = KiwiContainer();
    _fileSystemHelper = kiwiContainer.resolve<FileSystemHelper>();
    _playlistService = kiwiContainer.resolve<PlaylistService>();

    on<CreatePlaylistEvent>((event, emit) async {
      emit(state.copyWith(status: BlocStatusEnum.loading));

      final String? folderPath = await _fileSystemHelper.createFolderDialogWindow();

      // Operation cancelled by the user
      if (folderPath == null) return;

      final String folderName = folderPath.getNameFromPath();

      // Checking for invalid characters
      if (!folderName.isValidFolderName) {
        emit(
          state.copyWith(
            status: BlocStatusEnum.error,
            snackBarMessage: 'Playlist contain these characters: \\/:*?"<>|',
          ),
        );

        return;
      }

      final Playlist? playlist = await _playlistService.create(
        data: Playlist(
          path: folderPath,
          name: folderName,
        ).toJson(),
      );

      if (playlist == null) {
        emit(
          state.copyWith(
            status: BlocStatusEnum.error,
            snackBarMessage: 'Playlist alreadys exists in your local database.',
          ),
        );

        return;
      }

      // No validation needed to see if the folder exists as the dialog window already handles that
      _fileSystemHelper.createFolder(playlist.path);

      emit(
        state.copyWith(
          status: BlocStatusEnum.completed,
          snackBarMessage: '${playlist.path} created successfully!',
        ),
      );
    });
  }
}
