import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/custom_button.dart';
import 'package:e_modul_etnosains/core/widgets/custom_app_bar.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_scaffold.dart';
import 'package:e_modul_etnosains/core/utils/slide_navigation_guard.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';
import 'package:e_modul_etnosains/core/services/supabase_service.dart';
import '../../data/models/glucose_experiment_model.dart';
import '../widgets/simulator/procedure_guide_card.dart';
import '../widgets/simulator/digital_glucometer_display.dart';
import '../widgets/simulator/lab_control_sliders.dart';
import '../widgets/simulator/chemical_reaction_formula_box.dart';
import '../widgets/charts/dynamic_glucose_line_chart.dart';
import '../widgets/game/virtual_lab_game_tab.dart';

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
  bool _isSavingLab = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _recordLabExperiment(GlucoseExperimentPoint simulation) async {
    final user = ref.read(userProgressProvider);
    setState(() => _isSavingLab = true);

    final observationData = {
      'yeast_percent': _yeastPercent,
      'fermentation_days': _fermentationDays,
      'is_banana_leaf': _isBananaLeaf,
      'container_type':
          _isBananaLeaf ? 'Daun Pisang (Alami)' : 'Plastik Kedap Udara',
      'glucose_level': simulation.glucoseLevel,
      'taste_profile': simulation.tasteProfile,
      'aroma_profile': simulation.aromaProfile,
      'texture_profile': simulation.textureProfile,
      'organoleptic_rating': simulation.organolepticRating,
      'meets_standard': simulation.glucoseLevel >= 51.14,
    };

    final conclusion = simulation.glucoseLevel >= 51.14
        ? 'Konsentrasi ragi ${_yeastPercent.toStringAsFixed(1)}% pada hari ke-$_fermentationDays dengan wadah ${_isBananaLeaf ? "daun pisang" : "plastik"} menghasilkan kadar glukosa optimal ${simulation.glucoseLevel.toStringAsFixed(2)}% (memenuhi standar mutu prima >51,14%).'
        : 'Konsentrasi ragi ${_yeastPercent.toStringAsFixed(1)}% pada hari ke-$_fermentationDays menghasilkan kadar glukosa ${simulation.glucoseLevel.toStringAsFixed(2)}% dengan profil rasa ${simulation.tasteProfile}.';

    final success = await SupabaseService.saveLabRecord(
      userId: user.studentId,
      studentName: user.studentName.isNotEmpty ? user.studentName : 'Siswa',
      experimentType: 'Simulasi Lab Glukosa Tape Singkong',
      observationData: observationData,
      conclusion: conclusion,
    );

    await ref
        .read(userProgressProvider.notifier)
        .markModuleCompleted('virtual_lab', xpBonus: 25);

    if (mounted) {
      setState(() => _isSavingLab = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  success
                      ? 'Hasil uji lab berhasil direkam ke Cloud & Portofolio Siswa (+25 XP)!'
                      : 'Hasil uji lab tersimpan lokal (+25 XP)!',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primaryGreen,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(userProgressProvider);
    final missionGameCompleted =
        progress.completedModules.contains('virtual_lab_game');
    final simulation = GlucoseLabEngine.simulate(
      _yeastPercent,
      _fermentationDays,
      isBananaLeaf: _isBananaLeaf,
    );

    final trendData = GlucoseLabEngine.getDayComparisonData(_yeastPercent);

    return EthnoScaffold(
      customAppBar: CustomAppBar(
        title: 'Virtual Lab & Game Interaktif',
        subtitle: 'Slide 9 / 12 • Simulasi Glukosa & Tantangan Misi',
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryGreen,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryGreen,
          tabs: const [
            Tab(
                icon: Icon(Icons.science_rounded),
                text: 'Simulasi Lab Glukosa'),
            Tab(
                icon: Icon(Icons.sports_esports_rounded),
                text: 'Game Misi Sains'),
          ],
        ),
      ),
      currentSlide: 9,
      totalSlides: 12,
      prevRoute: '/jelajah-budaya',
      nextRoute: '/challenge-proyek',
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSimulatorTab(simulation, trendData, missionGameCompleted),
          const VirtualLabGameTab(),
        ],
      ),
    );
  }

  Widget _buildMissionReminder() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warmCream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.warmTerracotta, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.warmTerracotta, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Misi Sains belum selesai',
                    style: AppTextStyles.bodyBold.copyWith(
                        color: AppColors.terracottaDark, fontSize: 14)),
                const SizedBox(height: 3),
                Text(
                  'Selesaikan Misi 1 dan Misi 2 pada tab Game Misi Sains sebelum melanjutkan ke slide berikutnya.',
                  style: AppTextStyles.bodySmall.copyWith(height: 1.35),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _tabController.animateTo(1),
                  icon: const Icon(Icons.sports_esports_rounded, size: 17),
                  label: const Text('Buka Game Misi Sains'),
                  style: TextButton.styleFrom(
                      foregroundColor: AppColors.terracottaDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatorTab(
    GlucoseExperimentPoint simulation,
    List<Map<String, dynamic>> trendData,
    bool missionGameCompleted,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!missionGameCompleted) ...[
            _buildMissionReminder(),
            const SizedBox(height: 14),
          ],

          // Banner Intro
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.science_rounded,
                    color: AppColors.goldenYellow, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Laboratorium Bioteknologi Virtual',
                          style: AppTextStyles.h3
                              .copyWith(color: Colors.white, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(
                        'Uji pengaruh konsentrasi ragi dan lama fermentasi terhadap kadar glukosa tape singkong secara empiris.',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.sageLight),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: Icon(
              _showProcedureGuide
                  ? Icons.expand_less
                  : Icons.assignment_outlined,
              color: AppColors.primaryGreen,
              size: 18,
            ),
            label: Text(
              _showProcedureGuide
                  ? 'Sembunyikan Prosedur Praktikum'
                  : 'Lihat Prosedur Praktikum Lengkap',
              style:
                  AppTextStyles.tagText.copyWith(color: AppColors.primaryGreen),
            ),
          ),

          if (_showProcedureGuide) ...[
            const SizedBox(height: 12),
            const ProcedureGuideCard(),
          ],

          const SizedBox(height: 18),

          // Section 1: Digital Glucometer Display
          DigitalGlucometerDisplay(
            yeastPercent: _yeastPercent,
            fermentationDays: _fermentationDays,
            simulation: simulation,
            isSavingLab: _isSavingLab,
            onSave: () => _recordLabExperiment(simulation),
          ),

          const SizedBox(height: 20),

          // Section 2: Interactive Controls
          Text('Pengaturan Variabel Eksperimen',
              style: AppTextStyles.h2.copyWith(fontSize: 16)),
          const SizedBox(height: 10),

          LabControlSliders(
            yeastPercent: _yeastPercent,
            fermentationDays: _fermentationDays,
            isBananaLeaf: _isBananaLeaf,
            onYeastChanged: (v) => setState(() => _yeastPercent = v),
            onDaysChanged: (v) => setState(() => _fermentationDays = v),
            onLeafChanged: (v) => setState(() => _isBananaLeaf = v),
          ),

          const SizedBox(height: 20),

          // Section 3: Dynamic Line Chart & Visual Comparison
          DynamicGlucoseLineChart(
            yeastPercent: _yeastPercent,
            fermentationDays: _fermentationDays,
            trendData: trendData,
          ),

          const SizedBox(height: 18),

          // Biochemical Equation Banner
          const ChemicalReactionFormulaBox(),

          const SizedBox(height: 24),

          CustomButton(
            text: 'Lanjut ke Tantangan Proyek Etnosains',
            icon: Icons.arrow_forward_rounded,
            isFullWidth: true,
            backgroundColor: AppColors.primaryGreen,
            onPressed: () => navigateToNextSlide(
              context,
              ref,
              currentSlide: 10,
              route: '/challenge-proyek',
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
