import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';

class PisaNavigationBar extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final bool canFinish;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  const PisaNavigationBar({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.canFinish,
    required this.onPrevious,
    required this.onNext,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton.icon(
          onPressed: currentIndex > 0 ? onPrevious : null,
          icon: const Icon(Icons.arrow_back_rounded, size: 16),
          label: const Text('Sebelumnya'),
        ),
        if (currentIndex < totalQuestions - 1) ...[
          ElevatedButton.icon(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: const Text('Selanjutnya'),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen),
          ),
        ] else ...[
          ElevatedButton.icon(
            onPressed: canFinish ? onFinish : null,
            icon: const Icon(Icons.check_circle_rounded, size: 16),
            label: const Text('Selesaikan Kuis'),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen),
          ),
        ],
      ],
    );
  }
}
