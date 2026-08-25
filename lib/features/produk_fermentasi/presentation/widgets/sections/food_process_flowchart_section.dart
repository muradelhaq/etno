import 'package:flutter/material.dart';
import '../../../domain/entities/fermented_food_entity.dart';
import '../../models/process_step_item.dart';
import '../cards/process_step_card.dart';

class FoodProcessFlowchartSection extends StatelessWidget {
  final FermentedFoodEntity food;

  const FoodProcessFlowchartSection({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final steps = FoodProcessStepsProvider.getStepsForFood(food);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD6E8D0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFD6E8D0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                food.id == 'tempe'
                    ? 'PROSES FERMENTASI TEMPE'
                    : 'PROSES FERMENTASI ${food.name.toUpperCase()}',
                style: const TextStyle(
                  color: Color(0xFF1E3A2B),
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Steps vertical list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            separatorBuilder: (ctx, i) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Center(
                child: Icon(
                  Icons.arrow_downward_rounded,
                  size: 16,
                  color: Color(0xFF4C7C54),
                ),
              ),
            ),
            itemBuilder: (ctx, i) {
              final step = steps[i];
              return ProcessStepCard(step: step);
            },
          ),
        ],
      ),
    );
  }
}
