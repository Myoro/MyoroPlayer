import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_bloc.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_event.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_event.dart';
import 'package:myoro_player/desktop/screens/main_screen/enums/main_screen_body_playlist_side_bar_context_menu_enum.dart';
import 'package:myoro_player/shared/constants.dart';
import 'package:myoro_player/shared/controllers/model_resolver_controller.dart';
import 'package:myoro_player/shared/design_system/image_design_system.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/shared/widgets/inputs/underline_input.dart';
import 'package:myoro_player/shared/widgets/model_resolvers/model_resolver.dart';
import 'package:myoro_player/shared/widgets/scrollbars/vertical_scroll_list.dart';

/// BloC for listing the [Playlist]s that the user will see
final class PlaylistListing extends StatefulWidget {
  const PlaylistListing({super.key});

  @override
  State<PlaylistListing> createState() => _PlaylistListingState();
}

class _PlaylistListingState extends State<PlaylistListing> {
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
    return Expanded(
      child: ModelResolver<List<Playlist>>(
        controller: _playlistResolverController,
        request: () async => await KiwiContainer().resolve<PlaylistService>().select(),
        builder: (context, List<Playlist>? playlists) {
          _playlists = playlists;
          _filteredPlaylistsNotifier.value = playlists ?? [];

          return ValueListenableBuilder(
            valueListenable: _filteredPlaylistsNotifier,
            builder: (_, List<Playlist> filteredPlaylists, __) {
              return VerticalScrollList(
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
                              BlocProvider.of<SongControlsBloc>(context).add(
                                SetLoadedPlaylistEvent(
                                  playlist,
                                ),
                              );

                              BlocProvider.of<SongListingBloc>(context).add(
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
    );
  }

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
