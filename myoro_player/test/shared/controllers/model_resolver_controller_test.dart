import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/blocs/model_resolver_bloc/model_resolver_bloc.dart';
import 'package:myoro_player/shared/controllers/model_resolver_controller.dart';

void main() {
  test('ModelResolverController.refresh', () {
    final controller = ModelResolverController<String>();
    controller.bloc = ModelResolverBloc<String>();
    controller.request = () async => 'Response';
    controller.refresh();
  });
}
