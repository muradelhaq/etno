import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/services/media_sync_service.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/shared/services/app_audio_service.dart';

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
        content: SingleChildScrollView(
          child: Column(
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
          ElevatedButton.icon(
            onPressed: () => _openIntroVideo(context),
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text('Buka di Browser'),
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

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (duration.inHours > 0) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
  return '$minutes:$seconds';
}

class _IntroVideoPlayer extends ConsumerStatefulWidget {
  const _IntroVideoPlayer();

  @override
  ConsumerState<_IntroVideoPlayer> createState() => _IntroVideoPlayerState();
}

class _IntroVideoPlayerState extends ConsumerState<_IntroVideoPlayer> {
  late final VideoPlayerController _controller;
  late final Future<void> _initialization;
  bool _showControls = true;
  Timer? _hideControlsTimer;
  bool _hasPausedAudioForPlayback = false;

  static const List<double> _playbackSpeeds = [1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _initialization = _initVideoController();
  }

  Future<void> _initVideoController() async {
    final cachedFile = await MediaSyncService.getLocalVideoFile(
      CoverMediaDialogs._introVideoUrl,
    );
    if (cachedFile != null && await cachedFile.exists()) {
      _controller = VideoPlayerController.file(cachedFile);
    } else {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(CoverMediaDialogs._introVideoUrl),
      );
      unawaited(MediaSyncService.cacheVideo(CoverMediaDialogs._introVideoUrl));
    }
    await _controller.initialize();
    _controller.addListener(_videoListener);
    if (mounted) setState(() {});
  }

  void _videoListener() {
    final isPlaying = _controller.value.isPlaying;
    if (isPlaying && !_hasPausedAudioForPlayback) {
      _hasPausedAudioForPlayback = true;
      ref.read(backgroundAudioProvider.notifier).pauseForMedia();
    } else if (!isPlaying && _hasPausedAudioForPlayback) {
      _hasPausedAudioForPlayback = false;
      ref.read(backgroundAudioProvider.notifier).resumeFromMedia();
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    if (_hasPausedAudioForPlayback) {
      _hasPausedAudioForPlayback = false;
      ref.read(backgroundAudioProvider.notifier).resumeFromMedia();
    }
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    if (_controller.value.isPlaying) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && _controller.value.isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _togglePlayback() {
    if (!_controller.value.isInitialized) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _showControls = true;
        _hideControlsTimer?.cancel();
      } else {
        _controller.play();
        _startHideControlsTimer();
      }
    });
  }

  void _seekRelative(int seconds) {
    if (!_controller.value.isInitialized) return;
    final current = _controller.value.position;
    final target = current + Duration(seconds: seconds);
    final clamped = target < Duration.zero
        ? Duration.zero
        : target > _controller.value.duration
            ? _controller.value.duration
            : target;
    _controller.seekTo(clamped);
    _startHideControlsTimer();
  }

  void _cycleSpeed() {
    if (!_controller.value.isInitialized) return;
    final currentSpeed = _controller.value.playbackSpeed;
    int currentIndex = _playbackSpeeds.indexOf(currentSpeed);
    int nextIndex = (currentIndex + 1) % _playbackSpeeds.length;
    final nextSpeed = _playbackSpeeds[nextIndex];
    _controller.setPlaybackSpeed(nextSpeed);
    setState(() {});
    _startHideControlsTimer();
  }

  Future<void> _openFullscreen() async {
    if (!_controller.value.isInitialized) return;
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => _FullscreenVideoPlayerPage(controller: _controller),
      ),
    );
    if (mounted) {
      setState(() {
        _showControls = true;
      });
      _startHideControlsTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final playerWidth = screenWidth > 624 ? 560.0 : screenWidth - 64;
    return SizedBox(
      width: playerWidth.clamp(280.0, 560.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderSubtle),
          ),
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

                final isPlaying = _controller.value.isPlaying;
                final position = _controller.value.position;
                final duration = _controller.value.duration;
                final speed = _controller.value.playbackSpeed;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _showControls = !_showControls;
                    });
                    if (_showControls) {
                      _startHideControlsTimer();
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      ),
                      // Controls overlay
                      AnimatedOpacity(
                        opacity: _showControls ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: IgnorePointer(
                          ignoring: !_showControls,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black54,
                                  Colors.transparent,
                                  Colors.black87,
                                ],
                                stops: [0.0, 0.45, 1.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Center playback action buttons
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        tooltip: 'Mundur 10 detik',
                                        icon: const Icon(
                                          Icons.replay_10_rounded,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        onPressed: () => _seekRelative(-10),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: _togglePlayback,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryGreen
                                                .withValues(alpha: 0.85),
                                            shape: BoxShape.circle,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black45,
                                                blurRadius: 8,
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            isPlaying
                                                ? Icons.pause_rounded
                                                : Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: 34,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        tooltip: 'Maju 10 detik',
                                        icon: const Icon(
                                          Icons.forward_10_rounded,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                        onPressed: () => _seekRelative(10),
                                      ),
                                    ],
                                  ),
                                ),
                                // Bottom controls bar
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          children: [
                                            // Play/Pause icon button
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              iconSize: 22,
                                              icon: Icon(
                                                isPlaying
                                                    ? Icons.pause_rounded
                                                    : Icons.play_arrow_rounded,
                                                color: Colors.white,
                                              ),
                                              onPressed: _togglePlayback,
                                            ),
                                            const SizedBox(width: 8),
                                            // Timestamp
                                            Text(
                                              '${_formatDuration(position)} / ${_formatDuration(duration)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Spacer(),
                                            // Speed button (Percepat)
                                            InkWell(
                                              onTap: _cycleSpeed,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 7,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white24,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: speed != 1.0
                                                        ? AppColors.goldenYellow
                                                        : Colors.white30,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                      Icons.speed_rounded,
                                                      size: 13,
                                                      color: Colors.white,
                                                    ),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      '${speed == 1.0 ? '1' : speed}x',
                                                      style: TextStyle(
                                                        color: speed != 1.0
                                                            ? AppColors
                                                                .goldenYellow
                                                            : Colors.white,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // Fullscreen button
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                              iconSize: 22,
                                              tooltip: 'Fullscreen',
                                              icon: const Icon(
                                                Icons.fullscreen_rounded,
                                                color: Colors.white,
                                              ),
                                              onPressed: _openFullscreen,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      VideoProgressIndicator(
                                        _controller,
                                        allowScrubbing: true,
                                        padding: const EdgeInsets.only(
                                            top: 4, bottom: 4),
                                        colors: const VideoProgressColors(
                                          playedColor: AppColors.warmTerracotta,
                                          bufferedColor: Colors.white38,
                                          backgroundColor: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _FullscreenVideoPlayerPage extends StatefulWidget {
  final VideoPlayerController controller;

  const _FullscreenVideoPlayerPage({required this.controller});

  @override
  State<_FullscreenVideoPlayerPage> createState() =>
      _FullscreenVideoPlayerPageState();
}

class _FullscreenVideoPlayerPageState
    extends State<_FullscreenVideoPlayerPage> {
  bool _showControls = true;
  Timer? _hideControlsTimer;

  static const List<double> _playbackSpeeds = [1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_videoListener);
    _enterFullscreen();
    _startHideControlsTimer();
  }

  Future<void> _enterFullscreen() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
        DeviceOrientation.portraitUp,
      ]);
    } catch (_) {}
  }

  Future<void> _exitFullscreen() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (_) {}
  }

  void _videoListener() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    widget.controller.removeListener(_videoListener);
    _exitFullscreen();
    super.dispose();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    if (widget.controller.value.isPlaying) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && widget.controller.value.isPlaying) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _togglePlayback() {
    if (!widget.controller.value.isInitialized) return;
    setState(() {
      if (widget.controller.value.isPlaying) {
        widget.controller.pause();
        _showControls = true;
        _hideControlsTimer?.cancel();
      } else {
        widget.controller.play();
        _startHideControlsTimer();
      }
    });
  }

  void _seekRelative(int seconds) {
    if (!widget.controller.value.isInitialized) return;
    final current = widget.controller.value.position;
    final target = current + Duration(seconds: seconds);
    final clamped = target < Duration.zero
        ? Duration.zero
        : target > widget.controller.value.duration
            ? widget.controller.value.duration
            : target;
    widget.controller.seekTo(clamped);
    _startHideControlsTimer();
  }

  void _cycleSpeed() {
    if (!widget.controller.value.isInitialized) return;
    final currentSpeed = widget.controller.value.playbackSpeed;
    int currentIndex = _playbackSpeeds.indexOf(currentSpeed);
    int nextIndex = (currentIndex + 1) % _playbackSpeeds.length;
    final nextSpeed = _playbackSpeeds[nextIndex];
    widget.controller.setPlaybackSpeed(nextSpeed);
    setState(() {});
    _startHideControlsTimer();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final isPlaying = controller.value.isPlaying;
    final position = controller.value.position;
    final duration = controller.value.duration;
    final speed = controller.value.playbackSpeed;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _showControls = !_showControls;
            });
            if (_showControls) {
              _startHideControlsTimer();
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                ),
              ),
              // Controls overlay
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: !_showControls,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black87,
                          Colors.transparent,
                          Colors.black87,
                        ],
                        stops: [0.0, 0.45, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Top Bar: Back / Exit Fullscreen button & Title
                        Positioned(
                          top: 12,
                          left: 12,
                          right: 12,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Pengantar E-Modul Etnosains',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(
                                  Icons.fullscreen_exit_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                tooltip: 'Keluar Layar Penuh',
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        ),
                        // Center Playback Buttons
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Mundur 10 detik',
                                icon: const Icon(
                                  Icons.replay_10_rounded,
                                  color: Colors.white,
                                  size: 38,
                                ),
                                onPressed: () => _seekRelative(-10),
                              ),
                              const SizedBox(width: 24),
                              GestureDetector(
                                onTap: _togglePlayback,
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen
                                        .withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black54,
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 44,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              IconButton(
                                tooltip: 'Maju 10 detik',
                                icon: const Icon(
                                  Icons.forward_10_rounded,
                                  color: Colors.white,
                                  size: 38,
                                ),
                                onPressed: () => _seekRelative(10),
                              ),
                            ],
                          ),
                        ),
                        // Bottom Bar: Scrubbing, Timestamps, Speed & Exit Fullscreen
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 12,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              VideoProgressIndicator(
                                controller,
                                allowScrubbing: true,
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                colors: const VideoProgressColors(
                                  playedColor: AppColors.warmTerracotta,
                                  bufferedColor: Colors.white38,
                                  backgroundColor: Colors.white24,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    iconSize: 26,
                                    icon: Icon(
                                      isPlaying
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      color: Colors.white,
                                    ),
                                    onPressed: _togglePlayback,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${_formatDuration(position)} / ${_formatDuration(duration)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  // Speed selector (Percepat)
                                  InkWell(
                                    onTap: _cycleSpeed,
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        border: Border.all(
                                          color: speed != 1.0
                                              ? AppColors.goldenYellow
                                              : Colors.white38,
                                          width: 1.2,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.speed_rounded,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            '${speed == 1.0 ? '1' : speed}x Kecepatan',
                                            style: TextStyle(
                                              color: speed != 1.0
                                                  ? AppColors.goldenYellow
                                                  : Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    iconSize: 26,
                                    tooltip: 'Keluar Layar Penuh',
                                    icon: const Icon(
                                      Icons.fullscreen_exit_rounded,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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

