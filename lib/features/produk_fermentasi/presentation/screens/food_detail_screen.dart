import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/ethno_card.dart';
import '../../../../core/widgets/module_nav_bar.dart';
import '../../../../core/widgets/app_drawer.dart';
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

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _caseStudyController;
  bool _showHypothesisGuide = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    final savedAns = ref.read(userProgressProvider).caseStudyAnswers[widget.foodId] ?? '';
    _caseStudyController = TextEditingController(text: savedAns);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProgressProvider.notifier).markModuleCompleted(widget.foodId, xpBonus: 40);
    });
  }

  @override
  void didUpdateWidget(covariant FoodDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.foodId != widget.foodId) {
      final savedAns = ref.read(userProgressProvider).caseStudyAnswers[widget.foodId] ?? '';
      _caseStudyController.text = savedAns;
      _showHypothesisGuide = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(userProgressProvider.notifier).markModuleCompleted(widget.foodId, xpBonus: 40);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        return '/produk/kecap';
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

    return Scaffold(
      drawer: const AppDrawer(),
      bottomNavigationBar: ModuleNavBar(
        currentSlide: slideNum,
        totalSlides: 12,
        prevRoute: prevRoute,
        nextRoute: nextRoute,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (ctx, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 220.0,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primaryDark,
              leading: Builder(
                builder: (c) => IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => context.go(prevRoute),
                ),
              ),
              actions: [
                Builder(
                  builder: (c) => IconButton(
                    icon: const Icon(Icons.menu_rounded, color: Colors.white),
                    onPressed: () => Scaffold.of(c).openDrawer(),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  food.name,
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    shadows: const [
                      Shadow(color: Colors.black87, blurRadius: 8),
                    ],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      food.heroImage,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(color: AppColors.primaryGreen),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.4),
                            Colors.black.withValues(alpha: 0.75),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 48,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.warmTerracotta,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              food.region,
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              food.localName,
                              style: const TextStyle(color: AppColors.warmCream, fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColors.primaryGreen,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primaryGreen,
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: '1. Olahan Kuliner'),
                      Tab(text: '2. Kearifan Lokal'),
                      Tab(text: '3. Alur Proses'),
                      Tab(text: '4. Etnosains'),
                      Tab(text: '5. Nilai Sains'),
                      Tab(text: '6. Studi Kasus (PBL)'),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTab1Olahan(food),
            _buildTab2Kearifan(food),
            _buildTab3AlurProses(food),
            _buildTab4Etnosains(food),
            _buildTab5NilaiSains(food),
            _buildTab6StudiKasus(food),
          ],
        ),
      ),
    );
  }

  // TAB 1: OLAHAN TRADISIONAL
  Widget _buildTab1Olahan(FermentedFoodEntity food) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.restaurant_rounded, color: AppColors.warmTerracotta),
              const SizedBox(width: 8),
              Text('Hidangan & Kuliner Turunan', style: AppTextStyles.h2.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Produk fermentasi ini diolah kembali oleh masyarakat menjadi berbagai kuliner khas:',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 14),

          // Raw Material Banner
          EthnoCard(
            padding: const EdgeInsets.all(14),
            backgroundColor: AppColors.warmCream.withValues(alpha: 0.5),
            borderColor: AppColors.goldenYellow,
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined, color: AppColors.terracottaDark),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bahan Baku Utama:', style: AppTextStyles.tagText.copyWith(color: AppColors.terracottaDark)),
                      const SizedBox(height: 2),
                      Text(food.rawMaterial, style: AppTextStyles.bodyBold.copyWith(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Dishes list
          ...food.traditionalDishes.map((dish) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: EthnoCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.sageLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.dinner_dining_rounded, color: AppColors.primaryGreen, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        dish,
                        style: AppTextStyles.bodyBold.copyWith(fontSize: 13, color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),
          // Microbes involved in this food
          Text('Mikroorganisme Kunci yang Berperan:', style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryGreen)),
          const SizedBox(height: 8),
          ...food.microorganisms.map((m) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.biotech, size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(m, style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic)),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // TAB 2: JEJAK KEARIFAN LOKAL
  Widget _buildTab2Kearifan(FermentedFoodEntity food) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history_edu_rounded, color: AppColors.terracottaDark),
              const SizedBox(width: 8),
              Text('Jejak Praktik & Kebiasaan Leluhur', style: AppTextStyles.h2.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Kearifan asli masyarakat Sunda dan Jawa yang diwariskan turun-temurun:',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 14),

          EthnoCard(
            padding: const EdgeInsets.all(18),
            backgroundColor: AppColors.warmCream.withValues(alpha: 0.6),
            borderColor: AppColors.goldenYellow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.eco_rounded, color: AppColors.primaryGreen, size: 22),
                    const SizedBox(width: 8),
                    Text('Warisan Budaya Pengolahan', style: AppTextStyles.h3.copyWith(fontSize: 15, color: AppColors.primaryDark)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  food.localWisdom,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 13.5, height: 1.6),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Cultural facts banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.sageLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_rounded, color: AppColors.primaryGreen, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tahukah Kamu?', style: AppTextStyles.tagText.copyWith(color: AppColors.primaryDark)),
                      const SizedBox(height: 4),
                      Text(
                        'Banyak pantangan tradisional (seperti larangan berbicara saat menabur ragi atau keharusan ruangan gelap) sebenarnya adalah metode penjagaan sterilisasi dan suhu lingkungan mikroba secara intuitif.',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: ALUR PROSES FERMENTASI (STEPPER)
  Widget _buildTab3AlurProses(FermentedFoodEntity food) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.linear_scale_rounded, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Text('Alur Prosedur Kerja Step-by-Step', style: AppTextStyles.h2.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Langkah demi langkah pembuatan dengan penjelasan kontekstual ilmiah:',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 16),

          ...food.processSteps.map((step) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14.0),
              child: EthnoCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${step.stepNumber}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            step.title,
                            style: AppTextStyles.bodyBold.copyWith(fontSize: 13, color: AppColors.primaryDark),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      step.description,
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 12.5),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.sageLight.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.science_outlined, size: 16, color: AppColors.primaryGreen),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Konteks Biologis: ${step.biologicalContext}',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (step.tip != null) ...[
                      const SizedBox(height: 6),
                      Text('💡 Tips: ${step.tip}', style: AppTextStyles.tagText.copyWith(color: AppColors.warmTerracotta, fontSize: 11)),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // TAB 4: REKONSTRUKSI ETNOSAINS
  Widget _buildTab4Etnosains(FermentedFoodEntity food) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.compare_arrows_rounded, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Text('Rekonstruksi Sains Asli -> Sains Ilmiah', style: AppTextStyles.h2.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Menerjemahkan kearifan nenek moyang ke dalam prinsip biologi modern:',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 14),

          EthnoCard(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.white,
            borderColor: AppColors.primaryGreen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'KONSEP ETNOSAINS',
                    style: AppTextStyles.tagText.copyWith(color: Colors.white, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  food.ethnoscienceConcept,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 13.5, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 5: NILAI SAINS BIOLOGIS
  Widget _buildTab5NilaiSains(FermentedFoodEntity food) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.biotech_rounded, color: AppColors.warmTerracotta),
              const SizedBox(width: 8),
              Text('Penjelasan Biokimia & Nutrisi', style: AppTextStyles.h2.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Perubahan molekuler dan metabolisme enzimatis yang terjadi selama fermentasi:',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 14),

          EthnoCard(
            padding: const EdgeInsets.all(16),
            backgroundColor: AppColors.creamLight,
            borderColor: AppColors.warmTerracotta,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bubble_chart_rounded, color: AppColors.warmTerracotta),
                    const SizedBox(width: 8),
                    Text('Transformasi Biokimia', style: AppTextStyles.h3.copyWith(color: AppColors.terracottaDark, fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  food.modernScienceValue,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 13.5, height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 6: STUDI KASUS PBL (PROBLEM-BASED LEARNING)
  Widget _buildTab6StudiKasus(FermentedFoodEntity food) {
    final caseStudy = food.caseStudy;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment_rounded, color: AppColors.primaryDark),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Studi Kasus Lapangan (PBL)', style: AppTextStyles.h2.copyWith(fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Analisis kasus nyata di masyarakat menggunakan pendekatan metode ilmiah:',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 14),

          // Story Card
          EthnoCard(
            padding: const EdgeInsets.all(16),
            backgroundColor: AppColors.warmCream,
            borderColor: AppColors.goldenYellow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(caseStudy.title, style: AppTextStyles.h3.copyWith(fontSize: 14, color: AppColors.primaryDark)),
                const SizedBox(height: 8),
                Text(
                  caseStudy.storyContext,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Problem Question
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.sageLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pertanyaan Penelitian:', style: AppTextStyles.tagText.copyWith(color: AppColors.primaryGreen)),
                const SizedBox(height: 4),
                Text(caseStudy.researchQuestion, style: AppTextStyles.bodyBold.copyWith(fontSize: 13)),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Interactive Student Answer
          Text('Tuliskan Analisis Hipotesis & Solusimu:', style: AppTextStyles.bodyBold),
          const SizedBox(height: 6),
          TextField(
            controller: _caseStudyController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Tentukan variabel dan rancang hipotesis berdasarkan konsep ilmiah...',
              hintStyle: AppTextStyles.bodySmall,
            ),
            onChanged: (val) {
              ref.read(userProgressProvider.notifier).saveCaseStudyAnswer(widget.foodId, val);
            },
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                icon: Icon(
                  _showHypothesisGuide ? Icons.visibility_off : Icons.visibility,
                  size: 18,
                  color: AppColors.terracottaDark,
                ),
                label: Text(
                  _showHypothesisGuide ? 'Tutup Kunci Pembahasan' : 'Buka Kunci Pembahasan Ilmiah',
                  style: AppTextStyles.tagText.copyWith(color: AppColors.terracottaDark),
                ),
                onPressed: () {
                  setState(() {
                    _showHypothesisGuide = !_showHypothesisGuide;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(userProgressProvider.notifier).saveCaseStudyAnswer(widget.foodId, _caseStudyController.text);
                  ref.read(userProgressProvider.notifier).addXP(25);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Jawaban studi kasus tersimpan! (+25 XP)'),
                      backgroundColor: AppColors.primaryGreen,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text('Simpan'),
              ),
            ],
          ),

          if (_showHypothesisGuide) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryGreen, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pembahasan Ilmiah Resmi:', style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryGreen)),
                  const SizedBox(height: 6),
                  Text('• Variabel Bebas: ${caseStudy.manipulatedVariable}', style: AppTextStyles.bodySmall),
                  Text('• Variabel Terikat: ${caseStudy.respondingVariable}', style: AppTextStyles.bodySmall),
                  Text('• Variabel Kontrol: ${caseStudy.controlledVariables}', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 6),
                  Text('• Penjelasan Konseptual: ${caseStudy.scientificExplanation}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
