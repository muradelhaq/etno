import 'package:e_modul_etnosains/core/widgets/app_image.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('local asset path resolves to the public Supabase object URL', () {
    expect(
      AppImage.publicUrl('assets/images/food_tempe.jpg'),
      'https://lumhlhxbmdtlqmlbcumc.supabase.co/storage/v1/object/public/'
      'media-assets/images/food_tempe.jpg',
    );
  });

  test('existing remote URL remains unchanged', () {
    const url = 'https://example.com/image.png';
    expect(AppImage.publicUrl(url), url);
  });

  test('Supabase object URL uses an optimized render endpoint', () {
    final url = AppImage.optimizedUrl(
      'assets/images/aset_sed/ferm-tauco-5.jpeg',
      width: 960,
      quality: 70,
    );

    expect(url, contains('/storage/v1/render/image/public/media-assets/'));
    expect(url, contains('width=960'));
    expect(url, contains('quality=70'));
    expect(url, contains('resize=contain'));
  });
}
