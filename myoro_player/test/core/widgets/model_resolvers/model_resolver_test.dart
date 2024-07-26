import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/core/helpers/platform_helper.dart';
import 'package:myoro_player/core/widgets/loading/loading_circle.dart';
import 'package:myoro_player/core/widgets/model_resolvers/model_resolver.dart';

import '../../../base_test_widget.dart';
import '../../../mocks/platform_helper_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  const text = 'Text';

  setUp(() => kiwiContainer.registerFactory<PlatformHelper>((_) => PlatformHelperMock.preConfigured()));
  tearDown(() => kiwiContainer.clear());

  testWidgets('Successful request ModelResolver widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: ModelResolver<String>(
          request: () async => text,
          builder: (_, text) => Text(text ?? ''),
        ),
      ),
    );

    expect(find.byType(ModelResolver<String>), findsOneWidget);
    expect(find.byWidgetPredicate((w) => w is Center && w.child is LoadingCircle), findsOneWidget);
    await tester.pump();
    expect(find.byWidgetPredicate((w) => w is Text && w.data == text), findsOneWidget);
  });

  testWidgets('Faulty request ModelResolver widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: ModelResolver<String>(
          request: () async => throw Exception(),
          builder: (_, text) => Text(text ?? ''),
        ),
      ),
    );

    expect(find.byType(ModelResolver<String>), findsOneWidget);
    expect(find.byWidgetPredicate((w) => w is Center && w.child is LoadingCircle), findsOneWidget);
    await tester.pump();
    expect(find.text('[ModelResolverBloc.ExecuteRequestEvent]: Error executing [request] provided.'), findsOneWidget);
  });
}
