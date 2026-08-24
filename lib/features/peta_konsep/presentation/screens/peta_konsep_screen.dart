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
import '../../data/models/microorganism_model.dart';
import '../widgets/concept_tree_map_widget.dart';

class PetaKonsepScreen extends ConsumerStatefulWidget {
  const PetaKonsepScreen({super.key});

  @override
  ConsumerState<PetaKonsepScreen> createState() => _PetaKonsepScreenState();
}

class _PetaKonsepScreenState extends ConsumerState<PetaKonsepScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _microscopeKey = GlobalKey();

  double _microscopeZoom = 100.0;
  String _selectedMicrobeId = 'rhizopus';
  bool _isDetailExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProgressProvider.notifier).markModuleCompleted('peta_konsep', xpBonus: 40);
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
      _isDetailExpanded = true;
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

  void _showMicrobeDetailDialog(BuildContext context, MicroorganismModel microbe) {
    final isCurrentInSimulator = microbe.id == _selectedMicrobeId;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        contentPadding: EdgeInsets.zero,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Image Banner
                Stack(
                  children: [
                    Image.asset(
                      microbe.imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 150,
                        color: const Color(0xFF10281E),
                        child: Center(
                          child: _buildMicroscopicView(microbe, 300),
                        ),
                      ),
                    ),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.85),
                          ],
                          stops: const [0.35, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.warmTerracotta,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          microbe.kingdomType,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 12,
                      right: 12,
                      child: Text(
                        microbe.scientificName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Detail Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Target Product
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.restaurant_rounded, size: 16, color: AppColors.warmTerracotta),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Produk Fermentasi Sasaran:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.warmTerracotta,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  microbe.targetProduct,
                                  style: AppTextStyles.bodyBold.copyWith(
                                    fontSize: 13,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Primary Function
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.hub_rounded, size: 16, color: AppColors.primaryGreen),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fungsi Utama:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  microbe.primaryFunction,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 12.5,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Biochemical Role
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F8F2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFC8E6C9)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.science_rounded, size: 16, color: AppColors.primaryGreen),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Peran Biokimia & Reaksi:',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    microbe.biochemicalRole,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF1E3A2B),
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Microscopic Feature
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F4F8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFBBDEFB)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.biotech_rounded, size: 16, color: Color(0xFF1976D2)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ciri Morfologi Mikroskopik:',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1976D2),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    microbe.microscopicFeature,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF2C3E50),
                                      fontStyle: FontStyle.italic,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Button inside dialog to observe in microscope
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            _selectAndScrollToMicroscope(
                              microbe.id,
                              microbe.scientificName,
                            );
                          },
                          icon: const Icon(Icons.biotech_rounded, size: 16),
                          label: Text(
                            isCurrentInSimulator
                                ? 'Sedang Diamati (Gulir ke Mikroskop)'
                                : 'Amati di Simulator Mikroskop',
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
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
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeMicrobe = MicroorganismData.microbes.firstWhere(
      (m) => m.id == _selectedMicrobeId,
      orElse: () => MicroorganismData.microbes.first,
    );

    return EthnoScaffold(
      title: 'Peta Konsep & Mikroorganisme',
      subtitle: 'Slide 3 / 12 • Taksonomi Hayati',
      currentSlide: 3,
      totalSlides: 12,
      prevRoute: '/apersepsi',
      nextRoute: '/produk/tempe',
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Concept Tree Overview
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
                      const Icon(Icons.account_tree_rounded, color: AppColors.goldenYellow, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Pohon Konsep Fermentasi Tradisional',
                          style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bagan struktur pohon hubungan antara 4 Produk Induk Fermentasi dan Kuliner Olahan Tradisional Nusantara:',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.sageLight),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Concept tree hierarchical map (Peta Pohon Konsep)
            const ConceptTreeMapWidget().animate().fadeIn(duration: 500.ms),

            const SizedBox(height: 24),
            const Divider(color: AppColors.borderSubtle),
            const SizedBox(height: 14),

            // Section 2: Virtual Microscope Simulator
            Container(
              key: _microscopeKey,
              child: Row(
                children: [
                  const Icon(Icons.biotech_rounded, color: AppColors.primaryGreen, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('2. Simulator Mikroskop Virtual', style: AppTextStyles.h2.copyWith(fontSize: 16)),
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

            // Microbe selector tabs (Wrap - no horizontal scroll needed)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MicroorganismData.microbes.map((m) {
                final isSelected = m.id == _selectedMicrobeId;
                return ChoiceChip(
                  label: Text(m.scientificName.split(' ').take(2).join(' ')),
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
                    fontSize: 11.5,
                    fontStyle: FontStyle.italic,
                  ),
                  onSelected: (sel) {
                    if (sel) {
                      setState(() {
                        _selectedMicrobeId = m.id;
                      });
                    }
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            // Microscope Viewport Box (Responsive Side-by-Side in Landscape)
            LayoutBuilder(
              builder: (ctx, constraints) {
                final isLandscape =
                    MediaQuery.of(context).orientation == Orientation.landscape;
                final lensSize = isLandscape ? 125.0 : 170.0;

                final lensSection = Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLensVisualizer(
                      context: context,
                      activeMicrobe: activeMicrobe,
                      zoom: _microscopeZoom,
                      lensSize: lensSize,
                      isLandscape: isLandscape,
                    ),

                    SizedBox(height: isLandscape ? 8 : 12),

                    // Slider magnification
                    Row(
                      children: [
                        const Text('100x', style: TextStyle(color: Colors.white70, fontSize: 10)),
                        Expanded(
                          child: Slider(
                            value: _microscopeZoom,
                            min: 100.0,
                            max: 1000.0,
                            divisions: 9,
                            activeColor: AppColors.primaryLight,
                            inactiveColor: Colors.white24,
                            label: '${_microscopeZoom.toInt()}x',
                            onChanged: (v) {
                              setState(() {
                                _microscopeZoom = v;
                              });
                            },
                          ),
                        ),
                        const Text('1000x', style: TextStyle(color: Colors.white70, fontSize: 10)),
                      ],
                    ),
                  ],
                );

                final detailsSection = InkWell(
                  onTap: () {
                    setState(() {
                      _isDetailExpanded = !_isDetailExpanded;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: _isDetailExpanded ? 0.12 : 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isDetailExpanded
                            ? AppColors.primaryLight.withValues(alpha: 0.5)
                            : Colors.white12,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header: Microbe Name + Kingdom Badge + Expand Icon
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                activeMicrobe.scientificName,
                                style: TextStyle(
                                  color: AppColors.warmCream,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: isLandscape ? 13 : 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.warmTerracotta,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                activeMicrobe.kingdomType.split(' ').first,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              _isDetailExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: AppColors.goldenYellow,
                              size: 20,
                            ),
                          ],
                        ),

                        // If collapsed, show subtle cue
                        if (!_isDetailExpanded) ...[
                          const SizedBox(height: 4),
                          const Text(
                            'Ketuk untuk melihat rincian produk target & morfologi',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],

                        // Details when expanded
                        if (_isDetailExpanded) ...[
                          const SizedBox(height: 8),
                          const Divider(color: Colors.white12, height: 1),
                          const SizedBox(height: 8),
                          Text(
                            'Produk Target: ${activeMicrobe.targetProduct}',
                            style: const TextStyle(
                              color: AppColors.goldenYellow,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            activeMicrobe.primaryFunction,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11.5,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Ciri Mikroskopik: ${activeMicrobe.microscopicFeature}',
                            style: const TextStyle(
                              color: AppColors.sageLight,
                              fontSize: 10.5,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );

                return EthnoCard(
                  padding: const EdgeInsets.all(14),
                  backgroundColor: Colors.black87,
                  borderColor: AppColors.primaryGreen,
                  child: isLandscape
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: lensSection,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              flex: 6,
                              child: detailsSection,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            lensSection,
                            const SizedBox(height: 4),
                            detailsSection,
                          ],
                        ),
                );
              },
            ),

            const SizedBox(height: 24),
            const Divider(color: AppColors.borderSubtle),
            const SizedBox(height: 14),

            // Section 3: Microorganisms Database Grid with Photos
            Row(
              children: [
                const Icon(Icons.menu_book_rounded, color: AppColors.primaryGreen, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '3. Kartu Karakteristik Lengkap 6 Mikroba Utama',
                    style: AppTextStyles.h2.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Pelajari taksonomi, peran biokimia, morfologi mikroskopik, dan produk pangan olahannya (Ketuk kartu/tombol untuk langsung mengamati di mikroskop):',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (ctx, constraints) {
                // In landscape / wide screen: 3 cards per row (2 rows)
                // In portrait mobile: 2 cards per row (3 rows)
                final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
                final isWide = constraints.maxWidth > 580 || isLandscape;
                final columns = isWide ? 3 : 2;
                final spacing = isWide ? 12.0 : 10.0;
                final cardWidth = (constraints.maxWidth - ((columns - 1) * spacing)) / columns;
                final bannerHeight = isWide ? 110.0 : 95.0;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: MicroorganismData.microbes.map((microbe) {
                    final isCurrentInSimulator = microbe.id == _selectedMicrobeId;

                    return SizedBox(
                      width: cardWidth,
                      child: InkWell(
                        onTap: () => _showMicrobeDetailDialog(context, microbe),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isCurrentInSimulator
                                  ? AppColors.primaryGreen
                                  : AppColors.borderSubtle,
                              width: isCurrentInSimulator ? 2.0 : 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isCurrentInSimulator
                                    ? AppColors.primaryGreen.withValues(alpha: 0.16)
                                    : Colors.black.withValues(alpha: 0.04),
                                blurRadius: isCurrentInSimulator ? 8 : 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Photo / Microscopic Banner
                                Stack(
                                  children: [
                                    Image.asset(
                                      microbe.imageUrl,
                                      height: bannerHeight,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        height: bannerHeight,
                                        color: const Color(0xFF10281E),
                                        child: Center(
                                          child: _buildMicroscopicView(microbe, 300),
                                        ),
                                      ),
                                    ),
                                    // Gradient shadow over photo
                                    Container(
                                      height: bannerHeight,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(alpha: 0.8),
                                          ],
                                          stops: const [0.3, 1.0],
                                        ),
                                      ),
                                    ),
                                    // Kingdom Badge (Top Left only - prevents any badge collision)
                                    Positioned(
                                      top: 6,
                                      left: 6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.warmTerracotta,
                                          borderRadius: BorderRadius.circular(6),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.25),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          microbe.kingdomType.split(' ').first,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Scientific Name over photo bottom
                                    Positioned(
                                      bottom: 6,
                                      left: 8,
                                      right: 8,
                                      child: Text(
                                        microbe.scientificName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          shadows: [
                                            Shadow(color: Colors.black, blurRadius: 4),
                                          ],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                                // Text Content Body
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Target product info
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.fastfood_rounded, size: 13, color: AppColors.warmTerracotta),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              microbe.targetProduct,
                                              style: AppTextStyles.bodyBold.copyWith(
                                                fontSize: 11.0,
                                                color: AppColors.primaryDark,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),

                                      // Biochemical Role
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.science_rounded, size: 13, color: AppColors.primaryGreen),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              microbe.biochemicalRole,
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: AppColors.textPrimary,
                                                fontSize: 10.5,
                                                height: 1.3,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),

                                      // Microscopic Feature
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.biotech_rounded, size: 13, color: Color(0xFF5390D9)),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              microbe.microscopicFeature,
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: AppColors.textSecondary,
                                                fontSize: 10.0,
                                                fontStyle: FontStyle.italic,
                                                height: 1.3,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      // Interactive Button to inspect in microscope
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: () => _selectAndScrollToMicroscope(
                                            microbe.id,
                                            microbe.scientificName,
                                          ),
                                          icon: Icon(
                                            isCurrentInSimulator
                                                ? Icons.check_circle_rounded
                                                : Icons.visibility_rounded,
                                            size: 13,
                                            color: isCurrentInSimulator
                                                ? Colors.white
                                                : AppColors.primaryDark,
                                          ),
                                          label: Text(
                                            isCurrentInSimulator
                                                ? 'Sedang Diamati'
                                                : 'Amati di Mikroskop',
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.bold,
                                              color: isCurrentInSimulator
                                                  ? Colors.white
                                                  : AppColors.primaryDark,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isCurrentInSimulator
                                                ? AppColors.primaryGreen
                                                : const Color(0xFFFAF7EE),
                                            elevation: isCurrentInSimulator ? 1 : 0,
                                            side: BorderSide(
                                              color: isCurrentInSimulator
                                                  ? AppColors.primaryGreen
                                                  : AppColors.borderSubtle,
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
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

  /// Circular Microscope Lens with Dual-Layer Zoom Transition
  Widget _buildLensVisualizer({
    required BuildContext context,
    required MicroorganismModel activeMicrobe,
    required double zoom,
    required double lensSize,
    required bool isLandscape,
  }) {
    // Normalization t: 0.0 (at 100x) to 1.0 (at 1000x)
    final t = ((zoom - 100.0) / 900.0).clamp(0.0, 1.0);

    // Food image opacity: 1.0 at 100x -> 0.0 at 450x
    final foodOpacity = (1.0 - t * 2.2).clamp(0.0, 1.0);
    final foodScale = 1.0 + t * 2.0;

    // Microscopic view opacity: 0.0 at 100x -> 1.0 at 450x
    final microbeOpacity = (t * 2.0).clamp(0.0, 1.0);
    final microbeScale = 0.7 + t * 0.8;

    final foodAsset = _getFoodImageForMicrobe(activeMicrobe.id);

    return Center(
      child: Container(
        width: lensSize,
        height: lensSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF10281E),
          border: Border.all(color: AppColors.primaryLight, width: 3),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withValues(alpha: 0.35),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background dark microscope field
              Container(color: const Color(0xFF0D1F17)),

              // LAYER 1: Macroscopic Food Image (fades out as zoom increases)
              if (foodOpacity > 0.01)
                Opacity(
                  opacity: foodOpacity,
                  child: Transform.scale(
                    scale: foodScale,
                    child: Image.asset(
                      foodAsset,
                      width: lensSize,
                      height: lensSize,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF2C3E50),
                        child: const Center(
                          child: Icon(Icons.fastfood, color: Colors.white54, size: 30),
                        ),
                      ),
                    ),
                  ),
                ),

              // Vignette overlay on top of food image for lens realism
              if (foodOpacity > 0.01)
                Opacity(
                  opacity: foodOpacity * 0.45,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.85),
                        ],
                        stops: const [0.55, 1.0],
                      ),
                    ),
                  ),
                ),

              // LAYER 2: Microscopic Cellular Structure View (fades in as zoom increases)
              if (microbeOpacity > 0.01)
                Opacity(
                  opacity: microbeOpacity,
                  child: Transform.scale(
                    scale: microbeScale,
                    child: _buildMicroscopicView(activeMicrobe, zoom),
                  ),
                ),

              // Crosshair lines
              const Divider(color: Colors.white24, thickness: 1),
              const VerticalDivider(color: Colors.white24, thickness: 1),

              // Zoom indicator badge with dynamic stage text
              Positioned(
                top: isLandscape ? 6 : 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: AppColors.goldenYellow, width: 0.9),
                  ),
                  child: Text(
                    zoom <= 200
                        ? '${zoom.toInt()}x • Bahan: ${activeMicrobe.targetProduct.split(' ').first}'
                        : (zoom <= 500
                            ? '${zoom.toInt()}x • Transisi Hifa / Sel'
                            : '${zoom.toInt()}x • Sel ${activeMicrobe.scientificName.split(' ').first}'),
                    style: AppTextStyles.scientificFormula.copyWith(
                      color: AppColors.goldenYellow,
                      fontSize: isLandscape ? 8.0 : 9.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFoodImageForMicrobe(String microbeId) {
    switch (microbeId) {
      case 'rhizopus':
        return 'assets/images/food_tempe.jpg';
      case 'saccharomyces':
        return 'assets/images/food_tape_singkong.jpg';
      case 'aspergillus_sp':
        return 'assets/images/food_tape_ketan.jpg';
      case 'aspergillus_oryzae':
        return 'assets/images/food_tauco.jpg';
      case 'tetragenococcus':
        return 'assets/images/food_tauco.jpg';
      case 'neurospora':
        return 'assets/images/food_oncom.jpg';
      default:
        return 'assets/images/food_tempe.jpg';
    }
  }

  Widget _buildMicroscopicView(MicroorganismModel microbe, double zoom) {
    if (microbe.id == 'rhizopus') {
      // Tempe: Rhizopus mycelium network with sporangium heads
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSporangium(),
              const SizedBox(width: 16),
              _buildSporangium(),
            ],
          ),
          Container(
            width: 120,
            height: 3,
            color: const Color(0xFFCDEAC0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(width: 2, height: 25, color: const Color(0xFFCDEAC0)),
              Container(width: 2, height: 35, color: const Color(0xFFCDEAC0)),
              Container(width: 2, height: 22, color: const Color(0xFFCDEAC0)),
            ],
          ),
        ],
      );
    } else if (microbe.id == 'saccharomyces') {
      // Tape: Budding Yeast cells (Saccharomyces cerevisiae)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildYeastCell(radius: 20, hasBud: true),
          const SizedBox(width: 12),
          _buildYeastCell(radius: 16, hasBud: false),
          const SizedBox(width: 8),
          _buildYeastCell(radius: 18, hasBud: true),
        ],
      );
    } else if (microbe.id == 'aspergillus_sp' || microbe.id == 'aspergillus_oryzae') {
      // Koji / Amylase: Conidiophore stalk with radiating conidiospores
      final isKoji = microbe.id == 'aspergillus_oryzae';
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildConidialHead(isKoji: isKoji),
          Container(
            width: 3.5,
            height: 32,
            color: isKoji ? const Color(0xFFD4E09B) : const Color(0xFFE0E0E0),
          ),
        ],
      );
    } else if (microbe.id == 'tetragenococcus') {
      // Halophilic bacteria: Tetrad clusters (groups of 4 spherical cocci)
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          _buildTetradGroup(),
          _buildTetradGroup(),
          _buildTetradGroup(),
        ],
      );
    } else if (microbe.id == 'neurospora') {
      // Oncom: Coral-orange macroconidia chains on branching hyphae
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOrangeSporeChain(),
              const SizedBox(width: 14),
              _buildOrangeSporeChain(),
            ],
          ),
          Container(width: 100, height: 3, color: const Color(0xFFFFB703)),
        ],
      );
    } else {
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: List.generate(
          6,
          (i) => Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: AppColors.goldenYellow,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildSporangium() {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF2E1C11),
            border: Border.fromBorderSide(BorderSide(color: AppColors.sageLight, width: 1.5)),
          ),
          child: const Center(
            child: Icon(Icons.grain, color: AppColors.goldenYellow, size: 14),
          ),
        ),
        Container(
          width: 3,
          height: 20,
          color: const Color(0xFFCDEAC0),
        ),
      ],
    );
  }

  Widget _buildYeastCell({required double radius, required bool hasBud}) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            color: const Color(0xFF6B9080),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white70, width: 1.5),
          ),
          child: const Center(
            child: Icon(Icons.circle, color: Colors.white38, size: 8),
          ),
        ),
        if (hasBud)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: radius * 0.9,
              height: radius * 0.9,
              decoration: BoxDecoration(
                color: const Color(0xFFA4C3B2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildConidialHead({required bool isKoji}) {
    final headColor = isKoji ? const Color(0xFF8DAA51) : const Color(0xFF708D81);
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: headColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white70, width: 1.2),
          ),
        ),
        const Icon(Icons.flare_rounded, color: AppColors.goldenYellow, size: 24),
      ],
    );
  }

  Widget _buildTetradGroup() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Wrap(
        spacing: 2,
        runSpacing: 2,
        alignment: WrapAlignment.center,
        children: List.generate(
          4,
          (i) => Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFF5390D9),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrangeSporeChain() {
    return Column(
      children: List.generate(
        3,
        (i) => Container(
          width: 12,
          height: 10,
          margin: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFFB8500),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white60, width: 0.8),
          ),
        ),
      ),
    );
  }
}
