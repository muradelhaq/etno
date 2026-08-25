import 'package:flutter/material.dart';

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
    this.quality = 72,
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

  static String optimizedUrl(
    String path, {
    required int width,
    int quality = 72,
  }) {
    final original = publicUrl(path);
    final uri = Uri.parse(original);
    if (uri.host != 'lumhlhxbmdtlqmlbcumc.supabase.co' ||
        !uri.path.contains('/storage/v1/object/public/')) {
      return original;
    }
    return uri.replace(
      path: uri.path.replaceFirst(
        '/storage/v1/object/public/',
        '/storage/v1/render/image/public/',
      ),
      queryParameters: {
        ...uri.queryParameters,
        'width': width.toString(),
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
    return pixels.clamp(160, maxPixelWidth);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pixelWidth = _targetPixelWidth(context, constraints);
        return Image.network(
          optimizedUrl(assetPath, width: pixelWidth, quality: quality),
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          cacheWidth: pixelWidth,
          filterQuality: FilterQuality.low,
          gaplessPlayback: true,
          errorBuilder: errorBuilder ??
              (_, __, ___) => ColoredBox(
                    color: Colors.grey.shade100,
                    child: const Center(
                      child:
                          Icon(Icons.broken_image_rounded, color: Colors.grey),
                    ),
                  ),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            final expected = progress.expectedTotalBytes;
            return ColoredBox(
              color: Colors.grey.shade100,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: expected == null
                      ? null
                      : progress.cumulativeBytesLoaded / expected,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
