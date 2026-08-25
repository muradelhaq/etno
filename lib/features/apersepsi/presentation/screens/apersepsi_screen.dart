import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_scaffold.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';
import '../../data/models/food_comparison_model.dart';
import '../widgets/cards/food_comparison_chip_card.dart';
import '../widgets/cards/food_matching_challenge_card.dart';
import '../widgets/sections/critical_reflection_input_box.dart';

class ApersepsiScreen extends ConsumerStatefulWidget {
  const ApersepsiScreen({super.key});

  @override
  ConsumerState<ApersepsiScreen> createState() => _ApersepsiScreenState();
}

class _ApersepsiScreenState extends ConsumerState<ApersepsiScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProgressProvider.notifier).markModuleCompleted('apersepsi', xpBonus: 30);
    });
  }

  @override
  Widget build(BuildContext context) {
    return EthnoScaffold(
      title: 'Apersepsi & Brainstorming',
      subtitle: 'Slide 2 / 12 • Mengaktifkan Pemikiran Awal',
      currentSlide: 2,
      totalSlides: 12,
      prevRoute: '/',
      nextRoute: '/peta-konsep',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1 Header: Pertanyaan Pemantik
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.sageLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.psychology_rounded, color: AppColors.primaryGreen, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pertanyaan Pemantik', style: AppTextStyles.h3.copyWith(fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(
                          'Manakah makanan di bawah ini yang lebih sering kalian santap?',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 18),

            // 1. Galeri Kuliner Modern vs Tradisional
            Text('1. Galeri Kuliner Modern vs Tradisional', style: AppTextStyles.h2.copyWith(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              'Klik kartu makanan di bawah untuk melihat rincian bahan dan proses fermentasinya:',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 12),

            // Modern Foods
            Text('Makanan Cepat Saji Modern (Global):',
                style: AppTextStyles.bodyBold.copyWith(color: AppColors.warmTerracotta)),
            const SizedBox(height: 8),
            _buildFoodGrid(ApersepsiData.modernFoods, isModern: true),

            const SizedBox(height: 18),

            // Traditional Foods
            Text('Makanan Tradisional Nusantara (Lokal):',
                style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryGreen)),
            const SizedBox(height: 8),
            _buildFoodGrid(ApersepsiData.traditionalFoods, isModern: false),

            const SizedBox(height: 24),
            const Divider(color: AppColors.borderSubtle),
            const SizedBox(height: 14),

            // 2. Tantangan Mencocokkan
            const FoodMatchingChallengeCard(),

            const SizedBox(height: 24),
            const Divider(color: AppColors.borderSubtle),
            const SizedBox(height: 14),

            // 3. Kolom Refleksi
            const CriticalReflectionInputBox(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodGrid(List<FoodItemModel> items, {required bool isModern}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        final cardWidth = (constraints.maxWidth - (3 * 8)) / 4;

        final double aspectRatio = isLandscape
            ? (cardWidth > 180 ? 1.25 : 1.05)
            : (cardWidth < 90 ? 0.65 : 0.72);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (ctx, i) {
            return FoodComparisonChipCard(
              item: items[i],
              isModern: isModern,
              isLandscape: isLandscape,
            );
          },
        );
      },
    );
  }
}
