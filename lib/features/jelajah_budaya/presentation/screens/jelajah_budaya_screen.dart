import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/ethno_card.dart';
import '../../../../core/widgets/ethno_scaffold.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../data/models/region_culture_model.dart';
import '../widgets/indonesia_map_widget.dart';

class JelajahBudayaScreen extends ConsumerStatefulWidget {
  const JelajahBudayaScreen({super.key});

  @override
  ConsumerState<JelajahBudayaScreen> createState() => _JelajahBudayaScreenState();
}

class _JelajahBudayaScreenState extends ConsumerState<JelajahBudayaScreen> {
  String _selectedRegionId = 'banyumas';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProgressProvider.notifier).markModuleCompleted('jelajah', xpBonus: 40);
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeItem = JelajahBudayaData.regions.firstWhere(
      (r) => r.id == _selectedRegionId,
      orElse: () => JelajahBudayaData.regions.first,
    );

    return EthnoScaffold(
      title: 'Jelajah Budaya Nusantara',
      subtitle: 'Slide 8 / 12 • Kearifan & Peta Kuliner Tradisional',
      currentSlide: 8,
      totalSlides: 12,
      prevRoute: '/produk/kecap',
      nextRoute: '/virtual-lab',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Intro
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.explore_rounded, color: AppColors.goldenYellow, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Peta Eksplorasi Daerah', style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(
                          'Ketuk pin daerah di bawah untuk mempelajari etimologi nama dan tradisi kuliner fermentasinya:',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.sageLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Interactive Map Visual & Pins Container (Map of Indonesia & Java)
            EthnoCard(
              padding: const EdgeInsets.all(16),
              backgroundColor: const Color(0xFFF4F9FB),
              borderColor: AppColors.primaryLight,
              child: Column(
                children: [
                  IndonesiaMapWidget(
                    selectedRegionId: _selectedRegionId,
                    onRegionSelected: (id) {
                      setState(() {
                        _selectedRegionId = id;
                      });
                    },
                  ),

                  const SizedBox(height: 14),

                  // Horizontal selector chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: JelajahBudayaData.regions.map((r) {
                        final isSelected = r.id == _selectedRegionId;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            avatar: Icon(
                              isSelected ? Icons.check_circle_rounded : Icons.location_on_outlined,
                              size: 14,
                              color: isSelected ? Colors.white : AppColors.primaryGreen,
                            ),
                            label: Text(r.regionName),
                            selected: isSelected,
                            selectedColor: AppColors.primaryGreen,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primaryGreen
                                    : AppColors.borderSubtle,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              fontSize: 12,
                            ),
                            onSelected: (sel) {
                              if (sel) {
                                setState(() {
                                  _selectedRegionId = r.id;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Active Region Cultural Spotlight Card
            EthnoCard(
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
                              style: AppTextStyles.h2.copyWith(fontSize: 18, color: AppColors.primaryDark),
                            ),
                            Text(
                              '📍 ${activeItem.regionName}, ${activeItem.province}',
                              style: AppTextStyles.tagText.copyWith(color: AppColors.warmTerracotta),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.sageLight,
                        ),
                        icon: const Icon(Icons.volume_up_rounded, color: AppColors.primaryGreen),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Audio Narasi: "${activeItem.audioNarrationText}"'),
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
                              child: Icon(Icons.restaurant_rounded, size: 36, color: AppColors.primaryGreen),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                  Text('Etimologi & Asal-usul Nama:', style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryGreen)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.warmCream.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      activeItem.localTermOrigin,
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 13, fontStyle: FontStyle.italic),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Fun Fact
                  Text('Fakta Menarik (Fun Fact):', style: AppTextStyles.bodyBold.copyWith(color: AppColors.terracottaDark)),
                  const SizedBox(height: 4),
                  Text(
                    activeItem.funFact,
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 13, height: 1.5),
                  ),

                  const SizedBox(height: 12),

                  // Ethnoscience connection
                  Text('Kaitannya dengan Kearifan Etnosains:', style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryDark)),
                  const SizedBox(height: 4),
                  Text(
                    activeItem.ethnoscienceStory,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 12.5, height: 1.5, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Lanjut ke Virtual Lab Uji Glukosa Tape',
              icon: Icons.science_rounded,
              isFullWidth: true,
              backgroundColor: AppColors.primaryGreen,
              onPressed: () {
                context.go('/virtual-lab');
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
