import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';

class CoverMediaDialogs {
  static const String _introVideoUrl =
      'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/media-assets/video-pengantar-etnosains-terbaru.mp4';

  static Future<void> _openIntroVideo(BuildContext context) async {
    final uri = Uri.parse(_introVideoUrl);
    var opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      opened = await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video tidak dapat dibuka pada perangkat ini.'),
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
  late final VideoPlayerController _controller;
  late final Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(CoverMediaDialogs._introVideoUrl),
    );
    _initialization = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    if (!_controller.value.isInitialized) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final playerWidth = screenWidth > 624 ? 560.0 : screenWidth - 64;
    return SizedBox(
      width: playerWidth.clamp(280.0, 560.0),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: FutureBuilder<void>(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ColoredBox(
                color: AppColors.primaryDark,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            }
            if (snapshot.hasError || !_controller.value.isInitialized) {
              return _VideoLoadError(
                onOpenExternally: () => launchUrl(
                  Uri.parse(CoverMediaDialogs._introVideoUrl),
                  mode: LaunchMode.externalApplication,
                ),
              );
            }
            return GestureDetector(
              onTap: _togglePlayback,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(child: VideoPlayer(_controller)),
                  if (!_controller.value.isPlaying)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      padding: const EdgeInsets.only(top: 8),
                      colors: const VideoProgressColors(
                        playedColor: AppColors.warmTerracotta,
                        bufferedColor: Colors.white54,
                        backgroundColor: Colors.black38,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _VideoLoadError extends StatelessWidget {
  final VoidCallback onOpenExternally;

  const _VideoLoadError({required this.onOpenExternally});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primaryDark,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_disabled_rounded,
                  color: Colors.white, size: 30),
              const SizedBox(height: 8),
              const Text(
                'Video tidak dapat dimuat dari penyimpanan cloud.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onOpenExternally,
                child: const Text('Buka Video'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
