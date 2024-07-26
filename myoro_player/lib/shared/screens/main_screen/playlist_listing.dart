import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/core/controllers/base_drawer_controller.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_state.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_bloc.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_event.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_event.dart';
import 'package:myoro_player/shared/enums/playlist_listing_playlist_menu_enum.dart';
import 'package:myoro_player/core/constants.dart';
import 'package:myoro_player/core/controllers/model_resolver_controller.dart';
import 'package:myoro_player/core/design_system/image_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/helpers/platform_helper.dart';
import 'package:myoro_player/core/models/playlist.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/core/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/core/widgets/inputs/underline_input.dart';
import 'package:myoro_player/core/widgets/model_resolvers/model_resolver.dart';
import 'package:myoro_player/core/widgets/scrollbars/vertical_scroll_list.dart';

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
      child: BlocBuilder<PlaylistListingBloc, PlaylistListingState>(
        builder: (_, __) {
          return ModelResolver<List<Playlist>>(
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
                      // ignore: prefer_is_empty
                      if (playlists?.length != 0)
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

                                  if (KiwiContainer().resolve<PlatformHelper>().isMobile) {
                                    context.read<BaseDrawerController>().closeDrawer();
                                  }
                                },
                                onSecondaryTapDown: KiwiContainer().resolve<PlatformHelper>().isDesktop
                                    ? (details) => PlaylistListingPlaylistMenuEnum.showContextMenu(
                                          context,
                                          details,
                                          playlist,
                                          _playlistResolverController,
                                        )
                                    : null,
                                onLongPress: KiwiContainer().resolve<PlatformHelper>().isDesktop
                                    ? null
                                    : () => PlaylistListingPlaylistMenuEnum.showDropdownModal(
                                          context,
                                          playlist,
                                          _playlistResolverController,
                                        ),
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
