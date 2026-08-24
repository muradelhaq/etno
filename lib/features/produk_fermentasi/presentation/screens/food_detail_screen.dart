import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/ethno_scaffold.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../domain/entities/fermented_food_entity.dart';
import '../../data/models/fermented_foods_data.dart';

class FoodDetailScreen extends ConsumerStatefulWidget {
  final String foodId;

  const FoodDetailScreen({
    super.key,
    required this.foodId,
  });

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  late TextEditingController _caseStudyController;
  bool _showHypothesisGuide = false;
  bool _isCaseStudyExpanded = false;

  @override
  void initState() {
    super.initState();
    final savedAns =
        ref.read(userProgressProvider).caseStudyAnswers[widget.foodId] ?? '';
    _caseStudyController = TextEditingController(text: savedAns);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(userProgressProvider.notifier)
          .markModuleCompleted(widget.foodId, xpBonus: 40);
    });
  }

  @override
  void didUpdateWidget(covariant FoodDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.foodId != widget.foodId) {
      final savedAns =
          ref.read(userProgressProvider).caseStudyAnswers[widget.foodId] ?? '';
      _caseStudyController.text = savedAns;
      _showHypothesisGuide = false;
      _isCaseStudyExpanded = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(userProgressProvider.notifier)
            .markModuleCompleted(widget.foodId, xpBonus: 40);
      });
    }
  }

  @override
  void dispose() {
    _caseStudyController.dispose();
    super.dispose();
  }

  int _getSlideNumber(String id) {
    switch (id) {
      case 'tempe':
        return 4;
      case 'tape':
        return 5;
      case 'tape-ketan':
        return 6;
      case 'tauco':
      case 'kecap':
        return 7;
      default:
        return 4;
    }
  }

  String _getPrevRoute(String id) {
    switch (id) {
      case 'tempe':
        return '/peta-konsep';
      case 'tape':
        return '/produk/tempe';
      case 'tape-ketan':
        return '/produk/tape';
      case 'tauco':
        return '/produk/tape-ketan';
      case 'kecap':
        return '/produk/tauco';
      default:
        return '/peta-konsep';
    }
  }

  String _getNextRoute(String id) {
    switch (id) {
      case 'tempe':
        return '/produk/tape';
      case 'tape':
        return '/produk/tape-ketan';
      case 'tape-ketan':
        return '/produk/tauco';
      case 'tauco':
        return '/jelajah-budaya';
      case 'kecap':
        return '/jelajah-budaya';
      default:
        return '/jelajah-budaya';
    }
  }

  @override
  Widget build(BuildContext context) {
    final food = FermentedFoodsData.allFoods.firstWhere(
      (f) => f.id == widget.foodId,
      orElse: () => FermentedFoodsData.allFoods.first,
    );

    final slideNum = _getSlideNumber(food.id);
    final prevRoute = _getPrevRoute(food.id);
    final nextRoute = _getNextRoute(food.id);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return EthnoScaffold(
      title: '${food.name.toUpperCase()} & MAKANAN TRADISIONAL',
      subtitle: 'Slide $slideNum / 12 • Modul Pembelajaran Etnosains',
      currentSlide: slideNum,
      totalSlides: 12,
      prevRoute: prevRoute,
      nextRoute: nextRoute,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isLandscape ? 20 : 12,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TOP HEADER BANNER
            _buildTopHeaderBanner(food, slideNum),

            const SizedBox(height: 14),

            // MAIN CONTENT (SIDE BY SIDE IN LANDSCAPE, STACKED IN PORTRAIT)
            if (isLandscape)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // LEFT COLUMN: PROCESS FLOWCHART
                  Expanded(
                    flex: 5,
                    child: _buildProcessBox(context, food),
                  ),
                  const SizedBox(width: 14),

                  // RIGHT COLUMN: ETNOSAINS & TRADITIONAL FOODS
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildEthnoscienceBox(context, food),
                        const SizedBox(height: 14),
                        _buildTraditionalFoodsBox(context, food),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProcessBox(context, food),
                  const SizedBox(height: 14),
                  _buildEthnoscienceBox(context, food),
                  const SizedBox(height: 14),
                  _buildTraditionalFoodsBox(context, food),
                ],
              ),

            const SizedBox(height: 14),

            // TAHUKAH KAMU BANNER
            _buildDidYouKnowBanner(food),

            const SizedBox(height: 14),

            // INQUIRY CASE STUDY (PBL) ACCORDION
            _buildCaseStudyAccordion(context, food),

            const SizedBox(height: 16),

            // NEXT NAVIGATION BUTTON
            CustomButton(
              text: food.id == 'tempe'
                  ? 'Lanjut ke Modul Produk 2: Tape Singkong'
                  : 'Lanjut ke Modul Pembelajaran Berikutnya',
              icon: Icons.arrow_forward_rounded,
              isFullWidth: true,
              backgroundColor: AppColors.primaryGreen,
              onPressed: () => context.go(nextRoute),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 1. TOP HEADER BANNER
  Widget _buildTopHeaderBanner(FermentedFoodEntity food, int slideNum) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD6E8D0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Badge Number (e.g. 4)
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF2D5A3C),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$slideNum',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Title
          Expanded(
            child: Text(
              food.id == 'tempe'
                  ? 'TEMPE DAN MAKANAN TRADISIONAL'
                  : '${food.name.toUpperCase()} DAN MAKANAN TRADISIONAL',
              style: const TextStyle(
                color: Color(0xFF1E3A2B),
                fontWeight: FontWeight.w900,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Leaf Icon
          const Icon(
            Icons.eco_rounded,
            color: Color(0xFF5A8E65),
            size: 24,
          ),
        ],
      ),
    );
  }

  // 2. PROCESS FLOWCHART BOX (PROSES FERMENTASI)
  Widget _buildProcessBox(BuildContext context, FermentedFoodEntity food) {
    final steps = food.id == 'tempe'
        ? _getTempeProcessSteps()
        : _getGenericProcessSteps(food);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD6E8D0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Pill
          _buildHeaderPill(
            food.id == 'tempe'
                ? 'PROSES FERMENTASI TEMPE'
                : 'PROSES FERMENTASI ${food.name.toUpperCase()}',
          ),
          const SizedBox(height: 12),

          // Steps vertical list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            separatorBuilder: (ctx, i) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: Center(
                child: Icon(
                  Icons.arrow_downward_rounded,
                  size: 16,
                  color: Color(0xFF4C7C54),
                ),
              ),
            ),
            itemBuilder: (ctx, i) {
              final step = steps[i];
              return _buildStepItem(context, step);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, _ProcessStepItem step) {
    return InkWell(
      onTap: () => _showStepDetailDialog(context, step),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDF8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFD6E8D0).withValues(alpha: 0.7),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            // Step Illustration (Image or Fallback Icon)
            if (step.imageAsset != null)
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  step.imageAsset!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _buildStepIcon(step.iconType),
                ),
              )
            else
              _buildStepIcon(step.iconType),
            const SizedBox(width: 12),

            // Step Label
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: const TextStyle(
                      color: Color(0xFF1E3A2B),
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                    ),
                  ),
                  if (step.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      step.subtitle!,
                      style: TextStyle(
                        color: const Color(0xFF4C7C54).withValues(alpha: 0.9),
                        fontSize: 10.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Icon(
              Icons.info_outline_rounded,
              size: 16,
              color: Color(0xFF4C7C54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIcon(_StepIconType type) {
    IconData icon;
    Color color;
    Color bg;

    switch (type) {
      case _StepIconType.kedelai:
        icon = Icons.grain_rounded;
        color = const Color(0xFFD4A373);
        bg = const Color(0xFFFAEDCD);
        break;
      case _StepIconType.perendaman:
        icon = Icons.water_drop_rounded;
        color = const Color(0xFF457B9D);
        bg = const Color(0xFFE0FBFC);
        break;
      case _StepIconType.perebusan:
        icon = Icons.soup_kitchen_rounded;
        color = const Color(0xFFE76F51);
        bg = const Color(0xFFFFDDD2);
        break;
      case _StepIconType.ragi:
        icon = Icons.scatter_plot_rounded;
        color = const Color(0xFF2A9D8F);
        bg = const Color(0xFFE8F5E9);
        break;
      case _StepIconType.pembungkusan:
        icon = Icons.eco_rounded;
        color = const Color(0xFF5A8E65);
        bg = const Color(0xFFD6E8D0);
        break;
      case _StepIconType.fermentasi:
        icon = Icons.hourglass_bottom_rounded;
        color = const Color(0xFF6B705C);
        bg = const Color(0xFFEDF2F4);
        break;
      case _StepIconType.tempe:
        icon = Icons.crop_square_rounded;
        color = const Color(0xFF2D5A3C);
        bg = const Color(0xFFFFF3DB);
        break;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.2),
      ),
      child: Center(
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  // 3. KONSEP ETNOSAINS BOX
  Widget _buildEthnoscienceBox(BuildContext context, FermentedFoodEntity food) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD6E8D0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Pill
          _buildHeaderPill('KONSEP ETNOSAINS'),
          const SizedBox(height: 10),

          // 2 Columns: Pengetahuan Lokal vs Konsep Sains
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column 1: Pengetahuan Lokal
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDF8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD6E8D0),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSubHeaderPill('Pengetahuan Lokal'),
                      const SizedBox(height: 8),
                      _buildBulletPoint(
                        'Tempe dibungkus daun agar tidak lembek dan sirkulasi udara baik.',
                      ),
                      const SizedBox(height: 6),
                      _buildBulletPoint(
                        'Fermentasi 2 hari pada suhu ruang.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Column 2: Konsep Sains
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDF8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD6E8D0),
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSubHeaderPill('Konsep Sains'),
                      const SizedBox(height: 8),
                      _buildBulletPoint(
                        'Kapang Rhizopus oligosporus tumbuh, membentuk miselium menyatukan biji kedelai.',
                      ),
                      const SizedBox(height: 8),

                      // Microbe Circular Diagram from Infographic
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 68,
                              height: 68,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFF3F8F2),
                                border: Border.all(
                                  color: const Color(0xFF2D5A3C),
                                  width: 1.5,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/tempe_rhizopus_diagram.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.biotech, color: AppColors.primaryGreen),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Rhizopus oligosporus',
                              style: TextStyle(
                                color: Color(0xFF1E3A2B),
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 4. MAKANAN TRADISIONAL BOX
  Widget _buildTraditionalFoodsBox(
      BuildContext context, FermentedFoodEntity food) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD6E8D0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Pill
          _buildHeaderPill('MAKANAN TRADISIONAL'),
          const SizedBox(height: 10),

          // 2 Traditional Food Cards (Orek Tempe & Mendoan)
          Row(
            children: [
              // Card 1: Orek Tempe
              Expanded(
                child: _buildFoodProductCard(
                  context: context,
                  title: 'OREK TEMPE',
                  imageAsset: 'assets/images/food_orek_tempe_slide.png',
                  description:
                      'Potongan tempe yang ditumis gurih manis dengan kecap dan bumbu rempah aromatik Nusantara.',
                  culinaryScience:
                      'Proses karamelisasi gula kecap dan asam amino hasil fermentasi tempe menciptakan rasa gurih umami yang kaya.',
                ),
              ),
              const SizedBox(width: 10),

              // Card 2: Mendoan
              Expanded(
                child: _buildFoodProductCard(
                  context: context,
                  title: 'MENDOAN',
                  imageAsset: 'assets/images/food_mendoan_slide.png',
                  description:
                      'Tempe tipis khas Banyumas dibalut adonan tepung beras berbumbu dan digoreng mendo (setengah matang).',
                  culinaryScience:
                      'Penggorengan singkat menjaga miselium tempe tetap lembut legit serta mempertahankan aroma khas kapang Rhizopus.',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodProductCard({
    required BuildContext context,
    required String title,
    required String imageAsset,
    required String description,
    required String culinaryScience,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD6E8D0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Food Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
            child: Image.asset(
              imageAsset,
              height: 95,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 95,
                color: const Color(0xFFFAF7EE),
                child: const Center(
                  child: Icon(Icons.fastfood_rounded,
                      color: AppColors.warmTerracotta, size: 28),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Food Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1E3A2B),
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 0.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 6),

          // Green Button: Klik untuk info
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showFoodInfoDialog(
                  context,
                  title: title,
                  imageAsset: imageAsset,
                  description: description,
                  culinaryScience: culinaryScience,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C7C54),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Klik untuk info',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 5. TAHUKAH KAMU BANNER
  Widget _buildDidYouKnowBanner(FermentedFoodEntity food) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFFFE0A3),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tahukah Kamu? Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFAEDCD),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD4A373), width: 1.0),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lightbulb_rounded,
                    color: Color(0xFFD4A373), size: 14),
                SizedBox(width: 4),
                Text(
                  'Tahukah Kamu?',
                  style: TextStyle(
                    color: Color(0xFF7F5539),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Fact description
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Color(0xFF2C3E50),
                  fontSize: 11.5,
                  height: 1.35,
                ),
                children: [
                  TextSpan(
                    text: '${food.name} ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A2B),
                    ),
                  ),
                  TextSpan(
                    text: food.id == 'tempe'
                        ? 'merupakan sumber protein nabati tinggi dan mudah dicerna tubuh berkat enzim protease kapang Rhizopus.'
                        : 'mengandung enzim alami hasil fermentasi mikroba yang meningkatkan cita rasa dan nilai cerna nutrisinya.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 6. INQUIRY CASE STUDY (PBL) ACCORDION
  Widget _buildCaseStudyAccordion(
      BuildContext context, FermentedFoodEntity food) {
    final caseStudy = food.caseStudy;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ExpansionTile(
          initiallyExpanded: _isCaseStudyExpanded,
          onExpansionChanged: (exp) {
            setState(() {
              _isCaseStudyExpanded = exp;
            });
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.sageLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.assignment_rounded,
                color: AppColors.primaryGreen, size: 20),
          ),
          title: Text(
            'Studi Kasus Inkuiri Ilmiah (PBL)',
            style: AppTextStyles.h3.copyWith(fontSize: 14),
          ),
          subtitle: Text(
            caseStudy.title,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Story Context
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warmCream.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      caseStudy.storyContext,
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontSize: 12, height: 1.45),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Research Question
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.sageLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pertanyaan Penelitian:',
                          style: AppTextStyles.tagText
                              .copyWith(color: AppColors.primaryGreen),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          caseStudy.researchQuestion,
                          style: AppTextStyles.bodyBold.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Student Answer Input
                  Text(
                    'Tuliskan Analisis Hipotesis & Solusimu:',
                    style: AppTextStyles.bodyBold.copyWith(fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _caseStudyController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText:
                          'Tentukan variabel bebas, terikat, dan hipotesis ilmiahmu...',
                      hintStyle: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                      filled: true,
                      fillColor: const Color(0xFFFAF7EE),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.borderSubtle),
                      ),
                    ),
                    onChanged: (val) {
                      ref
                          .read(userProgressProvider.notifier)
                          .saveCaseStudyAnswer(widget.foodId, val);
                    },
                  ),
                  const SizedBox(height: 10),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        icon: Icon(
                          _showHypothesisGuide
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 16,
                          color: AppColors.terracottaDark,
                        ),
                        label: Text(
                          _showHypothesisGuide
                              ? 'Tutup Kunci'
                              : 'Buka Kunci Pembahasan',
                          style: AppTextStyles.tagText
                              .copyWith(color: AppColors.terracottaDark),
                        ),
                        onPressed: () {
                          setState(() {
                            _showHypothesisGuide = !_showHypothesisGuide;
                          });
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(userProgressProvider.notifier)
                              .saveCaseStudyAnswer(
                                widget.foodId,
                                _caseStudyController.text,
                              );
                          ref.read(userProgressProvider.notifier).addXP(25);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Jawaban studi kasus tersimpan! (+25 XP)'),
                              backgroundColor: AppColors.primaryGreen,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Simpan'),
                      ),
                    ],
                  ),

                  // Guided Answer
                  if (_showHypothesisGuide) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.primaryGreen, width: 1.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kunci Analisis Ilmiah:',
                            style: AppTextStyles.bodyBold.copyWith(
                                color: AppColors.primaryGreen, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text('• Variabel Bebas: ${caseStudy.manipulatedVariable}',
                              style: const TextStyle(fontSize: 11)),
                          Text(
                              '• Variabel Terikat: ${caseStudy.respondingVariable}',
                              style: const TextStyle(fontSize: 11)),
                          Text(
                              '• Variabel Kontrol: ${caseStudy.controlledVariables}',
                              style: const TextStyle(fontSize: 11)),
                          const SizedBox(height: 4),
                          Text(
                            '• Penjelasan: ${caseStudy.scientificExplanation}',
                            style: const TextStyle(
                                fontSize: 11, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 250.ms),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DIALOG DETAILS
  void _showStepDetailDialog(BuildContext context, _ProcessStepItem step) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            if (step.imageAsset != null)
              Container(
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  step.imageAsset!,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => _buildStepIcon(step.iconType),
                ),
              )
            else
              _buildStepIcon(step.iconType),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                step.title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step.description,
              style: const TextStyle(fontSize: 12.5, height: 1.45),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF81C784)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.biotech_rounded,
                          size: 14, color: AppColors.primaryGreen),
                      SizedBox(width: 4),
                      Text(
                        'Penjelasan Sains Biologi:',
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
                    step.biologicalExplanation,
                    style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF1E3A2B),
                        height: 1.35),
                  ),
                ],
              ),
            ),
          ],
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

  void _showFoodInfoDialog(
    BuildContext context, {
    required String title,
    required String imageAsset,
    required String description,
    required String culinaryScience,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
                                  height: 1.35),
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
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // REUSABLE PILLS
  Widget _buildHeaderPill(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFD6E8D0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF1E3A2B),
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSubHeaderPill(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE4F0E0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2D5A3C),
            fontWeight: FontWeight.w800,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(
            color: Color(0xFF2D5A3C),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF2C3E50),
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  // STEP DATA
  List<_ProcessStepItem> _getTempeProcessSteps() {
    return const [
      _ProcessStepItem(
        title: 'Kedelai',
        imageAsset: 'assets/images/tempe_step1_kedelai.png',
        iconType: _StepIconType.kedelai,
        description:
            'Pemilihan biji kedelai kuning (Glycine max) berkualitas tinggi yang utuh dan bersih.',
        biologicalExplanation:
            'Biji kedelai kaya akan protein globulin (glisinin & konglisinin) dan lipid yang menjadi substrat utama kapang.',
      ),
      _ProcessStepItem(
        title: 'Perendaman',
        imageAsset: 'assets/images/tempe_step2_perendaman.png',
        iconType: _StepIconType.perendaman,
        description:
            'Kedelai direndam dalam air bersih selama 12–24 jam pada suhu ruang.',
        biologicalExplanation:
            'Terjadi hidrasi biji dan fermentasi asam laktat alami yang menurunkan pH kedelai ke 4.5–5.0, menghambat bakteri patogen pembusuk.',
      ),
      _ProcessStepItem(
        title: 'Perebusan',
        imageAsset: 'assets/images/tempe_step3_perebusan.png',
        iconType: _StepIconType.perebusan,
        description:
            'Kedelai direbus dalam air mendidih hingga melunak, lalu kulit ari dikupas.',
        biologicalExplanation:
            'Suhu tinggi mendenaturasi zat antigizi antitripsin dan menginaktivasi enzim lipoksigenase penyebab bau langu.',
      ),
      _ProcessStepItem(
        title: 'Pemberian Ragi',
        subtitle: '(Rhizopus oligosporus)',
        imageAsset: 'assets/images/tempe_step4_ragi.png',
        iconType: _StepIconType.ragi,
        description:
            'Kedelai ditiriskan hingga kering dan dingin (suhu ruang), lalu diinokulasi spora kapang tempe.',
        biologicalExplanation:
            'Inokulasi harus pada suhu kamar (<32°C) agar spora tidak rusak akibat panas.',
      ),
      _ProcessStepItem(
        title: 'Pembungkusan',
        subtitle: '(daun/ plastik berlubang)',
        imageAsset: 'assets/images/tempe_step5_bungkus.png',
        iconType: _StepIconType.pembungkusan,
        description:
            'Kedelai beragi dibungkus daun pisang atau plastik dengan lubang jarum ventilasi mikro.',
        biologicalExplanation:
            'Kapang Rhizopus bersifat aerob obligat; pori daun/lubang plastik menyediakan suplai oksigen mikro yang terkendali.',
      ),
      _ProcessStepItem(
        title: 'Fermentasi 36-48 jam',
        imageAsset: 'assets/images/tempe_step6_fermentasi.png',
        iconType: _StepIconType.fermentasi,
        description:
            'Paket tempe diperam di tempat hangat dan gelap pada suhu 28–32°C selama 36–48 jam.',
        biologicalExplanation:
            'Miselium kapang tumbuh lebat merajut kedelai menjadi satu kesatuan padat sambil menyekresikan enzim protease dan lipase.',
      ),
      _ProcessStepItem(
        title: 'Tempe',
        imageAsset: 'assets/images/tempe_step7_tempe.png',
        iconType: _StepIconType.tempe,
        description:
            'Tempe matang dengan miselium putih padat beraroma khas siap dikonsumsi atau diolah.',
        biologicalExplanation:
            'Protein kedelai telah terhidrolisis menjadi asam amino bebas sehingga daya cerna meningkat hingga >85% dan kaya vitamin B12.',
      ),
    ];
  }

  List<_ProcessStepItem> _getGenericProcessSteps(FermentedFoodEntity food) {
    return food.processSteps.map((s) {
      return _ProcessStepItem(
        title: s.title,
        iconType: s.stepNumber == 1
            ? _StepIconType.kedelai
            : (s.stepNumber == 2
                ? _StepIconType.perebusan
                : (s.stepNumber == 3
                    ? _StepIconType.ragi
                    : _StepIconType.tempe)),
        description: s.description,
        biologicalExplanation: s.biologicalContext,
      );
    }).toList();
  }
}

enum _StepIconType {
  kedelai,
  perendaman,
  perebusan,
  ragi,
  pembungkusan,
  fermentasi,
  tempe,
}

class _ProcessStepItem {
  final String title;
  final String? subtitle;
  final String? imageAsset;
  final _StepIconType iconType;
  final String description;
  final String biologicalExplanation;

  const _ProcessStepItem({
    required this.title,
    this.subtitle,
    this.imageAsset,
    required this.iconType,
    required this.description,
    required this.biologicalExplanation,
  });
}
