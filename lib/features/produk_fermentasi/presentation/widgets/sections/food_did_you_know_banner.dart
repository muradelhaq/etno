import 'package:flutter/material.dart';
import '../../../domain/entities/fermented_food_entity.dart';

class FoodDidYouKnowBanner extends StatelessWidget {
  final FermentedFoodEntity food;

  const FoodDidYouKnowBanner({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFFE0A3),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tahukah Kamu? Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFAEDCD),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD4A373), width: 1.0),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lightbulb_rounded,
                    color: Color(0xFFD4A373), size: 14),
                SizedBox(width: 4),
                Text(
                  'Tahukah Kamu?',
                  style: TextStyle(
                    color: Color(0xFF7F5539),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Fact description
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFF2C3E50),
                  fontSize: 11.5,
                  height: 1.35,
                ),
                children: [
                  TextSpan(
                    text: '${food.name} ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A2B),
                    ),
                  ),
                  TextSpan(
                    text: food.id == 'tempe'
                        ? 'merupakan sumber protein nabati tinggi dan mudah dicerna tubuh berkat enzim protease kapang Rhizopus.'
                        : 'mengandung enzim alami hasil fermentasi mikroba yang meningkatkan cita rasa dan nilai cerna nutrisinya.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
