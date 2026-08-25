import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class TraditionalFoodInfoDialog extends StatelessWidget {
  final String title;
  final String imageAsset;
  final String description;
  final String culinaryScience;

  const TraditionalFoodInfoDialog({
    super.key,
    required this.title,
    required this.imageAsset,
    required this.description,
    required this.culinaryScience,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String imageAsset,
    required String description,
    required String culinaryScience,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => TraditionalFoodInfoDialog(
        title: title,
        imageAsset: imageAsset,
        description: description,
        culinaryScience: culinaryScience,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: EdgeInsets.zero,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imageAsset,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  color: AppColors.warmCream,
                  child: const Center(
                    child: Icon(Icons.fastfood,
                        size: 40, color: AppColors.warmTerracotta),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A2B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 12.5, height: 1.4),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF7EE),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.goldenYellow.withValues(alpha: 0.6)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.science_rounded,
                                  size: 14, color: AppColors.primaryGreen),
                              SizedBox(width: 4),
                              Text(
                                'Sains Kuliner & Cita Rasa:',
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
                            culinaryScience,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF2C3E50),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}
