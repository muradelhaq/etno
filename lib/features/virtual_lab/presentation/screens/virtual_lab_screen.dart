import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

class _VirtualLabScreenState extends ConsumerState<VirtualLabScreen> {
  double _yeastPercent = 1.0;
  int _fermentationDays = 2;
  bool _isBananaLeaf = true;
  bool _showProcedureGuide = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProgressProvider.notifier).markModuleCompleted('virtual_lab', xpBonus: 50);
    });
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
      appBar: const CustomAppBar(
        title: 'Virtual Lab Fermentasi',
        subtitle: 'Slide 9 / 12 • Simulasi Kadar Glukosa Tape',
      ),
      bottomNavigationBar: const ModuleNavBar(
        currentSlide: 9,
        totalSlides: 12,
        prevRoute: '/jelajah-budaya',
        nextRoute: '/challenge-proyek',
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
                  const Icon(Icons.science_rounded, color: AppColors.goldenYellow, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Laboratorium Bioteknologi Virtual', style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 15)),
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
            ).animate().fadeIn(duration: 400.ms),

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

            // Section 1: Digital Glucometer & Organoleptic Display
            EthnoCard(
              padding: const EdgeInsets.all(18),
              backgroundColor: const Color(0xFF1B2A24),
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
                          style: const TextStyle(color: AppColors.goldenYellow, fontSize: 10, fontFamily: 'monospace'),
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
                      border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.4), width: 1.5),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'KADAR GLUKOSA TAPE',
                          style: AppTextStyles.tagText.copyWith(color: Colors.white60, fontSize: 10, letterSpacing: 1.5),
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
                              style: TextStyle(color: Colors.white70, fontSize: 22, fontWeight: FontWeight.bold),
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
                              style: TextStyle(color: AppColors.sageLight, fontSize: 10, fontWeight: FontWeight.bold),
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
                            const Text('Rating Sensori:', style: TextStyle(color: Colors.white70, fontSize: 11)),
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
            ).animate().fadeIn(duration: 400.ms),

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

            // Section 3: Dynamic Chart (FL Chart)
            Text('Kurva Dinamika Kadar Glukosa (Hari 1 - 5)', style: AppTextStyles.h2.copyWith(fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              'Grafik fluktuasi kadar glukosa hasil pemecahan amilum & konversi etanol:',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 14),

            EthnoCard(
              padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
              backgroundColor: Colors.white,
              child: SizedBox(
                height: 200,
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
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (val, meta) => Text(
                            'Hari ${val.toInt()}',
                            style: const TextStyle(color: AppColors.primaryDark, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                          return FlSpot((d['day'] as int).toDouble(), d['glucose'] as double);
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
                  Text('Persamaan Biokimia Fermentasi Tape:', style: AppTextStyles.tagText.copyWith(color: AppColors.terracottaDark)),
                  const SizedBox(height: 6),
                  Text(
                    '1. Sakarifikasi: Pati (Amilum) + H₂O ──[Amilase]──> Glukosa (Manis)\n'
                    '2. Fermentasi Alkohol: Glukosa ──[Khamir / S. cerevisiae]──> 2 Etanol + 2 CO₂ + 2 ATP',
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
      ),
    );
  }

  Widget _buildSensoryRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.sageLight),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(color: AppColors.sageLight, fontWeight: FontWeight.bold, fontSize: 11)),
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
          Text('Prosedur Praktikum Resmi:', style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryGreen)),
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
    ).animate().fadeIn(duration: 300.ms);
  }
}
