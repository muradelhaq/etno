import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';

class PisaScenarioContextCard extends StatelessWidget {
  final String scenarioContext;
  final String? tableDataSummary;

  const PisaScenarioContextCard({
    super.key,
    required this.scenarioContext,
    this.tableDataSummary,
  });

  @override
  Widget build(BuildContext context) {
    return EthnoCard(
      padding: const EdgeInsets.all(14),
      backgroundColor: AppColors.sageLight.withValues(alpha: 0.4),
      borderColor: AppColors.primaryLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  size: 16, color: AppColors.primaryGreen),
              const SizedBox(width: 6),
              Text(
                'Konteks Stimulus Soal:',
                style: AppTextStyles.tagText
                    .copyWith(color: AppColors.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            scenarioContext,
            style:
                AppTextStyles.bodyMedium.copyWith(fontSize: 13, height: 1.45),
          ),
          if (tableDataSummary != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Text(
                '📊 Data Rujukan: $tableDataSummary',
                style: AppTextStyles.scientificFormula.copyWith(fontSize: 11),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
