import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/ethno_card.dart';
import '../../../../core/widgets/module_nav_bar.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../shared/services/local_storage_service.dart';
import '../../data/models/glucose_experiment_model.dart';

class VirtualLabScreen extends ConsumerStatefulWidget {
  const VirtualLabScreen({super.key});

  @override
  ConsumerState<VirtualLabScreen> createState() => _VirtualLabScreenState();
}

class _VirtualLabScreenState extends ConsumerState<VirtualLabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _yeastPercent = 1.0;
  int _fermentationDays = 2;
  bool _isBananaLeaf = true;
  bool _showProcedureGuide = false;

  // Mini-Game State (Misi 1, 2, 3)
  int _gameScore = 0;
  final Map<String, String?> _microbeMatches = {
    'Rhizopus oligosporus': null,
    'Saccharomyces cerevisiae': null,
    'Aspergillus oryzae': null,
  };
  final Map<String, String> _correctMicrobe = {
    'Rhizopus oligosporus': 'Tempe Kedelai',
    'Saccharomyces cerevisiae': 'Tape Singkong',
    'Aspergillus oryzae': 'Tauco Cianjur',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProgressProvider.notifier).markModuleCompleted('virtual_lab', xpBonus: 50);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final simulation = GlucoseLabEngine.simulate(
      _yeastPercent,
      _fermentationDays,
      isBananaLeaf: _isBananaLeaf,
    );

    final trendData = GlucoseLabEngine.getDayComparisonData(_yeastPercent);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: CustomAppBar(
        title: 'Virtual Lab & Game Interaktif',
        subtitle: 'Slide 9 / 12 • Simulasi Glukosa & Tantangan Misi',
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryGreen,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryGreen,
          tabs: const [
            Tab(icon: Icon(Icons.science_rounded), text: 'Simulasi Lab Glukosa'),
            Tab(icon: Icon(Icons.sports_esports_rounded), text: 'Game Misi Sains'),
          ],
        ),
      ),
      bottomNavigationBar: const ModuleNavBar(
        currentSlide: 9,
        totalSlides: 12,
        prevRoute: '/jelajah-budaya',
        nextRoute: '/challenge-proyek',
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSimulatorTab(simulation, trendData),
          _buildGameTab(),
        ],
      ),
    );
  }

  // TAB 1: SIMULATOR LAB GLUKOSA TAPE
  Widget _buildSimulatorTab(
      GlucoseExperimentPoint simulation, List<Map<String, dynamic>> trendData) {
    return SingleChildScrollView(
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
                const Icon(Icons.science_rounded, color: AppColors.goldenYellow, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Laboratorium Bioteknologi Virtual',
                          style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(
                        'Uji pengaruh konsentrasi ragi dan lama fermentasi terhadap kadar glukosa tape singkong secara empiris.',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.sageLight),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Toggle Procedure Guide Button
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _showProcedureGuide = !_showProcedureGuide;
              });
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              side: const BorderSide(color: AppColors.primaryGreen, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(
              _showProcedureGuide ? Icons.expand_less : Icons.assignment_outlined,
              color: AppColors.primaryGreen,
              size: 18,
            ),
            label: Text(
              _showProcedureGuide ? 'Sembunyikan Prosedur Praktikum' : 'Lihat Prosedur Praktikum Lengkap',
              style: AppTextStyles.tagText.copyWith(color: AppColors.primaryGreen),
            ),
          ),

          if (_showProcedureGuide) ...[
            const SizedBox(height: 12),
            _buildProcedureGuideCard(),
          ],

          const SizedBox(height: 18),

          // Section 1: Digital Glucometer Display
          EthnoCard(
            padding: const EdgeInsets.all(18),
            backgroundColor: const Color(0xFF14241D),
            borderColor: AppColors.primaryLight,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.successGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'DIGITAL GLUCOMETER PRO',
                          style: AppTextStyles.scientificFormula.copyWith(
                            color: AppColors.sageLight,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        'Ragi ${_yeastPercent.toStringAsFixed(1)}% • Hari $_fermentationDays',
                        style: const TextStyle(
                            color: AppColors.goldenYellow,
                            fontSize: 10,
                            fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // LED Big Readout
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.primaryLight.withValues(alpha: 0.4), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'KADAR GLUKOSA TAPE',
                        style: AppTextStyles.tagText.copyWith(
                            color: Colors.white60, fontSize: 10, letterSpacing: 1.5),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            simulation.glucoseLevel.toStringAsFixed(2),
                            style: AppTextStyles.scientificData.copyWith(
                              fontSize: 44,
                              color: simulation.glucoseLevel >= 50.0
                                  ? AppColors.goldenYellow
                                  : AppColors.primaryLight,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '%',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (simulation.glucoseLevel >= 51.14) ...[
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.successGreen, width: 1),
                          ),
                          child: const Text(
                            '★ Memenuhi Standar Mutu Prima Jawa Barat (>51,14%) ★',
                            style: TextStyle(
                                color: AppColors.sageLight,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Organoleptic Sensory Summary
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSensoryRow('Rasa', simulation.tasteProfile, Icons.emoji_emotions_rounded),
                      const SizedBox(height: 6),
                      _buildSensoryRow('Aroma', simulation.aromaProfile, Icons.air_rounded),
                      const SizedBox(height: 6),
                      _buildSensoryRow('Tekstur', simulation.textureProfile, Icons.touch_app_rounded),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Rating Sensori:',
                              style: TextStyle(color: Colors.white70, fontSize: 11)),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                Icons.star_rounded,
                                size: 18,
                                color: i < simulation.organolepticRating
                                    ? AppColors.goldenYellow
                                    : Colors.white24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section 2: Interactive Controls
          Text('Pengaturan Variabel Eksperimen', style: AppTextStyles.h2.copyWith(fontSize: 16)),
          const SizedBox(height: 10),

          EthnoCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Yeast Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Konsentrasi Ragi:', style: AppTextStyles.bodyBold),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.sageLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_yeastPercent.toStringAsFixed(1)}% (${(_yeastPercent * 9.0).toStringAsFixed(1)} g)',
                        style: AppTextStyles.tagText.copyWith(color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _yeastPercent,
                  min: 0.5,
                  max: 1.5,
                  divisions: 2,
                  activeColor: AppColors.primaryGreen,
                  inactiveColor: AppColors.sageLight,
                  onChanged: (v) {
                    setState(() {
                      _yeastPercent = v;
                    });
                  },
                ),

                const SizedBox(height: 12),

                // 2. Days Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Lama Fermentasi (Hari):', style: AppTextStyles.bodyBold),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.warmCream,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.goldenYellow),
                      ),
                      child: Text(
                        '$_fermentationDays Hari',
                        style: AppTextStyles.tagText.copyWith(color: AppColors.terracottaDark),
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: _fermentationDays.toDouble(),
                  min: 1.0,
                  max: 5.0,
                  divisions: 4,
                  activeColor: AppColors.warmTerracotta,
                  inactiveColor: AppColors.warmCream,
                  onChanged: (v) {
                    setState(() {
                      _fermentationDays = v.toInt();
                    });
                  },
                ),

                const SizedBox(height: 12),

                // 3. Container Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Wadah Pemeraman:', style: AppTextStyles.bodyBold),
                          Text(
                            _isBananaLeaf
                                ? 'Alas Daun Pisang (Sirkulasi Mikro Alami)'
                                : 'Wadah Plastik Kedap Udara',
                            style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isBananaLeaf,
                      activeThumbColor: AppColors.primaryGreen,
                      onChanged: (v) {
                        setState(() {
                          _isBananaLeaf = v;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section 3: Visual Comparison Bars & Chart
          Text('Perbandingan Kadar Glukosa Harian (Hari 1 - 5)',
              style: AppTextStyles.h2.copyWith(fontSize: 16)),
          const SizedBox(height: 6),
          Text(
            'Visualisasi data empiris kadar glukosa hasil fermentasi pada dosis ragi ${_yeastPercent.toStringAsFixed(1)}%:',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),

          // Custom High-Res Visual Bar Columns
          EthnoCard(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.white,
            child: Column(
              children: trendData.map((d) {
                final int day = d['day'] as int;
                final double gl = d['glucose'] as double;
                final bool isCurrentDay = day == _fermentationDays;
                final bool isPeak = gl >= 50.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hari ke-$day ${isCurrentDay ? '📍 (Dipilih)' : ''}',
                            style: AppTextStyles.bodyBold.copyWith(
                              fontSize: 12,
                              color: isCurrentDay
                                  ? AppColors.primaryGreen
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${gl.toStringAsFixed(2)}%',
                            style: AppTextStyles.scientificData.copyWith(
                              fontSize: 13,
                              color: isPeak
                                  ? AppColors.terracottaDark
                                  : AppColors.primaryGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Stack(
                        children: [
                          Container(
                            height: 12,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.sageLight.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: (gl / 60.0).clamp(0.05, 1.0),
                            child: Container(
                              height: 12,
                              decoration: BoxDecoration(
                                gradient: isPeak
                                    ? AppColors.warmGradient
                                    : AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Dynamic Line Chart (FL Chart)
          EthnoCard(
            padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
            backgroundColor: Colors.white,
            child: SizedBox(
              height: 180,
              width: double.infinity,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        interval: 10,
                        getTitlesWidget: (val, meta) => Text(
                          '${val.toInt()}%',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (val, meta) => Text(
                          'H${val.toInt()}',
                          style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    topTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  minX: 1,
                  maxX: 5,
                  minY: 10,
                  maxY: 60,
                  lineBarsData: [
                    LineChartBarData(
                      spots: trendData.map((d) {
                        return FlSpot(
                            (d['day'] as int).toDouble(), d['glucose'] as double);
                      }).toList(),
                      isCurved: true,
                      color: AppColors.primaryGreen,
                      barWidth: 3.5,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primaryGreen.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Biochemical equation banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.warmCream,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.goldenYellow),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Persamaan Biokimia Fermentasi Tape:',
                    style: AppTextStyles.tagText.copyWith(color: AppColors.terracottaDark)),
                const SizedBox(height: 6),
                Text(
                  '1. Sakarifikasi: Pati (Amilum) + H₂O ──[Amilase]──> Glukosa (Manis)\n'
                  '2. Fermentasi Alkohol: Glukosa ──[S. cerevisiae]──> 2 Etanol + 2 CO₂ + 2 ATP',
                  style: AppTextStyles.scientificFormula.copyWith(fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          CustomButton(
            text: 'Lanjut ke Tantangan Proyek Etnosains',
            icon: Icons.arrow_forward_rounded,
            isFullWidth: true,
            backgroundColor: AppColors.primaryGreen,
            onPressed: () {
              context.go('/challenge-proyek');
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // TAB 2: GAME INTERAKTIF MISI SAINS
  Widget _buildGameTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Game Header Score Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.warmGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Game Interaktif Etnosains',
                        style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text('Kumpulkan poin dan selesaikan seluruh misi!',
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white70)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.military_tech_rounded, color: AppColors.goldenYellow, size: 24),
                      const SizedBox(width: 6),
                      Text('$_gameScore XP',
                          style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Misi 1: Cocokkan Mikroorganisme
          Text('Misi 1: Pasangkan Mikroba dengan Produk Fermentasi',
              style: AppTextStyles.h2.copyWith(fontSize: 15)),
          const SizedBox(height: 10),

          ..._microbeMatches.keys.map((microbe) {
            final selected = _microbeMatches[microbe];
            final isCorrect = selected == _correctMicrobe[microbe];

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: EthnoCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🔬 $microbe',
                        style: AppTextStyles.bodyBold.copyWith(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: AppColors.primaryDark)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['Tempe Kedelai', 'Tape Singkong', 'Tauco Cianjur'].map((prod) {
                        final isThisSelected = selected == prod;
                        return ChoiceChip(
                          label: Text(prod, style: const TextStyle(fontSize: 11)),
                          selected: isThisSelected,
                          selectedColor: isCorrect ? AppColors.successGreen : AppColors.errorRed,
                          onSelected: (sel) {
                            if (sel) {
                              setState(() {
                                _microbeMatches[microbe] = prod;
                                if (prod == _correctMicrobe[microbe]) {
                                  _gameScore += 30;
                                }
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 16),

          CustomButton(
            text: 'Simpan Poin Game & Lanjut',
            icon: Icons.check_circle_outline_rounded,
            isFullWidth: true,
            backgroundColor: AppColors.primaryGreen,
            onPressed: () {
              ref.read(userProgressProvider.notifier).addXP(_gameScore);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Poin game ($_gameScore XP) berhasil ditambahkan ke profil belajarmu!'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSensoryRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.sageLight),
        const SizedBox(width: 8),
        Text('$label: ',
            style: const TextStyle(
                color: AppColors.sageLight, fontWeight: FontWeight.bold, fontSize: 11)),
        Expanded(
          child: Text(value, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ),
      ],
    );
  }

  Widget _buildProcedureGuideCard() {
    return EthnoCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      borderColor: AppColors.primaryGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Prosedur Praktikum Resmi:',
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryGreen)),
          const SizedBox(height: 8),
          Text(
            '1. Singkong (900 g) dipotong rapi dan dicuci bersih hingga getah hilang.\n'
            '2. Kukus singkong selama 30 menit hingga matang empuk.\n'
            '3. Dinginkan singkong secara merata di atas tampah hingga suhu kamar.\n'
            '4. Inokulasikan ragi tape halus sesuai perlakuan:\n'
            '   • Kelompok A (0,5%): Tambahkan 4,5 g ragi.\n'
            '   • Kelompok B (1,0%): Tambahkan 9,0 g ragi.\n'
            '   • Kelompok C (1,5%): Tambahkan 13,5 g ragi.\n'
            '5. Masukkan ke wadah tertutup beralas daun pisang dan simpan pada suhu ruang.\n'
            '6. Ukur kadar glukosa dan uji organoleptik pada hari ke-1, 2, dan 3.',
            style: AppTextStyles.bodySmall.copyWith(fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }
}
