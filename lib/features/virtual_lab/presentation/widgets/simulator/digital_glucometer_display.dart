import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';
import 'package:e_modul_etnosains/features/virtual_lab/data/models/glucose_experiment_model.dart';

class DigitalGlucometerDisplay extends StatelessWidget {
  final double yeastPercent;
  final int fermentationDays;
  final GlucoseExperimentPoint simulation;
  final bool isSavingLab;
  final VoidCallback onSave;

  const DigitalGlucometerDisplay({
    super.key,
    required this.yeastPercent,
    required this.fermentationDays,
    required this.simulation,
    required this.isSavingLab,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return EthnoCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: const Color(0xFF14241D),
      borderColor: AppColors.primaryLight,
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.successGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'DIGITAL GLUCOMETER PRO',
                    style: AppTextStyles.scientificFormula.copyWith(
                      color: AppColors.sageLight,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  'Ragi ${yeastPercent.toStringAsFixed(1)}% • Hari $fermentationDays',
                  style: const TextStyle(
                      color: AppColors.goldenYellow,
                      fontSize: 10,
                      fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // LED Big Readout
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.primaryLight.withValues(alpha: 0.4), width: 1.5),
            ),
            child: Column(
              children: [
                Text(
                  'KADAR GLUKOSA TAPE',
                  style: AppTextStyles.tagText.copyWith(
                      color: Colors.white60, fontSize: 10, letterSpacing: 1.5),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      simulation.glucoseLevel.toStringAsFixed(2),
                      style: AppTextStyles.scientificData.copyWith(
                        fontSize: 44,
                        color: simulation.glucoseLevel >= 50.0
                            ? AppColors.goldenYellow
                            : AppColors.primaryLight,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '%',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (simulation.glucoseLevel >= 51.14) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.successGreen, width: 1),
                    ),
                    child: const Text(
                      '★ Memenuhi Standar Mutu Prima Jawa Barat (>51,14%) ★',
                      style: TextStyle(
                          color: AppColors.sageLight,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Organoleptic Sensory Summary
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildSensoryRow('Rasa', simulation.tasteProfile, Icons.emoji_emotions_rounded),
                const SizedBox(height: 6),
                _buildSensoryRow('Aroma', simulation.aromaProfile, Icons.air_rounded),
                const SizedBox(height: 6),
                _buildSensoryRow('Tekstur', simulation.textureProfile, Icons.touch_app_rounded),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Rating Sensori:',
                        style: TextStyle(color: Colors.white70, fontSize: 11)),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: i < simulation.organolepticRating
                              ? AppColors.goldenYellow
                              : Colors.white24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Button Rekam Hasil Lab
          ElevatedButton.icon(
            onPressed: isSavingLab ? null : onSave,
            icon: isSavingLab
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.cloud_upload_rounded, size: 18),
            label: Text(
              isSavingLab ? 'Menyimpan Catatan Lab...' : 'Simpan & Rekam Uji Lab ke Portofolio',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 42),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensoryRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.sageLight),
        const SizedBox(width: 8),
        Text('$label: ',
            style: const TextStyle(
                color: AppColors.sageLight, fontWeight: FontWeight.bold, fontSize: 11)),
        Expanded(
          child: Text(value, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ),
      ],
    );
  }
}
