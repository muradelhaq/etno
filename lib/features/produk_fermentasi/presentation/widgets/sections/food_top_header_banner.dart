import 'package:flutter/material.dart';
import '../../../domain/entities/fermented_food_entity.dart';

class FoodTopHeaderBanner extends StatelessWidget {
  final FermentedFoodEntity food;
  final int slideNum;

  const FoodTopHeaderBanner({
    super.key,
    required this.food,
    required this.slideNum,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF4),
        borderRadius: BorderRadius.circular(14),
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
      child: Row(
        children: [
          // Circular Badge Number
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF2D5A3C),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$slideNum',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Title
          Expanded(
            child: Text(
              food.id == 'tempe'
                  ? 'TEMPE DAN MAKANAN TRADISIONAL'
                  : '${food.name.toUpperCase()} DAN MAKANAN TRADISIONAL',
              style: const TextStyle(
                color: Color(0xFF1E3A2B),
                fontWeight: FontWeight.w900,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Leaf Icon
          const Icon(
            Icons.eco_rounded,
            color: Color(0xFF5A8E65),
            size: 24,
          ),
        ],
      ),
    );
  }
}
