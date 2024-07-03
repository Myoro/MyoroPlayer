import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screens/main_screen/enums/main_screen_body_playlist_side_bar_context_menu_enum.dart';
import 'package:frontend/shared/controllers/model_resolver_controller.dart';
import 'package:kiwi/kiwi.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_state.dart';
import 'package:frontend/shared/enums/bloc_status_enum.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/helpers/snack_bar_helper.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/dividers/resize_divider.dart';
import 'package:frontend/shared/widgets/headers/underline_header.dart';
import 'package:frontend/shared/widgets/model_resolvers/model_resolver.dart';
import 'package:frontend/shared/widgets/scrollbars/vertical_scrollbar.dart';

final class MainScreenBodyPlaylistSideBar extends StatefulWidget {
  const MainScreenBodyPlaylistSideBar({super.key});

  @override
  State<MainScreenBodyPlaylistSideBar> createState() => _MainScreenBodyPlaylistSideBarState();
}

class _MainScreenBodyPlaylistSideBarState extends State<MainScreenBodyPlaylistSideBar> {
  final double _minWidth = 180;
  late final ValueNotifier<double> _widthNotifier;

  @override
  void initState() {
    super.initState();
    _widthNotifier = ValueNotifier<double>(_minWidth);
  }

  @override
  void dispose() {
    _widthNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _widthNotifier,
      builder: (context, width, child) {
        return Container(
          width: width,
          constraints: BoxConstraints(
            minWidth: _minWidth,
            maxWidth: MediaQuery.of(context).size.width - 300,
          ),
          child: Row(
            children: [
              const _Playlists(),
              _ResizeDivider(_widthNotifier),
            ],
          ),
        );
      },
    );
  }
}

final class _Playlists extends StatefulWidget {
  const _Playlists();

  @override
  State<_Playlists> createState() => _PlaylistsState();
}

class _PlaylistsState extends State<_Playlists> {
  final _playlistResolverController = ModelResolverController<List<Playlist>>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainScreenBodyPlaylistSideBarBloc, MainScreenBodyPlaylistSideBarState>(
      // coverage:ignore-start
      listener: (context, state) => _handleSnackBars(context, state),
      // coverage:ignore-end
      builder: (context, state) {
        return Expanded(
          child: Column(
            children: [
              const UnderlineHeader(header: 'Playlists'),
              Expanded(
                child: ModelResolver<List<Playlist>>(
                  controller: _playlistResolverController,
                  request: () async => await KiwiContainer().resolve<PlaylistService>().select(),
                  builder: (context, List<Playlist>? playlists) {
                    return VerticalScrollbar(
                      children: playlists!.map(
                        (playlist) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: 5,
                              bottom: playlist == playlists.last ? 5 : 0,
                            ),
                            child: IconTextHoverButton(
                              icon: Icons.music_note,
                              iconSize: ImageSizeEnum.small.size + 10,
                              text: playlist.name,
                              onTap: () {
                                if (kDebugMode) {
                                  print(playlist.path); // TODO
                                }
                              },
                              onSecondaryTapDown: (details) => MainScreenBodyPlaylistSideBarContextMenuEnum.showContextMenu(
                                context,
                                details,
                                playlist,
                                _playlistResolverController,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // coverage:ignore-start
  void _handleSnackBars(BuildContext context, MainScreenBodyPlaylistSideBarState state) {
    if (state.status == BlocStatusEnum.error) {
      KiwiContainer().resolve<SnackBarHelper>().showErrorSnackBar(
            context,
            state.snackBarMessage!,
          );
    } else if (state.status == BlocStatusEnum.completed) {
      KiwiContainer().resolve<SnackBarHelper>().showDialogSnackBar(
            context,
            state.snackBarMessage!,
          );
    }
  }
  // coverage:ignore-end
}

final class _ResizeDivider extends StatelessWidget {
  final ValueNotifier<double> widthNotifier;

  const _ResizeDivider(this.widthNotifier);

  @override
  Widget build(BuildContext context) {
    return ResizeDivider(
      direction: Axis.vertical,
      resizeCallback: (details) => widthNotifier.value += details.delta.dx,
      padding: const EdgeInsets.only(
        top: 40,
        bottom: 15,
      ),
    );
  }
}
