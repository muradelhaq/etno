import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';
import 'package:e_modul_etnosains/features/literasi_sains/data/models/pisa_question_model.dart';

class PisaOptionItemCard extends StatelessWidget {
  final PisaQuestionOption option;
  final int optionIndex;
  final bool isAnswered;
  final bool isChosen;
  final bool isCorrectAnswer;
  final VoidCallback? onTap;

  const PisaOptionItemCard({
    super.key,
    required this.option,
    required this.optionIndex,
    required this.isAnswered,
    required this.isChosen,
    required this.isCorrectAnswer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;
    Color borderColor = AppColors.borderSubtle;
    Color textColor = AppColors.textPrimary;
    IconData icon = Icons.circle_outlined;
    Color iconColor = AppColors.textSecondary;

    if (isAnswered) {
      if (isCorrectAnswer) {
        bgColor = AppColors.successLight;
        borderColor = AppColors.successGreen;
        icon = Icons.check_circle_rounded;
        iconColor = AppColors.successGreen;
      } else if (isChosen) {
        bgColor = AppColors.errorLight;
        borderColor = AppColors.errorRed;
        icon = Icons.cancel_rounded;
        iconColor = AppColors.errorRed;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: EthnoCard(
        padding: const EdgeInsets.all(12),
        backgroundColor: bgColor,
        borderColor: borderColor,
        onTap: isAnswered ? null : onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    option.text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      color: textColor,
                      fontWeight: isChosen ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            if (isAnswered && (isChosen || isCorrectAnswer)) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  option.justification,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 11,
                    color: isCorrectAnswer
                        ? AppColors.primaryDark
                        : AppColors.errorRed,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
