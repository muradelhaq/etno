import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../services/media_sync_service.dart';

class AppImage extends StatelessWidget {
  const AppImage(
    this.assetPath, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.errorBuilder,
    this.maxPixelWidth = 1600,
    this.quality = 75,
  });

  static const _publicBaseUrl =
      'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/media-assets';

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageErrorWidgetBuilder? errorBuilder;
  final int maxPixelWidth;
  final int quality;

  static String publicUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final normalized =
        path.startsWith('assets/') ? path.substring('assets/'.length) : path;
    final encoded = normalized.split('/').map(Uri.encodeComponent).join('/');
    return '$_publicBaseUrl/$encoded';
  }

  /// Bucketizes target pixel width into discrete tiers (240, 480, 800, 1200, 1600)
  /// to maximize cache hit rate across different screen sizes and orientations.
  static int bucketizeWidth(int pixels) {
    if (pixels <= 240) return 240;
    if (pixels <= 480) return 480;
    if (pixels <= 800) return 800;
    if (pixels <= 1200) return 1200;
    return 1600;
  }

  static String optimizedUrl(
    String path, {
    required int width,
    int quality = 75,
  }) {
    final original = publicUrl(path);
    final uri = Uri.parse(original);
    if (uri.host != 'lumhlhxbmdtlqmlbcumc.supabase.co' ||
        !uri.path.contains('/storage/v1/object/public/')) {
      return original;
    }
    final bucketWidth = bucketizeWidth(width);
    return uri.replace(
      path: uri.path.replaceFirst(
        '/storage/v1/object/public/',
        '/storage/v1/render/image/public/',
      ),
      queryParameters: {
        ...uri.queryParameters,
        'width': bucketWidth.toString(),
        'quality': quality.clamp(20, 100).toString(),
        'resize': 'contain',
      },
    ).toString();
  }

  int _targetPixelWidth(BuildContext context, BoxConstraints constraints) {
    final explicitWidth = width != null && width!.isFinite ? width : null;
    final layoutWidth =
        constraints.maxWidth.isFinite ? constraints.maxWidth : explicitWidth;
    if (layoutWidth == null) return maxPixelWidth;
    final pixels =
        (layoutWidth * MediaQuery.devicePixelRatioOf(context)).ceil();
    return bucketizeWidth(pixels.clamp(160, maxPixelWidth));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pixelWidth = _targetPixelWidth(context, constraints);
        final finalUrl =
            optimizedUrl(assetPath, width: pixelWidth, quality: quality);

        return CachedNetworkImage(
          imageUrl: finalUrl,
          cacheManager: MediaSyncService.cacheManager,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment is Alignment
              ? (alignment as Alignment)
              : Alignment.center,
          memCacheWidth: pixelWidth,
          fadeInDuration: const Duration(milliseconds: 150),
          fadeOutDuration: const Duration(milliseconds: 100),
          useOldImageOnUrlChange: true,
          errorWidget: (context, url, error) {
            if (errorBuilder != null) {
              return errorBuilder!(context, error, null);
            }
            return ColoredBox(
              color: Colors.grey.shade100,
              child: const Center(
                child: Icon(Icons.broken_image_rounded, color: Colors.grey),
              ),
            );
          },
          placeholder: (context, url) => ColoredBox(
            color: Colors.grey.shade100,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
