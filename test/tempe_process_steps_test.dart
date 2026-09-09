import 'package:flutter_test/flutter_test.dart';
import 'package:e_modul_etnosains/core/constants/app_assets.dart';
import 'package:e_modul_etnosains/features/produk_fermentasi/data/models/fermented_foods_data.dart';
import 'package:e_modul_etnosains/features/produk_fermentasi/presentation/models/process_step_item.dart';

void main() {
  group('Tempe Fermentation Process Sequence Tests', () {
    test('getTempeSteps returns 8 structured steps according to textbook flowchart', () {
      final steps = FoodProcessStepsProvider.getTempeSteps();

      expect(steps.length, 8);

      expect(steps[0].title, 'Biji Kedelai');
      expect(steps[0].imageAsset, AppAssets.tempeKedelai);
      expect(steps[0].iconType, StepIconType.kedelai);

      expect(steps[1].title, 'Perendaman 1');
      expect(steps[1].imageAsset, AppAssets.tempePerendaman);
      expect(steps[1].iconType, StepIconType.perendaman);

      expect(steps[2].title, 'Perebusan & Kupas Kulit');
      expect(steps[2].imageAsset, AppAssets.tempePerebusan);
      expect(steps[2].iconType, StepIconType.perebusan);

      expect(steps[3].title, 'Perendaman 2 & Tiris');
      expect(steps[3].imageAsset, AppAssets.tempePerendaman);
      expect(steps[3].iconType, StepIconType.perendaman);

      expect(steps[4].title, 'Pemberian Ragi');
      expect(steps[4].imageAsset, AppAssets.tempeRagi);
      expect(steps[4].iconType, StepIconType.ragi);

      expect(steps[5].title, 'Pembungkusan');
      expect(steps[5].imageAsset, AppAssets.tempePembungkusan);
      expect(steps[5].iconType, StepIconType.pembungkusan);

      expect(steps[6].title, 'Fermentasi 36-48 jam');
      expect(steps[6].imageAsset, AppAssets.tempeProsesFerm);
      expect(steps[6].iconType, StepIconType.fermentasi);
      expect(steps[6].imageAsset, contains('fermentasi_tempe.jpeg'));

      expect(steps[7].title, 'Tempe Matang');
      expect(steps[7].imageAsset, AppAssets.tempeJadi);
      expect(steps[7].iconType, StepIconType.tempe);
    });

    test('FermentedFoodsData tempe processSteps has 8 steps matching sequence', () {
      final tempe = FermentedFoodsData.allFoods.firstWhere((f) => f.id == 'tempe');
      expect(tempe.processSteps.length, 8);
      expect(tempe.processSteps[0].title, contains('Kedelai'));
      expect(tempe.processSteps[1].title, contains('Perendaman 1'));
      expect(tempe.processSteps[2].title, contains('Perebusan'));
      expect(tempe.processSteps[3].title, contains('Perendaman 2'));
      expect(tempe.processSteps[4].title, contains('Ragi'));
      expect(tempe.processSteps[5].title, contains('Pembungkusan'));
      expect(tempe.processSteps[6].title, contains('Fermentasi'));
      expect(tempe.processSteps[7].title, contains('Tempe Matang'));
    });
  });
}
