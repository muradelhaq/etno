import 'package:e_modul_etnosains/shared/services/app_update_service.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/link.dart';
// Exercise the plugin boundary without opening an actual browser.
// ignore: depend_on_referenced_packages
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class FakeLauncher extends UrlLauncherPlatform {
  @override
  LinkDelegate? get linkDelegate => null;

  String? openedUrl;
  bool result = true;
  bool throws = false;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    openedUrl = url;
    if (throws) throw StateError('No browser');
    return result;
  }
}

void main() {
  late FakeLauncher launcher;
  setUp(() {
    final original = UrlLauncherPlatform.instance;
    launcher = FakeLauncher();
    UrlLauncherPlatform.instance = launcher;
    addTearDown(() => UrlLauncherPlatform.instance = original);
  });

  test('update opens the matching GitHub release', () async {
    const url = 'https://github.com/muradelhaq/etno/releases/tag/v1.2.19';
    expect(await AppUpdateService().openGitHubRelease(url), isTrue);
    expect(launcher.openedUrl, url);
  });

  test('missing or non-repository URL falls back to GitHub latest', () async {
    for (final url in ['', 'https://play.google.com/store/apps/details?id=x']) {
      await AppUpdateService().openGitHubRelease(url);
      expect(launcher.openedUrl,
          'https://github.com/muradelhaq/etno/releases/latest');
    }
  });

  test('browser failure is reported without throwing', () async {
    launcher.result = false;
    expect(await AppUpdateService().openGitHubRelease(''), isFalse);
    launcher.throws = true;
    expect(await AppUpdateService().openGitHubRelease(''), isFalse);
  });
}
