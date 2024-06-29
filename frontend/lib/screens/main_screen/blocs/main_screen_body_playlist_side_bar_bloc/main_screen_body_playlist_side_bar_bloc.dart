import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_event.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_state.dart';
import 'package:frontend/shared/enums/bloc_status_enum.dart';
import 'package:frontend/shared/extensions/string_extension.dart';
import 'package:frontend/shared/helpers/file_system_helper.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';

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

      final String folderName = folderPath.pathName;

      // Checking for invalid characters
      if (!folderName.isValidFolderName) {
        emit(
          state.copyWith(
            status: BlocStatusEnum.error,
            snackBarMessage: 'Playlist cannot contain these characters: \\/:*?"<>|',
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
            snackBarMessage: 'Playlist already exists in your local database.',
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
