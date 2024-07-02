import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/controllers/model_resolver_controller.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/widgets/inputs/outline_input.dart';
import 'package:frontend/shared/widgets/modals/rename_playlist_modal.dart';

import '../../../base_test_widget.dart';

void main() {
  const key = Key('');

  testWidgets('RenamePlaylistModal widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: Builder(
          builder: (context) {
            return GestureDetector(
              key: key,
              onTap: () {
                RenamePlaylistModal.show(
                  context,
                  Playlist.mock,
                  ModelResolverController<List<Playlist>>(),
                );
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.byKey(key));
    await tester.pump();

    expect(find.byType(RenamePlaylistModal), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is Column && w.children.length == 1 && w.children.first is OutlineInput,
      ),
      findsOneWidget,
    );
  });
}
