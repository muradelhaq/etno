import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../dialogs/traditional_food_info_dialog.dart';

class FoodProductCard extends StatelessWidget {
  final String title;
  final String imageAsset;
  final String description;
  final String culinaryScience;

  const FoodProductCard({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.description,
    required this.culinaryScience,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD6E8D0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Food Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
            child: Image.asset(
              imageAsset,
              height: 95,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 95,
                color: const Color(0xFFFAF7EE),
                child: const Center(
                  child: Icon(Icons.fastfood_rounded,
                      color: AppColors.warmTerracotta, size: 28),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Food Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1E3A2B),
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 0.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 6),

          // Green Button: Klik untuk info
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => TraditionalFoodInfoDialog.show(
                  context,
                  title: title,
                  imageAsset: imageAsset,
                  description: description,
                  culinaryScience: culinaryScience,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C7C54),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Klik untuk info',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
