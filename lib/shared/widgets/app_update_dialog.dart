import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      barrierDismissible: true,
      builder: (ctx) => AppUpdateDialog(updateInfo: updateInfo),
    );
  }

  @override
  ConsumerState<AppUpdateDialog> createState() => _AppUpdateDialogState();
}

class _AppUpdateDialogState extends ConsumerState<AppUpdateDialog> {
  bool _isOpeningRelease = false;

  Future<void> _openGitHubRelease() async {
    setState(() => _isOpeningRelease = true);
    final service = ref.read(appUpdateServiceProvider);
    final opened =
        await service.openGitHubRelease(widget.updateInfo.releaseUrl);

    if (!mounted) return;
    setState(() => _isOpeningRelease = false);

    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat membuka tautan pembaruan GitHub.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.updateInfo;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                  constraints: const BoxConstraints(maxHeight: 160),
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
                          'Catatan Rilis (${info.releaseName}):',
                          style: AppTextStyles.bodyBold.copyWith(fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          info.releaseNotes.isNotEmpty
                              ? info.releaseNotes
                              : 'Pembaruan stabilitas dan peningkatan materi edukasi sains.',
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Action button: Open GitHub release
                ElevatedButton.icon(
                  onPressed: _isOpeningRelease ? null : _openGitHubRelease,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isOpeningRelease
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.open_in_new_rounded, size: 20),
                  label: Text(
                    _isOpeningRelease
                        ? 'Membuka GitHub...'
                        : 'Perbarui di GitHub',
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
                        onPressed:
                            _isOpeningRelease ? null : _openGitHubRelease,
                        icon: const Icon(Icons.open_in_new_rounded, size: 14),
                        label: Text(
                          'Info Rilis',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
