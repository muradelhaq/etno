import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';

class PisaExplanationHintBox extends StatelessWidget {
  final bool isAnswered;
  final String explanation;
  final String hint;
  final bool isHintRevealed;
  final VoidCallback onRevealHint;

  const PisaExplanationHintBox({
    super.key,
    required this.isAnswered,
    required this.explanation,
    required this.hint,
    required this.isHintRevealed,
    required this.onRevealHint,
  });

  @override
  Widget build(BuildContext context) {
    if (isAnswered) {
      return EthnoCard(
        padding: const EdgeInsets.all(14),
        backgroundColor: AppColors.warmCream,
        borderColor: AppColors.goldenYellow,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.school_rounded,
                    color: AppColors.terracottaDark, size: 20),
                const SizedBox(width: 8),
                Text('Pembahasan Ilmiah Resmi:',
                    style: AppTextStyles.bodyBold
                        .copyWith(color: AppColors.terracottaDark)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              explanation,
              style: AppTextStyles.bodyMedium
                  .copyWith(fontSize: 12.5, height: 1.5),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms);
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        icon: const Icon(Icons.lightbulb_outline,
            size: 16, color: AppColors.warmTerracotta),
        label: Text(
          isHintRevealed ? hint : 'Butuh Petunjuk / Hint?',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.warmTerracotta,
            fontStyle: isHintRevealed ? FontStyle.italic : FontStyle.normal,
          ),
        ),
        onPressed: onRevealHint,
      ),
    );
  }
}
