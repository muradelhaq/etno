import 'package:flutter/material.dart';
import '../../models/process_step_item.dart';
import '../dialogs/step_detail_dialog.dart';

class ProcessStepCard extends StatelessWidget {
  final ProcessStepItem step;

  const ProcessStepCard({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => StepDetailDialog.show(context, step),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFD6E8D0).withValues(alpha: 0.7),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            // Step Illustration (Image or Fallback Icon)
            if (step.imageAsset != null)
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  step.imageAsset!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _buildStepIcon(step.iconType),
                ),
              )
            else
              _buildStepIcon(step.iconType),
            const SizedBox(width: 12),

            // Step Label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: const TextStyle(
                      color: Color(0xFF1E3A2B),
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                  if (step.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      step.subtitle!,
                      style: TextStyle(
                        color: const Color(0xFF4C7C54).withValues(alpha: 0.9),
                        fontSize: 10.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Icon(
              Icons.info_outline_rounded,
              size: 16,
              color: Color(0xFF4C7C54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIcon(StepIconType type) {
    IconData icon;
    Color color;
    Color bg;

    switch (type) {
      case StepIconType.kedelai:
        icon = Icons.grain_rounded;
        color = const Color(0xFFD4A373);
        bg = const Color(0xFFFAEDCD);
        break;
      case StepIconType.perendaman:
        icon = Icons.water_drop_rounded;
        color = const Color(0xFF457B9D);
        bg = const Color(0xFFE0FBFC);
        break;
      case StepIconType.perebusan:
        icon = Icons.soup_kitchen_rounded;
        color = const Color(0xFFE76F51);
        bg = const Color(0xFFFFDDD2);
        break;
      case StepIconType.ragi:
        icon = Icons.scatter_plot_rounded;
        color = const Color(0xFF2A9D8F);
        bg = const Color(0xFFE8F5E9);
        break;
      case StepIconType.pembungkusan:
        icon = Icons.eco_rounded;
        color = const Color(0xFF5A8E65);
        bg = const Color(0xFFD6E8D0);
        break;
      case StepIconType.fermentasi:
        icon = Icons.hourglass_bottom_rounded;
        color = const Color(0xFF6B705C);
        bg = const Color(0xFFEDF2F4);
        break;
      case StepIconType.tempe:
        icon = Icons.crop_square_rounded;
        color = const Color(0xFF2D5A3C);
        bg = const Color(0xFFFFF3DB);
        break;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.2),
      ),
      child: Center(
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
