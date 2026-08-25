import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/widgets/app_image.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';

class CoverMediaDialogs {
  static const String _introVideoUrl =
      'https://www.youtube.com/watch?v=bWxPpK7t5lE';
  static const String _introThumbnailUrl =
      'https://img.youtube.com/vi/bWxPpK7t5lE/hqdefault.jpg';

  static Future<void> _openIntroVideo(BuildContext context) async {
    final uri = Uri.parse(_introVideoUrl);
    var opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      opened = await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video YouTube tidak dapat dibuka pada perangkat ini.'),
          backgroundColor: AppColors.warmTerracotta,
        ),
      );
    }
  }

  static void showVideoPengantarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.movie_filter_rounded,
                color: AppColors.warmTerracotta),
            const SizedBox(width: 10),
            Text('Pengantar E-Modul', style: AppTextStyles.h3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _openIntroVideo(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const AppImage(
                      _introThumbnailUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Container(color: Colors.black38),
                    const Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: 62,
                    ),
                    const Positioned(
                      left: 10,
                      bottom: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            'Tonton di YouTube',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Selamat Datang di E-Modul Etnosains Fermentasi!',
              style: AppTextStyles.bodyBold.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              'Melalui media interaktif ini, kamu akan mengeksplorasi bagaimana kearifan nenek moyang dalam mengolah tempe, tape, tauco, kecap, dan oncom sebenarnya merupakan penerapan bioteknologi mikroba yang sangat canggih.',
              style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          ElevatedButton.icon(
            onPressed: () => _openIntroVideo(context),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Tonton Video'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/apersepsi');
            },
            child: const Text('Mulai Bab 1'),
          ),
        ],
      ),
    );
  }

  static void showQrDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.qr_code_scanner_rounded,
                color: AppColors.primaryGreen),
            const SizedBox(width: 10),
            Text('Akses Cepat Modul', style: AppTextStyles.h3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(Icons.qr_code_2,
                  size: 140, color: AppColors.primaryDark),
            ),
            const SizedBox(height: 12),
            Text(
              'Scan QR Code ini untuk membuka e-modul di perangkat ponsel atau tablet teman sekelasmu.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
