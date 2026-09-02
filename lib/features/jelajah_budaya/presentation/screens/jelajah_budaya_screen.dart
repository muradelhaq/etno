import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/widgets/custom_button.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_scaffold.dart';
import 'package:e_modul_etnosains/core/utils/slide_navigation_guard.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';
import 'package:e_modul_etnosains/features/jelajah_budaya/data/models/region_culture_model.dart';
import '../widgets/cards/region_cultural_spotlight_card.dart';
import '../widgets/indonesia_map_widget.dart';
import '../widgets/sections/jelajah_intro_banner.dart';
import '../widgets/sections/region_chip_selector.dart';

class JelajahBudayaScreen extends ConsumerStatefulWidget {
  const JelajahBudayaScreen({super.key});

  @override
  ConsumerState<JelajahBudayaScreen> createState() =>
      _JelajahBudayaScreenState();
}

class _JelajahBudayaScreenState extends ConsumerState<JelajahBudayaScreen> {
  String _selectedRegionId = 'banyumas';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(userProgressProvider.notifier)
          .markModuleCompleted('jelajah', xpBonus: 40);
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
      prevRoute: '/produk/tauco',
      nextRoute: '/virtual-lab',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Intro
            const JelajahIntroBanner(),

            const SizedBox(height: 16),

            // Interactive Map Visual & Pins Container
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
                  RegionChipSelector(
                    selectedRegionId: _selectedRegionId,
                    onSelected: (id) {
                      setState(() {
                        _selectedRegionId = id;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Active Region Cultural Spotlight Card
            RegionCulturalSpotlightCard(activeItem: activeItem),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Lanjut ke Virtual Lab Uji Glukosa Tape',
              icon: Icons.science_rounded,
              isFullWidth: true,
              backgroundColor: AppColors.primaryGreen,
              onPressed: () => navigateToNextSlide(
                context,
                ref,
                currentSlide: 9,
                route: '/virtual-lab',
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
