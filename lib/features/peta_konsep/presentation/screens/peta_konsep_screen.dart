import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/custom_button.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_scaffold.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';
import '../widgets/concept_tree_map_widget.dart';
import '../widgets/microscope/virtual_microscope_simulator.dart';
import '../widgets/sections/microbe_taxonomy_grid_section.dart';

class PetaKonsepScreen extends ConsumerStatefulWidget {
  const PetaKonsepScreen({super.key});

  @override
  ConsumerState<PetaKonsepScreen> createState() => _PetaKonsepScreenState();
}

class _PetaKonsepScreenState extends ConsumerState<PetaKonsepScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _microscopeKey = GlobalKey();

  String _selectedMicrobeId = 'rhizopus';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(userProgressProvider.notifier)
          .markModuleCompleted('peta_konsep', xpBonus: 40);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _selectAndScrollToMicroscope(String microbeId, String microbeName) {
    setState(() {
      _selectedMicrobeId = microbeId;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_microscopeKey.currentContext != null) {
        Scrollable.ensureVisible(
          _microscopeKey.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
          alignment: 0.05,
        );
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🔬 Mikroskop kini mengamati: $microbeName'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EthnoScaffold(
      title: 'Peta Konsep & Mikroorganisme',
      subtitle: 'Slide 3 / 13 • Taksonomi Hayati',
      currentSlide: 3,
      totalSlides: 13,
      prevRoute: '/apersepsi',
      nextRoute: '/produk/tempe',
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Concept Tree Header Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.account_tree_rounded,
                          color: AppColors.goldenYellow, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Pohon Konsep Fermentasi Tradisional',
                          style: AppTextStyles.h3
                              .copyWith(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bagan struktur pohon hubungan antara 4 Produk Induk Fermentasi dan Kuliner Olahan Tradisional Nusantara:',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.sageLight),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Concept tree hierarchical map
            const ConceptTreeMapWidget().animate().fadeIn(duration: 500.ms),

            const SizedBox(height: 24),
            const Divider(color: AppColors.borderSubtle),
            const SizedBox(height: 14),

            // 2. Virtual Microscope Simulator
            Container(
              key: _microscopeKey,
              child: Row(
                children: [
                  const Icon(Icons.biotech_rounded,
                      color: AppColors.primaryGreen, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('2. Simulator Mikroskop Virtual',
                        style: AppTextStyles.h2.copyWith(fontSize: 16)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Pilih mikroba dan geser perbesaran lensa objektif untuk mengamati struktur seluler miselium & khamir:',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 14),

            VirtualMicroscopeSimulator(
              selectedMicrobeId: _selectedMicrobeId,
              onMicrobeChanged: (id) => setState(() => _selectedMicrobeId = id),
            ),

            const SizedBox(height: 24),
            const Divider(color: AppColors.borderSubtle),
            const SizedBox(height: 14),

            // 3. Microorganisms Database Grid
            MicrobeTaxonomyGridSection(
              selectedMicrobeId: _selectedMicrobeId,
              onSelectInMicroscope: _selectAndScrollToMicroscope,
            ),

            const SizedBox(height: 20),

            CustomButton(
              text: 'Lanjut ke Modul Produk 1: Tempe',
              icon: Icons.arrow_forward_rounded,
              isFullWidth: true,
              backgroundColor: AppColors.primaryGreen,
              onPressed: () {
                context.go('/produk/tempe');
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
