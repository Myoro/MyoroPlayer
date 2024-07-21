import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_event.dart';
import 'package:myoro_player/core/models/song.dart';
import 'package:myoro_player/core/widgets/modals/base_modal.dart';

/// Modal to delete a [Song]
final class DeleteSongModal extends StatelessWidget {
  /// [Song] to be deleted
  final Song song;

  const DeleteSongModal._(this.song);

  static void show(BuildContext context, Song song) {
    BaseModal.show(
      context,
      requestCallback: () {
        BlocProvider.of<SongListingBloc>(context).add(
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
