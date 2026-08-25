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
}
