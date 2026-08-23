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

class PetaKonsepScreen extends ConsumerStatefulWidget {
  const PetaKonsepScreen({super.key});

  @override
  ConsumerState<PetaKonsepScreen> createState() => _PetaKonsepScreenState();
}

class _PetaKonsepScreenState extends ConsumerState<PetaKonsepScreen> {
  double _microscopeZoom = 100.0;
  String _selectedMicrobeId = 'rhizopus';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProgressProvider.notifier).markModuleCompleted('peta_konsep', xpBonus: 40);
    });
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
                      Text(
                        'Pohon Konsep Fermentasi Tradisional',
                        style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hubungan antara 5 Produk Induk Fermentasi, Mikroba Agens, dan Kuliner Turunan Nusantara:',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.sageLight),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 16),

            // Concept tree visual chips
            _buildConceptTreeCards(),

            const SizedBox(height: 24),
            const Divider(color: AppColors.borderSubtle),
            const SizedBox(height: 14),

            // Section 2: Virtual Microscope Simulator
            Row(
              children: [
                const Icon(Icons.biotech_rounded, color: AppColors.primaryGreen, size: 24),
                const SizedBox(width: 8),
                Text('2. Simulator Mikroskop Virtual', style: AppTextStyles.h2.copyWith(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Pilih mikroba dan geser perbesaran lensa objektif untuk mengamati struktur seluler miselium & khamir:',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 14),

            // Microbe selector tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: MicroorganismData.microbes.map((m) {
                  final isSelected = m.id == _selectedMicrobeId;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(m.scientificName.split(' ').take(2).join(' ')),
                      selected: isSelected,
                      selectedColor: AppColors.primaryGreen,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      onSelected: (sel) {
                        if (sel) {
                          setState(() {
                            _selectedMicrobeId = m.id;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 14),

            // Microscope Viewport Box
            EthnoCard(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.black87,
              borderColor: AppColors.primaryGreen,
              child: Column(
                children: [
                  // Lens Circle Visualizer
                  Center(
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF10281E),
                        border: Border.all(color: AppColors.primaryLight, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Crosshair lines
                          const Divider(color: Colors.white24, thickness: 1),
                          const VerticalDivider(color: Colors.white24, thickness: 1),

                          // Animated Microbe representation
                          _buildMicroscopicView(activeMicrobe, _microscopeZoom),

                          // Zoom indicator badge
                          Positioned(
                            top: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.goldenYellow, width: 1),
                              ),
                              child: Text(
                                '${_microscopeZoom.toInt()}x Perbesaran',
                                style: AppTextStyles.scientificFormula.copyWith(
                                  color: AppColors.goldenYellow,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Slider magnification
                  Row(
                    children: [
                      const Text('100x', style: TextStyle(color: Colors.white70, fontSize: 11)),
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
                      const Text('1000x', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),

                  // Active Microbe Details Card inside Dark Theme
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              activeMicrobe.scientificName,
                              style: const TextStyle(
                                color: AppColors.warmCream,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.warmTerracotta,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                activeMicrobe.kingdomType.split(' ').first,
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Produk Target: ${activeMicrobe.targetProduct}',
                          style: const TextStyle(color: AppColors.goldenYellow, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          activeMicrobe.primaryFunction,
                          style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Ciri Mikroskopik: ${activeMicrobe.microscopicFeature}',
                          style: const TextStyle(color: AppColors.sageLight, fontSize: 11, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Divider(color: AppColors.borderSubtle),
            const SizedBox(height: 14),

            // Section 3: Microorganisms Database Grid
            Text('3. Kartu Karakteristik Lengkap 6 Mikroba Utama', style: AppTextStyles.h2.copyWith(fontSize: 16)),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: MicroorganismData.microbes.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 10),
              itemBuilder: (ctx, i) {
                final microbe = MicroorganismData.microbes[i];
                return EthnoCard(
                  padding: const EdgeInsets.all(14),
                  backgroundColor: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              microbe.scientificName,
                              style: AppTextStyles.bodyBold.copyWith(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.sageLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              microbe.targetProduct,
                              style: AppTextStyles.tagText.copyWith(
                                color: AppColors.primaryDark,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Peran Biokimia: ${microbe.biochemicalRole}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
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

  Widget _buildConceptTreeCards() {
    final List<Map<String, dynamic>> conceptItems = [
      {
        'product': 'Tempe Kedelai',
        'microbe': 'Rhizopus oligosporus',
        'dishes': 'Mendoan, Orek Tempe, Keripik',
        'color': AppColors.primaryGreen,
        'icon': Icons.grass_rounded,
        'route': '/produk/tempe',
      },
      {
        'product': 'Tape Singkong',
        'microbe': 'Saccharomyces cerevisiae & Aspergillus',
        'dishes': 'Colenak, Peuyeum, Es Goyobod',
        'color': AppColors.warmTerracotta,
        'icon': Icons.bakery_dining_rounded,
        'route': '/produk/tape',
      },
      {
        'product': 'Tape Ketan',
        'microbe': 'Amylomyces & Saccharomyces',
        'dishes': 'Es Tape Ketan, Martabak Ketan',
        'color': AppColors.goldenYellow,
        'icon': Icons.rice_bowl_rounded,
        'route': '/produk/tape-ketan',
      },
      {
        'product': 'Tauco Cianjur',
        'microbe': 'Aspergillus oryzae & Tetragenococcus',
        'dishes': 'Sayur Ikan Tauco, Tumis Kangkung',
        'color': AppColors.terracottaDark,
        'icon': Icons.soup_kitchen_rounded,
        'route': '/produk/tauco',
      },
      {
        'product': 'Kecap & Oncom',
        'microbe': 'Neurospora sitophila & A. oryzae',
        'dishes': 'Tutug Oncom, Combro, Sate Maranggi',
        'color': AppColors.primaryDark,
        'icon': Icons.restaurant_menu_rounded,
        'route': '/produk/kecap',
      },
    ];

    return Column(
      children: conceptItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: EthnoCard(
            padding: const EdgeInsets.all(12),
            onTap: () => context.go(item['route']),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['product'] as String, style: AppTextStyles.bodyBold.copyWith(fontSize: 13)),
                      Text(
                        '🔬 ${item['microbe']}',
                        style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '🍲 ${item['dishes']}',
                        style: AppTextStyles.tagText.copyWith(color: AppColors.warmTerracotta, fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textLight),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMicroscopicView(MicroorganismModel microbe, double zoom) {
    final scale = (zoom / 250.0).clamp(0.8, 3.5);

    if (microbe.id == 'rhizopus') {
      // Mycelium network with sporangium heads
      return Transform.scale(
        scale: scale,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSporangium(),
                const SizedBox(width: 20),
                _buildSporangium(),
              ],
            ),
            Container(
              width: 140,
              height: 4,
              color: Colors.white60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(width: 2, height: 35, color: Colors.white70),
                Container(width: 2, height: 45, color: Colors.white70),
                Container(width: 2, height: 30, color: Colors.white70),
              ],
            ),
          ],
        ),
      );
    } else if (microbe.id == 'saccharomyces') {
      // Budding Yeast cells
      return Transform.scale(
        scale: scale,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildYeastCell(radius: 22, hasBud: true),
            const SizedBox(width: 16),
            _buildYeastCell(radius: 18, hasBud: false),
            const SizedBox(width: 10),
            _buildYeastCell(radius: 20, hasBud: true),
          ],
        ),
      );
    } else {
      // Generic fungal spores / bacteria
      return Transform.scale(
        scale: scale,
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: List.generate(
            8,
            (i) => Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: i % 2 == 0 ? AppColors.goldenYellow : AppColors.primaryLight,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.white24, blurRadius: 4),
                ],
              ),
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
          color: Colors.white70,
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
}
