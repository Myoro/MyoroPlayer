import 'package:flutter/material.dart';
import 'package:myoro_player/shared/enums/divider_type_enum.dart';
import 'package:myoro_player/shared/widgets/base_divider.dart';

class PlaylistSideBar extends StatelessWidget {
  const PlaylistSideBar({super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            constraints: const BoxConstraints(
              minWidth: 200,
            ),
            color: Colors.pink.withOpacity(0.5),
          ),
          BaseDivider(
            dividerTypeEnum: DividerTypeEnum.vertical,
            padding: const EdgeInsets.all(5),
            onHorizontalDragUpdate: (details) => print('Bazinga'),
          ),
        ],
      );
}
