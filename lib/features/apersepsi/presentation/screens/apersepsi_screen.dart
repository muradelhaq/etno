import 'dart:ui';
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
import '../../data/models/food_comparison_model.dart';

class ApersepsiScreen extends ConsumerStatefulWidget {
  const ApersepsiScreen({super.key});

  @override
  ConsumerState<ApersepsiScreen> createState() => _ApersepsiScreenState();
}

class _ApersepsiScreenState extends ConsumerState<ApersepsiScreen> {
  late TextEditingController _reflectionController;
  final Map<String, String?> _matchedAnswers = {
    'Orek Tempe': null,
    'Tempe Mendoan': null,
    'Es Goyobod Peuyeum': null,
    'Es Tape Ketan': null,
    'Martabak Tape Ketan': null,
    'Sayur Ikan Tauco': null,
  };

  final Map<String, String> _correctKeys = {
    'Orek Tempe': 'Tempe',
    'Tempe Mendoan': 'Tempe',
    'Es Goyobod Peuyeum': 'Tape Singkong',
    'Es Tape Ketan': 'Tape Ketan',
    'Martabak Tape Ketan': 'Tape Ketan',
    'Sayur Ikan Tauco': 'Tauco',
  };

  final List<String> _fermentationOptions = [
    'Tempe',
    'Tape Singkong',
    'Tape Ketan',
    'Tauco',
    'Oncom',
  ];

