import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myoro_player/shared/enums/playlist_actions_enum.dart';
import 'package:myoro_player/shared/widgets/shortcuts/actions/playlist_actions.dart';
import 'package:myoro_player/shared/widgets/shortcuts/actions/quit_action.dart';

class GlobalKeyboardShortcuts extends StatelessWidget {
  final Widget child;

  const GlobalKeyboardShortcuts({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Actions(
        actions: {
          QuitAction: CallbackAction<QuitAction>(
            onInvoke: (_) => exit(0),
          ),
          PlaylistActions: CallbackAction<PlaylistActions>(
            onInvoke: (instance) => instance.playlistAction == PlaylistActionsEnum.createNewPlaylist
                ? PlaylistActions.createNewPlaylist(context)
                : PlaylistActions.addPlaylist(context),
          ),
        },
        child: Shortcuts(
          shortcuts: {
            /// Quits the application
            LogicalKeySet(
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.keyQ,
            ): const QuitAction(),

            /// Opens a save dialog to create a new folder on the system and add the [Playlist] to the application
            LogicalKeySet(
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.keyN,
            ): const PlaylistActions(PlaylistActionsEnum.createNewPlaylist),

            // Opens a save dialog to open an existing folder on the system and add the [Playlist] to the application
            LogicalKeySet(
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.keyO,
            ): const PlaylistActions(PlaylistActionsEnum.addPlaylist),
          },
          child: child,
        ),
      );
}
