import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/extensions/duration_extension.dart';

void main() {
  test('DurationExtension.hhMmSsFormat unit test.', () {
    const durationOne = Duration(hours: 4, minutes: 20);
    const durationTwo = Duration(minutes: 4, seconds: 20);
    expect(durationOne.hhMmSsFormat, '04:20:00');
    expect(durationTwo.hhMmSsFormat, '04:20');
  });
}