  @override
  void initState() {
    super.initState();
    final currentReflect = ref.read(userProgressProvider).apersepsiReflection;
    _reflectionController = TextEditingController(text: currentReflect);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProgressProvider.notifier).markModuleCompleted('apersepsi', xpBonus: 30);
    });
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  void _checkMatchingAnswers() {
    int correctCount = 0;
    _matchedAnswers.forEach((food, selected) {
      if (selected == _correctKeys[food]) {
        correctCount++;
      }
    });

    if (correctCount == _matchedAnswers.length) {
      ref.read(userProgressProvider.notifier).addXP(50);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.successGreen),
              const SizedBox(width: 8),
              Text('Luar Biasa!', style: AppTextStyles.h3),
            ],
          ),
          content: const Text(
            'Semua makanan tradisional berhasil kamu pasangkan dengan tepat ke bahan dasar fermentasinya! (+50 XP)',
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Lanjut Belajar'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kamu berhasil mencocokkan $correctCount dari ${_matchedAnswers.length} makanan dengan benar. Periksa kembali pilihanmu!'),
          backgroundColor: AppColors.warmTerracotta,
        ),
      );
    }
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
            // Section 1 Header
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

            // Comparison Tabs / Grid
            Text('1. Galeri Kuliner Modern vs Tradisional', style: AppTextStyles.h2.copyWith(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              'Klik kartu makanan di bawah untuk melihat rincian bahan dan proses fermentasinya:',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 12),

            // Modern Foods Grid (1 baris 4 card)
            Text('Makanan Cepat Saji Modern (Global):', style: AppTextStyles.bodyBold.copyWith(color: AppColors.warmTerracotta)),
            const SizedBox(height: 8),
            _buildFoodGrid(ApersepsiData.modernFoods, isModern: true),

            const SizedBox(height: 18),

            // Traditional Foods Grid (4 per baris, flow ke bawah)
            Text('Makanan Tradisional Nusantara (Lokal):', style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryGreen)),
            const SizedBox(height: 8),
            _buildFoodGrid(ApersepsiData.traditionalFoods, isModern: false),

            const SizedBox(height: 24),
            const Divider(color: AppColors.borderSubtle),
            const SizedBox(height: 14),

            // Section 2: Interactive Matching
            Text('2. Tantangan: Cocokkan Makanan dengan Bahan Fermentasinya', style: AppTextStyles.h2.copyWith(fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              'Pilih produk fermentasi dasar yang sesuai untuk setiap hidangan tradisional di bawah ini:',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 14),

            EthnoCard(
              padding: const EdgeInsets.all(16),
              backgroundColor: AppColors.warmCream.withValues(alpha: 0.4),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 550;
                  final itemWidth =
                      isWide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;

                  return Wrap(
                    spacing: 16,
                    runSpacing: 6,
                    children: _matchedAnswers.keys.map((foodName) {
                      final selected = _matchedAnswers[foodName];
                      final isCorrect = selected == _correctKeys[foodName];

                      return SizedBox(
                        width: itemWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Row(
                                  children: [
                                    Icon(
                                      selected == null
                                          ? Icons.radio_button_unchecked
                                          : (isCorrect
                                              ? Icons.check_circle
                                              : Icons.cancel),
                                      size: 18,
                                      color: selected == null
                                          ? Colors.grey
                                          : (isCorrect
                                              ? AppColors.successGreen
                                              : AppColors.errorRed),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        foodName,
                                        style: AppTextStyles.bodyBold
                                            .copyWith(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 5,
                                child: DropdownButtonFormField<String>(
                                  initialValue: selected,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: selected == null
                                            ? AppColors.borderSubtle
                                            : (isCorrect
                                                ? AppColors.successGreen
                                                : AppColors.errorRed),
                                      ),
                                    ),
                                  ),
                                  hint: Text('Pilih Produk...',
                                      style: AppTextStyles.bodySmall),
                                  items: _fermentationOptions.map((opt) {
                                    return DropdownMenuItem(
                                      value: opt,
                                      child: Text(opt,
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(fontSize: 12)),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _matchedAnswers[foodName] = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _checkMatchingAnswers,
                icon: const Icon(Icons.task_alt_rounded, size: 18),
                label: const Text('Cek Jawaban Cocok'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(color: AppColors.borderSubtle),
            const SizedBox(height: 14),

            // Section 3: Reflection Input
            Text('3. Refleksi Kritis & Kolom Pendapat Siswa', style: AppTextStyles.h2.copyWith(fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warmCream,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.goldenYellow),
              ),
              child: Text(
                'Pertanyaan: "Mengapa banyak generasi muda saat ini lebih mengenal Pizza, Burger, atau Kimchi dibandingkan Colenak, Combro, dan Oncom? Menurutmu bagaimana cara membuatnya diminati kembali?"',
                style: AppTextStyles.bodyBold.copyWith(
                  color: AppColors.terracottaDark,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 14),

            TextField(
              controller: _reflectionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tuliskan pendapat atau analisis pribadimu di sini...',
                hintStyle: AppTextStyles.bodySmall,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.borderSubtle),
                ),
              ),
              onChanged: (val) {
                ref.read(userProgressProvider.notifier).saveApersepsiReflection(val);
              },
            ),

            const SizedBox(height: 14),

            CustomButton(
              text: 'Simpan Pendapat & Lanjut ke Peta Konsep',
              icon: Icons.arrow_forward_rounded,
              isFullWidth: true,
              backgroundColor: AppColors.primaryGreen,
              onPressed: () {
                ref.read(userProgressProvider.notifier).saveApersepsiReflection(_reflectionController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pendapatmu berhasil disimpan! (+30 XP)'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
                context.go('/peta-konsep');
              },
            ),

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

        // Dynamic aspect ratio: taller cards on mobile portrait so multiline text fits nicely
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
            return _buildFoodChipCard(items[i],
                isModern: isModern, isLandscape: isLandscape);
          },
        );
      },
    );
  }

  Widget _buildFoodChipCard(FoodItemModel item,
      {required bool isModern, bool isLandscape = false}) {
    return EthnoCard(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      borderColor: isModern
          ? AppColors.warmTerracotta.withValues(alpha: 0.3)
          : AppColors.primaryGreen.withValues(alpha: 0.3),
      onTap: () => _showFoodDetailDialog(context, item, isModern),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Full-bleed Image
            Image.asset(
              item.imageAsset,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.warmCream,
                child: Center(
                  child: Icon(
                    isModern
                        ? Icons.fastfood_rounded
                        : Icons.rice_bowl_rounded,
                    size: isLandscape ? 36 : 28,
                    color: isModern
                        ? AppColors.warmTerracotta
                        : AppColors.primaryGreen,
                  ),
                ),
              ),
            ),

            // Gradient shade overlay for contrast
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.1),
                      Colors.black.withValues(alpha: 0.70),
                    ],
                    stops: const [0.25, 0.55, 1.0],
                  ),
                ),
              ),
            ),

            // Semi-transparent badge for text
            Positioned(
              left: isLandscape ? 6 : 4,
              right: isLandscape ? 6 : 4,
              bottom: isLandscape ? 6 : 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isLandscape ? 7 : 5,
                      vertical: isLandscape ? 5 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.60),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 0.7,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isLandscape ? 12 : 9.5,
                            height: 1.15,
                            shadows: const [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          softWrap: true,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.baseFermentationProduct,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontSize: isLandscape ? 9.5 : 8.0,
                            fontWeight: FontWeight.w400,
                            height: 1.15,
                            shadows: const [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFoodDetailDialog(
      BuildContext context, FoodItemModel item, bool isModern) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isLandscape =
            MediaQuery.of(ctx).orientation == Orientation.landscape;
        final size = MediaQuery.of(ctx).size;

        if (isLandscape) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            clipBehavior: Clip.antiAlias,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              width: (size.width * 0.75).clamp(480.0, 650.0),
              height: (size.height * 0.85).clamp(240.0, 360.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left: Full Photo
                  Expanded(
                    flex: 5,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          item.imageAsset,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.warmCream,
                            child: Center(
                              child: Icon(
                                isModern
                                    ? Icons.fastfood_rounded
                                    : Icons.rice_bowl_rounded,
                                size: 48,
                                color: isModern
                                    ? AppColors.warmTerracotta
                                    : AppColors.primaryGreen,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right: Info & Description
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: AppTextStyles.h3.copyWith(fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isModern
                                      ? AppColors.warmCream
                                      : AppColors.sageLight,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isModern
                                        ? AppColors.goldenYellow
                                        : AppColors.primaryGreen,
                                  ),
                                ),
                                child: Text(
                                  item.category,
                                  style: AppTextStyles.tagText.copyWith(
                                    color: isModern
                                        ? AppColors.terracottaDark
                                        : AppColors.primaryDark,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Basis Mikroba / Fermentasi:',
                            style: AppTextStyles.tagText.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            item.baseFermentationProduct,
                            style: AppTextStyles.bodyBold.copyWith(
                              fontSize: 12.5,
                              color: isModern
                                  ? AppColors.terracottaDark
                                  : AppColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Text(
                                item.description,
                                style: AppTextStyles.bodyMedium
                                    .copyWith(fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isModern
                                    ? AppColors.warmTerracotta
                                    : AppColors.primaryGreen,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Tutup',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Portrait Dialog
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          clipBehavior: Clip.antiAlias,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    item.imageAsset,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: AppColors.warmCream,
                      child: Center(
                        child: Icon(
                          isModern
                              ? Icons.fastfood_rounded
                              : Icons.rice_bowl_rounded,
                          size: 48,
                          color: isModern
                              ? AppColors.warmTerracotta
                              : AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(item.name, style: AppTextStyles.h3),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isModern
                                    ? AppColors.warmCream
                                    : AppColors.sageLight,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isModern
                                      ? AppColors.goldenYellow
                                      : AppColors.primaryGreen,
                                ),
                              ),
                              child: Text(
                                item.category,
                                style: AppTextStyles.tagText.copyWith(
                                  color: isModern
                                      ? AppColors.terracottaDark
                                      : AppColors.primaryDark,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Basis Mikroba / Fermentasi:',
                          style: AppTextStyles.tagText.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          item.baseFermentationProduct,
                          style: AppTextStyles.bodyBold.copyWith(
                            fontSize: 13,
                            color: isModern
                                ? AppColors.terracottaDark
                                : AppColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(item.description, style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 14),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isModern
                                  ? AppColors.warmTerracotta
                                  : AppColors.primaryGreen,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Tutup',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
