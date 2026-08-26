import 'package:e_modul_etnosains/features/peta_konsep/data/models/microorganism_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('setiap mikroorganisme memakai pasangan gambar terbaru yang sesuai', () {
    const expectedImages = {
      'rhizopus': (
        'assets/images/tempe_microscope_before_zoom.png',
        'assets/images/tempe_microscope_after_zoom.png',
      ),
      'saccharomyces': (
        'assets/images/image1.jpeg',
        'assets/images/image2.jpeg',
      ),
      'aspergillus_sp': (
        'assets/images/image3.jpeg',
        'assets/images/image4.png',
      ),
      'aspergillus_oryzae': (
        'assets/images/image5.png',
        'assets/images/image6.jpeg',
      ),
      'tetragenococcus': (
        'assets/images/image7.jpeg',
        'assets/images/image8.jpeg',
      ),
      'neurospora': (
        'assets/images/image9.png',
        'assets/images/image10.jpeg',
      ),
    };

    expect(MicroorganismData.microbes, hasLength(expectedImages.length));
    for (final microbe in MicroorganismData.microbes) {
      final expected = expectedImages[microbe.id];
      expect(expected, isNotNull, reason: 'ID ${microbe.id} belum dipetakan');
      expect(microbe.beforeZoomImage, expected!.$1);
      expect(microbe.afterZoomImage, expected.$2);
      expect(microbe.imageUrl, expected.$2);
      expect(microbe.afterZoomImage, microbe.imageUrl);
    }
  });
}
