import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';
import 'package:e_modul_etnosains/features/jelajah_budaya/data/models/region_culture_model.dart';

class RegionCulturalSpotlightCard extends StatelessWidget {
  final RegionalCultureItem activeItem;

  const RegionCulturalSpotlightCard({
    super.key,
    required this.activeItem,
  });

  @override
  Widget build(BuildContext context) {
    return EthnoCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: Colors.white,
      borderColor: AppColors.goldenYellow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeItem.foodTitle,
                      style: AppTextStyles.h2.copyWith(
                        fontSize: 18,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Text(
                      '📍 ${activeItem.regionName}, ${activeItem.province}',
                      style: AppTextStyles.tagText
                          .copyWith(color: AppColors.warmTerracotta),
                    ),
                  ],
                ),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.sageLight,
                ),
                icon: const Icon(Icons.volume_up_rounded,
                    color: AppColors.primaryGreen),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Audio Narasi: "${activeItem.audioNarrationText}"'),
                      backgroundColor: AppColors.primaryGreen,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Culinary Photo Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.asset(
                  activeItem.imageAsset,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    color: AppColors.warmCream,
                    child: const Center(
                      child: Icon(Icons.restaurant_rounded,
                          size: 36, color: AppColors.primaryGreen),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                    child: Text(
                      'Kuliner Tradisional: ${activeItem.foodTitle}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),
          const Divider(color: AppColors.borderSubtle),
          const SizedBox(height: 10),

          // Origin & Etymology
          Text(
            'Etimologi & Asal-usul Nama:',
            style:
                AppTextStyles.bodyBold.copyWith(color: AppColors.primaryGreen),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.warmCream.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              activeItem.localTermOrigin,
              style: AppTextStyles.bodyMedium
                  .copyWith(fontSize: 13, fontStyle: FontStyle.italic),
            ),
          ),

          const SizedBox(height: 12),

          // Fun Fact
          Text(
            'Fakta Menarik (Fun Fact):',
            style: AppTextStyles.bodyBold
                .copyWith(color: AppColors.terracottaDark),
          ),
          const SizedBox(height: 4),
          Text(
            activeItem.funFact,
            style:
                AppTextStyles.bodyMedium.copyWith(fontSize: 13, height: 1.5),
          ),

          const SizedBox(height: 12),

          // Ethnoscience connection
          Text(
            'Kaitannya dengan Kearifan Etnosains:',
            style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryDark),
          ),
          const SizedBox(height: 4),
          Text(
            activeItem.ethnoscienceStory,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 12.5,
              height: 1.5,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
