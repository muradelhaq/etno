import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';

class LabControlSliders extends StatelessWidget {
  final double yeastPercent;
  final int fermentationDays;
  final bool isBananaLeaf;
  final ValueChanged<double> onYeastChanged;
  final ValueChanged<int> onDaysChanged;
  final ValueChanged<bool> onLeafChanged;

  const LabControlSliders({
    super.key,
    required this.yeastPercent,
    required this.fermentationDays,
    required this.isBananaLeaf,
    required this.onYeastChanged,
    required this.onDaysChanged,
    required this.onLeafChanged,
  });

  @override
  Widget build(BuildContext context) {
    return EthnoCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Yeast Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Konsentrasi Ragi:', style: AppTextStyles.bodyBold),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.sageLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${yeastPercent.toStringAsFixed(1)}% (${(yeastPercent * 9.0).toStringAsFixed(1)} g)',
                  style: AppTextStyles.tagText.copyWith(color: AppColors.primaryDark),
                ),
              ),
            ],
          ),
          Slider(
            value: yeastPercent,
            min: 0.5,
            max: 1.5,
            divisions: 2,
            activeColor: AppColors.primaryGreen,
            inactiveColor: AppColors.sageLight,
            onChanged: onYeastChanged,
          ),

          const SizedBox(height: 12),

          // 2. Days Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Lama Fermentasi (Hari):', style: AppTextStyles.bodyBold),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warmCream,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.goldenYellow),
                ),
                child: Text(
                  '$fermentationDays Hari',
                  style: AppTextStyles.tagText.copyWith(color: AppColors.terracottaDark),
                ),
              ),
            ],
          ),
          Slider(
            value: fermentationDays.toDouble(),
            min: 1.0,
            max: 5.0,
            divisions: 4,
            activeColor: AppColors.warmTerracotta,
            inactiveColor: AppColors.warmCream,
            onChanged: (v) => onDaysChanged(v.toInt()),
          ),

          const SizedBox(height: 12),

          // 3. Container Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Wadah Pemeraman:', style: AppTextStyles.bodyBold),
                    Text(
                      isBananaLeaf
                          ? 'Alas Daun Pisang (Sirkulasi Mikro Alami)'
                          : 'Wadah Plastik Kedap Udara',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isBananaLeaf,
                activeThumbColor: AppColors.primaryGreen,
                onChanged: onLeafChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
