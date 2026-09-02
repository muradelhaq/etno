import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import '../constants/app_assets.dart';
import '../widgets/app_image.dart';

/// Specialized persistent CacheManager for E-Modul Etnosains
class AppMediaCacheManager {
  static const String key = 'etnosains_media_cache';

  static final CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 60),
      maxNrOfCacheObjects: 500,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

/// Mobile Ops Media Synchronization & Pre-caching Service
class MediaSyncService {
  static CacheManager get cacheManager => AppMediaCacheManager.instance;
  static bool _hasInitializedWarmup = false;
  static bool _isVideoDownloading = false;

  static const String introVideoUrl =
      'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/media-assets/video-pengantar-etnosains-terbaru.mp4';

  /// Standard bucketized widths used for pre-caching
  static const List<int> standardWidthBuckets = [480, 800];

  /// Slide-by-slide image asset mapping for targeted pre-fetching
  static List<String> getSlideAssets(int slideIndex) {
    switch (slideIndex) {
      case 1: // Cover
        return [
          AppAssets.coverEtnosainsGenerated,
          AppAssets.posterLearningModules,
        ];
      case 2: // Apersepsi
        return [
          AppAssets.kimchi,
          AppAssets.orekTempe,
          AppAssets.colenak,
          AppAssets.tapeSingkong,
          AppAssets.tapeKetan,
          'assets/images/tempe-mendoan.jpg',
        ];
      case 3: // Peta Konsep
        return [
          AppAssets.flowchartFermentation,
          AppAssets.panelTempeTaucoTapeHd,
          AppAssets.panelOncomKecapHd,
          AppAssets.image4,
          AppAssets.image5,
          AppAssets.image9,
          AppAssets.image13,
          AppAssets.image14,
          AppAssets.image15,
          AppAssets.image16,
        ];
      case 4: // Tempe
        return [
          AppAssets.tempeKedelai,
          AppAssets.tempePerendaman,
          AppAssets.tempePerebusan,
          AppAssets.tempeRagi,
          AppAssets.tempePembungkusan,
          AppAssets.tempeProsesFerm,
          AppAssets.tempeJadi,
          AppAssets.orekTempe,
          'assets/images/tempe-mendoan.jpg',
          'assets/images/tempe_microscope_after_zoom.png',
        ];
      case 5: // Tape Singkong
        return [
          AppAssets.tapeFase1,
          AppAssets.tapeFase2,
          AppAssets.tapeFase3,
          AppAssets.tapeFase4,
          AppAssets.tapeFase5,
          AppAssets.tapeSingkongFermentasi,
          AppAssets.tapeSingkongSiap,
          AppAssets.colenak,
          AppAssets.tapeSingkong,
          'assets/images/saccharomyces_after_zoom.png',
          'assets/images/aspergillus_sp_after_zoom.png',
        ];
      case 6: // Tape Ketan
        return [
          AppAssets.tapeKetan,
          AppAssets.tapeFase1Alt,
          AppAssets.tapeFase2Alt,
          AppAssets.tapeFase3Alt,
          AppAssets.tapeFase4Alt,
          AppAssets.tapeFase5Alt,
          'assets/images/saccharomyces_after_zoom.png',
          'assets/images/aspergillus_sp_after_zoom.png',
        ];
      case 7: // Tauco
        return [
          AppAssets.taucoFase1,
          AppAssets.taucoFase2,
          AppAssets.taucoFase3,
          AppAssets.taucoFase4a,
          AppAssets.taucoFase4b,
          AppAssets.taucoFase5a,
          AppAssets.taucoFase5b,
          AppAssets.taucoSayurIkan,
          AppAssets.taucoIkanFermentasi,
          'assets/images/aspergillus_oryzae_after_zoom.png',
          'assets/images/tetragenococcus_after_zoom.png',
        ];
      case 8: // Jelajah Budaya
        return [
          AppAssets.colenak,
          AppAssets.tapeKetan,
          'assets/images/sayur_tauco.jpg',
          'assets/images/food_burger.jpg',
          'assets/images/food_tape_singkong.jpg',
        ];
      case 9: // Virtual Lab
        return [
          AppAssets.labTapeProcedure,
          AppAssets.chartGlucoseResearch,
        ];
      case 10: // Challenge Proyek
        return [
          AppAssets.posterLearningModules,
        ];
      case 11: // Evaluasi Kearifan
        return [];
      case 12: // Literasi Sains
        return [
          AppAssets.pisaLiteracyWorksheet,
          AppAssets.pisaQuestion6Ref,
          AppAssets.pisaQuestion10Ref,
        ];
      default:
        return [];
    }
  }

