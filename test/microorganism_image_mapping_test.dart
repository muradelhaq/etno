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
        'assets/images/saccharomyces_before_zoom.png',
        'assets/images/saccharomyces_after_zoom.png',
      ),
      'aspergillus_sp': (
        'assets/images/aspergillus_sp_before_zoom.png',
        'assets/images/aspergillus_sp_after_zoom.png',
      ),
      'aspergillus_oryzae': (
        'assets/images/aspergillus_oryzae_before_zoom.png',
        'assets/images/aspergillus_oryzae_after_zoom.png',
      ),
      'tetragenococcus': (
        'assets/images/tetragenococcus_before_zoom.png',
        'assets/images/tetragenococcus_after_zoom.png',
      ),
      'neurospora': (
        'assets/images/neurospora_before_zoom.png',
        'assets/images/neurospora_after_zoom.png',
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
