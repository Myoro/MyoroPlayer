import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/core/widgets/dividers/basic_divider.dart';
import 'package:myoro_player/mobile/screens/main_screen/widgets/main_screen_footer.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_state.dart';

import '../../../../shared/screens/main_screen/song_listing.dart';

final class MainScreenBody extends StatelessWidget {
  const MainScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlaylistListingBloc, PlaylistListingState>(
      listener: (context, state) => PlaylistListingBloc.handleSnackBars(context, state),
      child: const Column(
        children: [
          Expanded(child: SongListing()),
          BasicDivider(
            direction: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
          ),
          MainScreenFooter(),
        ],
      ),
    );
  }
}
