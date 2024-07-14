import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_bloc.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_event.dart';
import 'package:myoro_player/shared/models/song.dart';
import 'package:myoro_player/shared/widgets/modals/base_modal.dart';

/// Modal to delete a [Song]
final class DeleteSongModal extends StatelessWidget {
  /// [Song] to be deleted
  final Song song;

  const DeleteSongModal._(this.song);

  static void show(BuildContext context, Song song) {
    BaseModal.show(
      context,
      requestCallback: () {
        BlocProvider.of<MainScreenBodySongListBloc>(context).add(
          DeleteSongFromDeviceEvent(song),
        );
      },
      title: 'Delete ${song.title}',
      child: DeleteSongModal._(song),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Are you sure you want to delete ${song.title}? This is not reversible!',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
