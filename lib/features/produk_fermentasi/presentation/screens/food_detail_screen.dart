import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/slide_navigation_guard.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/ethno_scaffold.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../data/models/fermented_foods_data.dart';
import '../widgets/sections/food_top_header_banner.dart';
import '../widgets/sections/food_process_flowchart_section.dart';
import '../widgets/sections/food_ethnoscience_section.dart';
import '../widgets/sections/food_traditional_dishes_section.dart';
import '../widgets/sections/food_did_you_know_banner.dart';
import '../widgets/sections/food_case_study_accordion.dart';

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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
      ref
          .read(userProgressProvider.notifier)
          .markModuleCompleted(widget.foodId, xpBonus: 40);
    });
  }

  @override
  void didUpdateWidget(covariant FoodDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.foodId != widget.foodId) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0.0);
        }
        ref
            .read(userProgressProvider.notifier)
            .markModuleCompleted(widget.foodId, xpBonus: 40);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
        key: ValueKey('food_detail_scroll_${widget.foodId}'),
        controller: _scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: isLandscape ? 20 : 12,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Top Header Banner
            FoodTopHeaderBanner(food: food, slideNum: slideNum),
            const SizedBox(height: 14),

            // 2. Main Content (Side by side in landscape, stacked in portrait)
            if (isLandscape)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: FoodProcessFlowchartSection(food: food),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FoodEthnoscienceSection(food: food),
                        const SizedBox(height: 14),
                        FoodTraditionalDishesSection(food: food),
                      ],
                    ),
                  ),
                ],
              )
            else ...[
              FoodProcessFlowchartSection(food: food),
              const SizedBox(height: 14),
              FoodEthnoscienceSection(food: food),
              const SizedBox(height: 14),
              FoodTraditionalDishesSection(food: food),
            ],

            const SizedBox(height: 14),

            // 3. Did You Know Banner
            FoodDidYouKnowBanner(food: food),
            const SizedBox(height: 14),

            // 4. Inquiry Case Study (PBL) Accordion
            FoodCaseStudyAccordion(food: food),
            const SizedBox(height: 16),

            // 5. Next Navigation Button
            CustomButton(
              text: food.id == 'tempe'
                  ? 'Lanjut ke Modul Produk 2: Tape Singkong'
                  : 'Lanjut ke Modul Pembelajaran Berikutnya',
              icon: Icons.arrow_forward_rounded,
              isFullWidth: true,
              backgroundColor: AppColors.primaryGreen,
              onPressed: () => navigateToNextSlide(
                context,
                ref,
                currentSlide: slideNum,
                route: nextRoute,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
