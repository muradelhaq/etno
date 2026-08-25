import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../models/process_step_item.dart';

class StepDetailDialog extends StatelessWidget {
  final ProcessStepItem step;

  const StepDetailDialog({super.key, required this.step});

  static void show(BuildContext context, ProcessStepItem step) {
    showDialog(
      context: context,
      builder: (ctx) => StepDetailDialog(step: step),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          if (step.imageAsset != null)
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(2),
              child: Image.asset(
                step.imageAsset!,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _buildFallbackIcon(step.iconType),
              ),
            )
          else
            _buildFallbackIcon(step.iconType),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              step.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.description,
            style: const TextStyle(fontSize: 12.5, height: 1.45),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF81C784)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.biotech_rounded,
                        size: 14, color: AppColors.primaryGreen),
                    SizedBox(width: 4),
                    Text(
                      'Penjelasan Sains Biologi:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  step.biologicalExplanation,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF1E3A2B),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }

  Widget _buildFallbackIcon(StepIconType type) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Color(0xFFE8F5E9),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.grain_rounded, color: AppColors.primaryGreen, size: 18),
    );
  }
}
