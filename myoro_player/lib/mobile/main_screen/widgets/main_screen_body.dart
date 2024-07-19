import 'package:flutter/material.dart';

import '../../../shared/widgets/screens/main_screen/song_listing.dart';

final class MainScreenBody extends StatelessWidget {
  const MainScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SongListing();
  }
}
