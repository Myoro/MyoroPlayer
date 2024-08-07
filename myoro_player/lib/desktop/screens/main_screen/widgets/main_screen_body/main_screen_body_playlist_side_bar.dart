import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_state.dart';
import 'package:myoro_player/core/widgets/dividers/resize_divider.dart';
import 'package:myoro_player/core/widgets/headers/underline_header.dart';
import 'package:myoro_player/shared/screens/main_screen/playlist_listing.dart';

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

final class _Playlists extends StatelessWidget {
  const _Playlists();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlaylistListingBloc, PlaylistListingState>(
      // coverage:ignore-start
      listener: (context, state) => PlaylistListingBloc.handleSnackBars(context, state),
      // coverage:ignore-end
      builder: (context, state) {
        return const Expanded(
          child: Column(
            children: [
              UnderlineHeader(header: 'Playlists'),
              PlaylistListing(),
            ],
          ),
        );
      },
    );
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
