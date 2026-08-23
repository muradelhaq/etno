import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
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
      final releaseNotes = (data['body'] ?? 'Pembaruan aplikasi terbaru.') as String;
      final releaseUrl = (data['html_url'] ?? '') as String;
      final publishedAtStr = data['published_at'] as String?;
      final publishedAt =
          publishedAtStr != null ? DateTime.tryParse(publishedAtStr) : null;

      final cleanLatestVersion =
          tagName.replaceFirst(RegExp(r'^[vV]'), '').trim();

      // Find APK asset
      final assets = data['assets'] as List<dynamic>? ?? [];
      String apkDownloadUrl = '';
      String apkFileName = 'app-release.apk';
      int apkSize = 0;

      for (final asset in assets) {
        final name = (asset['name'] ?? '') as String;
        if (name.toLowerCase().endsWith('.apk')) {
          apkDownloadUrl = (asset['browser_download_url'] ?? '') as String;
          apkFileName = name;
          apkSize = (asset['size'] as num?)?.toInt() ?? 0;
          break;
        }
      }

      // If no APK asset directly found, fallback to release url
      if (apkDownloadUrl.isEmpty) {
        apkDownloadUrl = releaseUrl;
      }

      final hasUpdate = isNewerVersion(cleanLatestVersion, currentVersion);

      return AppUpdateInfo(
        currentVersion: fullCurrentVersion,
        latestVersion: cleanLatestVersion,
        releaseName: releaseName.isNotEmpty ? releaseName : 'Versi $cleanLatestVersion',
        releaseNotes: releaseNotes,
        apkDownloadUrl: apkDownloadUrl,
        apkFileName: apkFileName,
        apkSize: apkSize,
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

  /// Download the APK and trigger Android Package Installer
  Future<void> downloadAndInstall({
    required String apkUrl,
    required String fileName,
    required void Function(int received, int total) onProgress,
    required void Function(String filePath) onComplete,
    required void Function(String error) onError,
  }) async {
    try {
      if (kIsWeb) {
        // On web, open the download URL directly
        final uri = Uri.parse(apkUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          onComplete(apkUrl);
        } else {
          onError('Tidak dapat membuka tautan unduhan.');
        }
        return;
      }

      if (Platform.isAndroid) {
        final tempDir = await getTemporaryDirectory();
        final savePath = '${tempDir.path}/$fileName';

        final file = File(savePath);
        if (await file.exists()) {
          await file.delete();
        }

        final dio = Dio();
        await dio.download(
          apkUrl,
          savePath,
          onReceiveProgress: onProgress,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: true,
          ),
        );

        onComplete(savePath);

        // Prompt system installer
        final result = await OpenFilex.open(
          savePath,
          type: 'application/vnd.android.package-archive',
        );

        if (result.type != ResultType.done) {
          debugPrint('OpenFilex error: ${result.message}');
          if (result.type == ResultType.permissionDenied) {
            onError('Izin instalasi diperlukan. Buka pengaturan aplikasi untuk mengizinkan "Instal aplikasi tidak dikenal".');
            return;
          }
        }
      } else {
        // Fallback on desktop / iOS
        final uri = Uri.parse(apkUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          onComplete(apkUrl);
        } else {
          onError('Platform tidak mendukung instalasi APK langsung.');
        }
      }
    } catch (e) {
      debugPrint('Error downloading APK: $e');
      onError('Gagal mengunduh file update: $e');
    }
  }

  /// Membuka kembali installer untuk file APK yang sudah diunduh
  Future<void> openDownloadedApk(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await OpenFilex.open(
          filePath,
          type: 'application/vnd.android.package-archive',
        );
      }
    } catch (e) {
      debugPrint('Error opening APK installer: $e');
    }
  }
}
