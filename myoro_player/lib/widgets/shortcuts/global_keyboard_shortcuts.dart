import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myoro_player/widgets/shortcuts/actions/new_playlist_shortcut_action.dart';
import 'package:myoro_player/widgets/shortcuts/actions/quit_action.dart';

class GlobalKeyboardShortcuts extends StatelessWidget {
  final Widget child;

  const GlobalKeyboardShortcuts({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Actions(
        actions: {
          QuitAction: CallbackAction<QuitAction>(
            onInvoke: (_) => exit(0),
          ),
          NewPlaylistAction: CallbackAction<NewPlaylistAction>(
            onInvoke: (_) => NewPlaylistAction.newPlaylist(),
          ),
        },
        child: Shortcuts(
          shortcuts: {
            LogicalKeySet(
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.keyQ,
            ): const QuitAction(),
            LogicalKeySet(
              LogicalKeyboardKey.control,
              LogicalKeyboardKey.keyN,
            ): const NewPlaylistAction(),
          },
          child: child,
        ),
      );
}
