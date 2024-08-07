import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_event.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_state.dart';
import 'package:myoro_player/core/enums/bloc_status_enum.dart';
import 'package:myoro_player/core/helpers/file_system_helper.dart';
import 'package:myoro_player/core/models/song.dart';
import 'package:myoro_player/core/services/song_service/song_service.dart';
import 'package:kiwi/kiwi.dart';

/// Used for controlling the list of [Song]s to be displayed to the user
final class SongListingBloc extends Bloc<SongListingEvent, SongListingState> {
  late final FileSystemHelper _fileSystemHelper;
  late final SongService _songService;

  SongListingBloc() : super(const SongListingState()) {
    final kiwiContainer = KiwiContainer();
    _fileSystemHelper = kiwiContainer.resolve<FileSystemHelper>();
    _songService = kiwiContainer.resolve<SongService>();

    on<LoadPlaylistSongsEvent>((event, emit) async {
      emit(state.copyWith(status: BlocStatusEnum.loading));

      // Grabbing all of the MP3 files within the playlist
      final List<Song> loadedPlaylistSongs = await _fileSystemHelper.getMp3FilesFromFolder(
        event.playlist,
      );

      emit(
        state.copyWith(
          status: BlocStatusEnum.completed,
          loadedPlaylist: event.playlist,
          loadedPlaylistSongs: loadedPlaylistSongs,
        ),
      );
    });

    on<CopySongToPlaylistEvent>((event, emit) async {
      final String? folderPath = await _fileSystemHelper.openFolderDialogWindow(
        title: 'Select a folder to copy ${event.song.title} to.',
      );

      if (folderPath == null) return;

      final String? newFilePath = _fileSystemHelper.copyFile(
        event.song.path,
        folderPath,
      );

      if (newFilePath == null) {
        emit(
          state.copyWith(
            status: BlocStatusEnum.error,
            snackBarMessage: 'Error copying ${event.song.title} to $folderPath.',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatusEnum.completed,
            snackBarMessage: '${event.song.title} copied to $folderPath successfully!',
          ),
        );
      }
    });

    on<MoveSongToPlaylistEvent>((event, emit) async {
      final String? folderPath = await _fileSystemHelper.openFolderDialogWindow(
        title: 'Select a folder to move ${event.song.title} to.',
      );

      if (folderPath == null) return;

      final String? newFilePath = _fileSystemHelper.moveFile(
        event.song.path,
        folderPath,
      );

      if (newFilePath == null) {
        emit(
          state.copyWith(
            status: BlocStatusEnum.error,
            snackBarMessage: 'Error moving ${event.song.title} to $folderPath.',
          ),
        );
      } else {
        await _songService.delete(id: event.song.id!);
        emit(
          state.copyWith(
            status: BlocStatusEnum.completed,
            snackBarMessage: '${event.song.title} moved to $folderPath successfully!',
            loadedPlaylistSongs: List.from(state.loadedPlaylistSongs!)..remove(event.song),
          ),
        );
      }
    });

    on<DeleteSongFromDeviceEvent>((event, emit) async {
      await _songService.delete(id: event.song.id!);
      if (_fileSystemHelper.deleteFile(event.song.path)) {
        emit(
          state.copyWith(
            status: BlocStatusEnum.completed,
            snackBarMessage: '${event.song.title} deleted from your device successfully!',
            loadedPlaylistSongs: List.from(state.loadedPlaylistSongs!)..remove(event.song),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatusEnum.error,
            snackBarMessage: 'Error deleting ${event.song.title} from your device.',
          ),
        );
      }
    });
  }
}
