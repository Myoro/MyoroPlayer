import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myoro_player/core/enums/platform_enum.dart';
import 'package:myoro_player/core/helpers/platform_helper.dart';

final class PlatformHelperMock extends Mock implements PlatformHelper {
  static PlatformHelperMock preConfigured({PlatformEnum? platform}) {
    final mock = PlatformHelperMock();
    platform = platform ?? PlatformEnum.values[faker.randomGenerator.integer(PlatformEnum.values.length)];
    when(() => mock.isDesktop).thenReturn(platform.isDesktop);
    when(() => mock.isMobile).thenReturn(platform.isMobile);
    when(() => mock.isWindows).thenReturn(platform.isWindows);
    when(() => mock.slash).thenReturn(platform.isWindows ? '\\' : '/');
    return mock;
  }

  static PlatformHelperMock preConfiguredMobile() {
    final mock = PlatformHelperMock();
    final platform = faker.randomGenerator.boolean() ? PlatformEnum.android : PlatformEnum.ios;
    when(() => mock.isDesktop).thenReturn(platform.isDesktop);
    when(() => mock.isMobile).thenReturn(platform.isMobile);
    when(() => mock.isWindows).thenReturn(platform.isWindows);
    when(() => mock.slash).thenReturn('');
    return mock;
  }

  static PlatformHelperMock preConfiguredDesktop() {
    final mock = PlatformHelperMock();
    final platform = [
      PlatformEnum.windows,
      PlatformEnum.linux,
      PlatformEnum.mac,
    ][faker.randomGenerator.integer(3)];
    when(() => mock.isDesktop).thenReturn(platform.isDesktop);
    when(() => mock.isMobile).thenReturn(platform.isMobile);
    when(() => mock.isWindows).thenReturn(platform.isWindows);
    when(() => mock.slash).thenReturn('');
    return mock;
  }
}
