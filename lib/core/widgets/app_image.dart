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
  });

  static const _publicBaseUrl =
      'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/media-assets';

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageErrorWidgetBuilder? errorBuilder;

  static String publicUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final normalized =
        path.startsWith('assets/') ? path.substring('assets/'.length) : path;
    final encoded = normalized.split('/').map(Uri.encodeComponent).join('/');
    return '$_publicBaseUrl/$encoded';
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      publicUrl(assetPath),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: errorBuilder ??
          (_, __, ___) => ColoredBox(
                color: Colors.grey.shade100,
                child: const Center(
                  child: Icon(Icons.broken_image_rounded, color: Colors.grey),
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
  }
}
