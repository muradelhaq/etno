import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';

class CoverMediaDialogs {
  static const String _introVideoUrl =
      'https://www.youtube.com/watch?v=bWxPpK7t5lE';

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
            const _IntroVideoPlayer(),
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

class _IntroVideoPlayer extends StatefulWidget {
  const _IntroVideoPlayer();

  @override
  State<_IntroVideoPlayer> createState() => _IntroVideoPlayerState();
}

class _IntroVideoPlayerState extends State<_IntroVideoPlayer> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: 'bWxPpK7t5lE',
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        strictRelatedVideos: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final playerWidth = screenWidth > 624 ? 560.0 : screenWidth - 64;
    return SizedBox(
      width: playerWidth.clamp(280.0, 560.0),
      child: YoutubePlayerScaffold(
        controller: _controller,
        aspectRatio: 16 / 9,
        builder: (context, player) => YoutubeValueBuilder(
          controller: _controller,
          builder: (context, value) {
            if (value.hasError) {
              return Container(
                color: AppColors.primaryDark,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.play_disabled_rounded,
                        color: Colors.white, size: 30),
                    const SizedBox(height: 8),
                    const Text(
                      'Video tidak tersedia di pemutar tersemat.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => launchUrl(
                        Uri.parse(CoverMediaDialogs._introVideoUrl),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: const Text('Buka di YouTube'),
                    ),
                  ],
                ),
              );
            }
            return player;
          },
        ),
      ),
    );
  }
}
