import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_update_info.dart';

final appUpdateServiceProvider = Provider<AppUpdateService>((ref) {
  return AppUpdateService();
});

class AppUpdateService {
  static const String repoOwner = 'muradelhaq';
  static const String repoName = 'etno';
  static const String githubApiLatestUrl =
      'https://api.github.com/repos/$repoOwner/$repoName/releases/latest';

  static const String playStorePackageName = 'com.etnosains.e_modul_etnosains';
  static const String playStoreMarketUrl =
      'market://details?id=$playStorePackageName';
  static const String playStoreWebUrl =
      'https://play.google.com/store/apps/details?id=$playStorePackageName';

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/vnd.github.v3+json',
      },
    ),
  );

  /// Check GitHub Releases for newer version
  Future<AppUpdateInfo?> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final currentBuildNumber = packageInfo.buildNumber;
      final fullCurrentVersion = '$currentVersion+$currentBuildNumber';

      final response = await _dio.get(githubApiLatestUrl);
      if (response.statusCode != 200 || response.data == null) {
        return null;
      }

      final data = response.data as Map<String, dynamic>;
      final tagName = (data['tag_name'] ?? '') as String;
      final releaseName = (data['name'] ?? tagName) as String;
      final releaseNotes =
          (data['body'] ?? 'Pembaruan aplikasi terbaru.') as String;
      final releaseUrl = (data['html_url'] ?? '') as String;
      final publishedAtStr = data['published_at'] as String?;
      final publishedAt =
          publishedAtStr != null ? DateTime.tryParse(publishedAtStr) : null;

      final cleanLatestVersion =
          tagName.replaceFirst(RegExp(r'^[vV]'), '').trim();

      final hasUpdate = isNewerVersion(cleanLatestVersion, currentVersion);

      return AppUpdateInfo(
        currentVersion: fullCurrentVersion,
        latestVersion: cleanLatestVersion,
        releaseName:
            releaseName.isNotEmpty ? releaseName : 'Versi $cleanLatestVersion',
        releaseNotes: releaseNotes,
        apkDownloadUrl: '',
        apkFileName: '',
        apkSize: 0,
        releaseUrl: releaseUrl,
        publishedAt: publishedAt,
        hasUpdate: hasUpdate,
      );
    } catch (e) {
      debugPrint('AppUpdateService.checkForUpdate error: $e');
      return null;
    }
  }

  /// Compares whether latestVersion > currentVersion
  bool isNewerVersion(String latestStr, String currentStr) {
    try {
      final cleanLatest = latestStr.replaceFirst(RegExp(r'^[vV]'), '').trim();
      final cleanCurrent = currentStr.replaceFirst(RegExp(r'^[vV]'), '').trim();

      final latestParts = cleanLatest.split('+');
      final currentParts = cleanCurrent.split('+');

      final latestNums = latestParts[0]
          .split('.')
          .map((e) => int.tryParse(e) ?? 0)
          .toList();
      final currentNums = currentParts[0]
          .split('.')
          .map((e) => int.tryParse(e) ?? 0)
          .toList();

      while (latestNums.length < 3) {
        latestNums.add(0);
      }
      while (currentNums.length < 3) {
        currentNums.add(0);
      }

      for (int i = 0; i < 3; i++) {
        if (latestNums[i] > currentNums[i]) return true;
        if (latestNums[i] < currentNums[i]) return false;
      }

      if (latestParts.length > 1 && currentParts.length > 1) {
        final latestBuild = int.tryParse(latestParts[1]) ?? 0;
        final currentBuild = int.tryParse(currentParts[1]) ?? 0;
        return latestBuild > currentBuild;
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  /// Open Google Play Store listing (or fallback to web URL)
  Future<bool> openPlayStore() async {
    final marketUri = Uri.parse(playStoreMarketUrl);
    final webUri = Uri.parse(playStoreWebUrl);

    try {
      if (await canLaunchUrl(marketUri)) {
        return await launchUrl(marketUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching market uri: $e');
    }

    try {
      if (await canLaunchUrl(webUri)) {
        return await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching web uri: $e');
    }

    return false;
  }
}
