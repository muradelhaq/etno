import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/shared/services/app_update_service.dart';
import 'package:e_modul_etnosains/shared/widgets/app_update_dialog.dart';

class DrawerVersionFooter extends ConsumerWidget {
  const DrawerVersionFooter({super.key});

  Future<void> _handleManualUpdateCheck(
      BuildContext context, WidgetRef ref) async {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Memeriksa pembaruan aplikasi ke GitHub...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final updateService = ref.read(appUpdateServiceProvider);
      final info = await updateService.checkForUpdate();

      if (!context.mounted) return;

      if (info != null && info.hasUpdate) {
        AppUpdateDialog.show(context, info);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primaryGreen,
            content: Text(
              info != null
                  ? 'Aplikasi sudah versi terbaru (${info.currentVersion})'
                  : 'Aplikasi sudah versi terbaru.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.errorRed,
          content: Text('Gagal memeriksa pembaruan: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.data?.version ?? '1.0.3';
              return Text(
                'v$version (Etnosains)',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
              );
            },
          ),
          InkWell(
            onTap: () => _handleManualUpdateCheck(context, ref),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sync_rounded,
                      size: 14, color: AppColors.primaryGreen),
                  const SizedBox(width: 4),
                  Text(
                    'Cek Update',
                    style: AppTextStyles.tagText.copyWith(
                      color: AppColors.primaryGreen,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
