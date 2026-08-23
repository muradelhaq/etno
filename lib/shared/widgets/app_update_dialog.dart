import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/text_styles.dart';
import '../models/app_update_info.dart';
import '../services/app_update_service.dart';

class AppUpdateDialog extends ConsumerStatefulWidget {
  final AppUpdateInfo updateInfo;

  const AppUpdateDialog({
    super.key,
    required this.updateInfo,
  });

  static Future<void> show(BuildContext context, AppUpdateInfo updateInfo) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AppUpdateDialog(updateInfo: updateInfo),
    );
  }

  @override
  ConsumerState<AppUpdateDialog> createState() => _AppUpdateDialogState();
}

class _AppUpdateDialogState extends ConsumerState<AppUpdateDialog> {
  bool _isDownloading = false;
  double _progress = 0.0;
  int _receivedBytes = 0;
  int _totalBytes = 0;
  String? _errorMessage;
  bool _downloadFinished = false;

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String? _downloadedFilePath;

  Future<void> _startUpdate() async {
    setState(() {
      _isDownloading = true;
      _errorMessage = null;
      _progress = 0.0;
      _downloadFinished = false;
      _downloadedFilePath = null;
    });

    final updateService = ref.read(appUpdateServiceProvider);

    await updateService.downloadAndInstall(
      apkUrl: widget.updateInfo.apkDownloadUrl,
      fileName: widget.updateInfo.apkFileName,
      onProgress: (received, total) {
        if (!mounted) return;
        setState(() {
          _receivedBytes = received;
          _totalBytes = total;
          if (total > 0) {
            _progress = received / total;
          }
        });
      },
      onComplete: (filePath) {
        if (!mounted) return;
        setState(() {
          _isDownloading = false;
          _downloadFinished = true;
          _downloadedFilePath = filePath;
        });
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _isDownloading = false;
          _errorMessage = error;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.updateInfo;

    return PopScope(
      canPop: !_isDownloading,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header icon & title
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.sageLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.system_update_rounded,
                      color: AppColors.primaryGreen,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Pembaruan Tersedia!',
                    style: AppTextStyles.h2.copyWith(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.warmCream,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.goldenYellow),
                    ),
                    child: Text(
                      'v${info.currentVersion} ➔ v${info.latestVersion}',
                      style: AppTextStyles.tagText.copyWith(
                        color: AppColors.terracottaDark,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Release notes section
                Container(
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(maxHeight: 140),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catatan Rilis:',
                          style: AppTextStyles.bodyBold.copyWith(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          info.releaseNotes.isNotEmpty
                              ? info.releaseNotes
                              : 'Pembaruan stabilitas dan penambahan fitur aplikasi E-Modul Etnosains.',
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Downloading progress or error status
                if (_isDownloading) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _totalBytes > 0 ? _progress : null,
                      minHeight: 10,
                      backgroundColor: AppColors.sageLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _totalBytes > 0
                            ? '${(_progress * 100).toStringAsFixed(0)}%'
                            : 'Mengunduh...',
                        style: AppTextStyles.bodyBold.copyWith(fontSize: 12),
                      ),
                      Text(
                        _totalBytes > 0
                            ? '${_formatBytes(_receivedBytes)} / ${_formatBytes(_totalBytes)}'
                            : _formatBytes(_receivedBytes),
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ] else if (_downloadFinished) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: AppColors.successGreen, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Unduhan selesai! Membuka installer...',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ] else if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: AppColors.errorRed, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.errorRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action buttons
                if (!_isDownloading) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_downloadFinished && _downloadedFilePath != null) {
                        ref
                            .read(appUpdateServiceProvider)
                            .openDownloadedApk(_downloadedFilePath!);
                      } else {
                        _startUpdate();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(
                      _downloadFinished
                          ? Icons.install_mobile_rounded
                          : Icons.download_rounded,
                    ),
                    label: Text(
                      _downloadFinished
                          ? 'Pasang Pembaruan (Buka Installer)'
                          : (_errorMessage != null
                              ? 'Coba Unduh Lagi'
                              : 'Update Sekarang'),
                      style: AppTextStyles.buttonText.copyWith(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Nanti Saja',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (info.releaseUrl.isNotEmpty)
                        TextButton.icon(
                          onPressed: () async {
                            final uri = Uri.parse(info.releaseUrl);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          icon: const Icon(Icons.open_in_new_rounded, size: 14),
                          label: Text(
                            'Lihat di GitHub',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