  /// Initialize and start background warmup
  static void initializeAndWarmup() {
    if (_hasInitializedWarmup) return;
    _hasInitializedWarmup = true;

    // Run async in microtask / background without blocking main thread
    Future.microtask(() async {
      // 1. Warm up critical Tier 1 (Cover, Apersepsi, Peta Konsep)
      await _prefetchSlideBatch([1, 2, 3]);

      // 2. Start video pre-caching silently in background
      unawaited(cacheVideo(introVideoUrl));

      // 3. Incrementally preload remaining slides (4 to 12)
      for (int i = 4; i <= 12; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        await _prefetchSlideBatch([i]);
      }
    });
  }

  /// Preload upcoming slide assets when navigating
  static void preloadUpcomingSlides(int currentSlide) {
    final nextSlides = [currentSlide + 1, currentSlide + 2]
        .where((s) => s >= 1 && s <= 12)
        .toList();
    if (nextSlides.isNotEmpty) {
      _prefetchSlideBatch(nextSlides);
    }
  }

  /// Batch prefetch for specific slides into disk cache
  static Future<void> _prefetchSlideBatch(List<int> slides) async {
    final urlsToFetch = <String>{};

    for (final slide in slides) {
      final rawAssets = getSlideAssets(slide);
      for (final asset in rawAssets) {
        for (final width in standardWidthBuckets) {
          final optUrl = AppImage.optimizedUrl(asset, width: width);
          urlsToFetch.add(optUrl);
        }
      }
    }

    for (final url in urlsToFetch) {
      try {
        // Download and store directly into persistent disk cache
        await cacheManager.downloadFile(url);
      } catch (_) {
        // Ignore single asset fetch failure silently
      }
    }
  }

  // ==========================================
  // Video Caching & Fast Loading
  // ==========================================

  static Future<String> _getVideoCachePath(String videoUrl) async {
    final dir = await getApplicationSupportDirectory();
    final cacheDir = Directory('${dir.path}/media_video_cache');
    if (!cacheDir.existsSync()) {
      cacheDir.createSync(recursive: true);
    }
    final fileName = 'intro_video_${videoUrl.hashCode.abs()}.mp4';
    return '${cacheDir.path}/$fileName';
  }

  /// Check if local cached video file exists and is valid (> 200KB)
  static Future<File?> getLocalVideoFile(String videoUrl) async {
    try {
      final filePath = await _getVideoCachePath(videoUrl);
      final file = File(filePath);
      if (await file.exists()) {
        final length = await file.length();
        if (length > 200 * 1024) {
          return file;
        }
      }
    } catch (_) {}
    return null;
  }

  /// Download and cache video locally for instant offline playback
  static Future<File?> cacheVideo(String videoUrl) async {
    if (_isVideoDownloading) return null;
    final existing = await getLocalVideoFile(videoUrl);
    if (existing != null) return existing;

    _isVideoDownloading = true;
    try {
      final filePath = await _getVideoCachePath(videoUrl);
      final tempPath = '$filePath.tmp';

      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(minutes: 5),
        ),
      );

      await dio.download(
        videoUrl,
        tempPath,
        deleteOnError: true,
      );

      final tempFile = File(tempPath);
      if (await tempFile.exists() && await tempFile.length() > 200 * 1024) {
        final finalFile = await tempFile.rename(filePath);
        return finalFile;
      }
    } catch (_) {
      // Background video download error can be handled gracefully
    } finally {
      _isVideoDownloading = false;
    }
    return null;
  }
}
