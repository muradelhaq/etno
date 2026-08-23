class AppUpdateInfo {
  final String currentVersion;
  final String latestVersion;
  final String releaseName;
  final String releaseNotes;
  final String apkDownloadUrl;
  final String apkFileName;
  final int apkSize;
  final String releaseUrl;
  final DateTime? publishedAt;
  final bool hasUpdate;

  AppUpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.releaseName,
    required this.releaseNotes,
    required this.apkDownloadUrl,
    required this.apkFileName,
    required this.apkSize,
    required this.releaseUrl,
    this.publishedAt,
    required this.hasUpdate,
  });
}
