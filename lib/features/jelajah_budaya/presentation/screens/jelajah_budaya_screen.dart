import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/ethno_card.dart';
import '../../../../core/widgets/module_nav_bar.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../data/models/region_culture_model.dart';

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

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: const CustomAppBar(
        title: 'Jelajah Budaya Nusantara',
        subtitle: 'Slide 8 / 12 • Kearifan & Peta Kuliner Tradisional',
      ),
      bottomNavigationBar: const ModuleNavBar(
        currentSlide: 8,
        totalSlides: 12,
        prevRoute: '/produk/kecap',
        nextRoute: '/virtual-lab',
      ),
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

            // Interactive Map Visual & Pins Container
            EthnoCard(
              padding: const EdgeInsets.all(16),
              backgroundColor: const Color(0xFFE3F2FD),
              borderColor: AppColors.primaryLight,
              child: Column(
                children: [
                  // Map header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pulau Jawa & Tatar Pasundan', style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryDark)),
                      const Icon(Icons.map_outlined, color: AppColors.primaryGreen, size: 20),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Map representation with pins
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4E6B5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                    ),
                    child: Stack(
                      children: [
                        // Decorative water & island contours
                        Positioned(
                          left: 20,
                          top: 50,
                          right: 20,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF81C784),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),

                        // Region Pins
                        _buildMapPin('banyumas', 'Banyumas (Mendoan)', top: 60, right: 40),
                        _buildMapPin('tasikmalaya', 'Tasik (Nasi TO)', top: 75, left: 140),
                        _buildMapPin('cianjur', 'Cianjur (Tauco)', top: 50, left: 75),
                        _buildMapPin('purwakarta', 'Purwakarta (Maranggi)', top: 35, left: 95),
                        _buildMapPin('bandung', 'Bandung (Peuyeum)', top: 65, left: 100),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

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
                            label: Text(r.regionName),
                            selected: isSelected,
                            selectedColor: AppColors.primaryGreen,
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

  Widget _buildMapPin(String regionId, String label, {double? top, double? bottom, double? left, double? right}) {
    final isSelected = _selectedRegionId == regionId;

    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRegionId = regionId;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.errorRed : AppColors.primaryDark,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4),
                ],
              ),
              child: const Icon(Icons.place, color: Colors.white, size: 16),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label.split(' ').first,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.errorRed : AppColors.primaryDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
