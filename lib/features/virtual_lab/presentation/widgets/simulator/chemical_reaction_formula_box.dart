import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';

class ChemicalReactionFormulaBox extends StatelessWidget {
  const ChemicalReactionFormulaBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warmCream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldenYellow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Persamaan Biokimia Fermentasi Tape:',
              style: AppTextStyles.tagText.copyWith(color: AppColors.terracottaDark)),
          const SizedBox(height: 6),
          Text(
            '1. Sakarifikasi: Pati (Amilum) + H₂O ──[Amilase]──> Glukosa (Manis)\n'
            '2. Fermentasi Alkohol: Glukosa ──[S. cerevisiae]──> 2 Etanol + 2 CO₂ + 2 ATP',
            style: AppTextStyles.scientificFormula.copyWith(fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }
}
