import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_event.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_event.dart';
import 'package:myoro_player/desktop/screens/main_screen/enums/main_screen_body_playlist_side_bar_context_menu_enum.dart';
import 'package:myoro_player/shared/constants.dart';
import 'package:myoro_player/shared/controllers/model_resolver_controller.dart';
import 'package:myoro_player/shared/design_system/image_design_system.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_state.dart';
import 'package:myoro_player/shared/enums/bloc_status_enum.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/helpers/snack_bar_helper.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/shared/widgets/dividers/resize_divider.dart';
import 'package:myoro_player/shared/widgets/headers/underline_header.dart';
import 'package:myoro_player/shared/widgets/inputs/underline_input.dart';
import 'package:myoro_player/shared/widgets/model_resolvers/model_resolver.dart';
import 'package:myoro_player/shared/widgets/scrollbars/vertical_scrollbar.dart';

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
  final _searchBarController = TextEditingController();
  final _filteredPlaylistsNotifier = ValueNotifier<List<Playlist>>([]);

  /// "Cached" songs from [MainScreenBodyPlaylistSideBarBloc]
  List<Playlist>? _playlists;

  @override
  void initState() {
    super.initState();
    _searchBarController.addListener(() => _searchPlaylists());
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    _filteredPlaylistsNotifier.dispose();
    super.dispose();
  }

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
                    _playlists = playlists;
                    _filteredPlaylistsNotifier.value = playlists ?? [];

                    return ValueListenableBuilder(
                      valueListenable: _filteredPlaylistsNotifier,
                      builder: (_, List<Playlist> filteredPlaylists, __) {
                        return VerticalScrollbar(
                          children: [
                            UnderlineInput(
                              controller: _searchBarController,
                              placeholder: 'Search playlists',
                            ),
                            ...filteredPlaylists.map(
                              (playlist) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: 5,
                                    bottom: playlist == filteredPlaylists.last ? 5 : 0,
                                  ),
                                  child: Tooltip(
                                    waitDuration: kTooltipWaitDuration,
                                    message: playlist.path,
                                    child: IconTextHoverButton(
                                      svgPath: playlist.image == null ? ImageDesignSystem.logo : null,
                                      localImagePath: playlist.image,
                                      iconSize: ImageSizeEnum.small.size + 10,
                                      text: playlist.name,
                                      padding: const EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                        left: 8,
                                        right: 5,
                                      ),
                                      onTap: () {
                                        BlocProvider.of<MainScreenBodyFooterBloc>(context).add(
                                          SetLoadedPlaylistEvent(
                                            playlist,
                                          ),
                                        );

                                        BlocProvider.of<MainScreenBodySongListBloc>(context).add(
                                          LoadPlaylistSongsEvent(
                                            playlist,
                                          ),
                                        );
                                      },
                                      onSecondaryTapDown: (details) {
                                        MainScreenBodyPlaylistSideBarContextMenuEnum.showContextMenu(
                                          context,
                                          details,
                                          playlist,
                                          _playlistResolverController,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
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
      SnackBarHelper.showErrorSnackBar(
        context,
        state.snackBarMessage!,
      );
    } else if (state.status == BlocStatusEnum.completed) {
      SnackBarHelper.showDialogSnackBar(
        context,
        state.snackBarMessage!,
      );
    }
  }
  // coverage:ignore-end

  void _searchPlaylists() {
    if (_searchBarController.text.isEmpty) {
      _filteredPlaylistsNotifier.value = _playlists ?? [];
      return;
    }

    final query = _searchBarController.text.toUpperCase();
    _filteredPlaylistsNotifier.value = (_playlists ?? [])
        .where(
          (playlist) => playlist.name.toUpperCase() == query,
        )
        .toList();
  }
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
