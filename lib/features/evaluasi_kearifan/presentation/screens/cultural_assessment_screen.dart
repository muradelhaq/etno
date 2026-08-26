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
import '../../data/models/likert_question_model.dart';

class CulturalAssessmentScreen extends ConsumerStatefulWidget {
  const CulturalAssessmentScreen({super.key});

  @override
  ConsumerState<CulturalAssessmentScreen> createState() =>
      _CulturalAssessmentScreenState();
}

class _CulturalAssessmentScreenState
    extends ConsumerState<CulturalAssessmentScreen> {
  final Map<int, int> _answers = {};
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    final saved = ref.read(userProgressProvider).likertAnswers;
    if (saved.isNotEmpty) {
      _answers.addAll(saved);
      _isSubmitted = true;
    }
  }

  void _calculateAndSubmit() {
    if (_answers.length < CulturalAssessmentData.questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Silakan jawab seluruh ${_answers.length}/${CulturalAssessmentData.questions.length} pernyataan kuesioner.'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    int totalScore = 0;
    _answers.forEach((k, v) => totalScore += v);

    // Max score = 10 * 5 = 50. Index % = (totalScore / 50) * 100
    final double indexScore =
        (totalScore / (CulturalAssessmentData.questions.length * 5)) * 100;

    ref
        .read(userProgressProvider.notifier)
        .saveLikertAnswers(_answers, indexScore);

    setState(() {
      _isSubmitted = true;
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.stars_rounded,
                color: AppColors.goldenYellow, size: 28),
            const SizedBox(width: 8),
            Text('Hasil Asesmen Budaya', style: AppTextStyles.h3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Indeks Kesadaran Kearifan Lokal:',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${indexScore.toStringAsFixed(1)}%',
              style: AppTextStyles.scientificData
                  .copyWith(fontSize: 36, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.sageLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                indexScore >= 80
                    ? 'Kategori: Sangat Tinggi (Bangsawan Budaya)'
                    : 'Kategori: Baik & Peduli Budaya',
                style: AppTextStyles.tagText
                    .copyWith(color: AppColors.primaryDark),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Asesmen ini tersimpan dan akan dicantumkan pada E-Sertifikat kelulusanmu! (+100 XP)',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/literasi-sains-quiz');
            },
            child: const Text('Lanjut ke Evaluasi Akhir (PISA)'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProgress = ref.watch(userProgressProvider);

    return EthnoScaffold(
      title: 'Asesmen Kesadaran Budaya',
      subtitle: 'Slide 12 / 13 • Skala Sikap & Kearifan Etnosains',
      currentSlide: 12,
      totalSlides: 13,
      prevRoute: '/challenge-proyek',
      nextRoute: '/literasi-sains-quiz',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.rate_review_rounded,
                      color: AppColors.goldenYellow, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Angket Sikap & Nilai Kearifan',
                            style: AppTextStyles.h3
                                .copyWith(color: Colors.white, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(
                          'Pilihlah skala 1 (Sangat Tidak Setuju) hingga 5 (Sangat Setuju) yang paling mencerminkan pandangan pribadimu:',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.sageLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            if (_isSubmitted && userProgress.culturalAwarenessScore > 0) ...[
              const SizedBox(height: 16),
              EthnoCard(
                padding: const EdgeInsets.all(14),
                backgroundColor: AppColors.warmCream,
                borderColor: AppColors.goldenYellow,
                child: Row(
                  children: [
                    const Icon(Icons.verified_rounded,
                        color: AppColors.warmTerracotta, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Indeks Kesadaran Budaya Kamu:',
                              style: AppTextStyles.bodyBold
                                  .copyWith(fontSize: 13)),
                          Text(
                            '${userProgress.culturalAwarenessScore.toStringAsFixed(1)}% (Kategori Unggul & Cinta Warisan)',
                            style: AppTextStyles.tagText.copyWith(
                                color: AppColors.primaryGreen, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 18),

            // Questions List
            ...CulturalAssessmentData.questions.map((q) {
              final selectedVal = _answers[q.id];

              return Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: EthnoCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.sageLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text(
                                '${q.id}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.warmCream,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              q.indicator,
                              style: AppTextStyles.tagText.copyWith(
                                  color: AppColors.terracottaDark,
                                  fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        q.statement,
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontSize: 13, height: 1.4),
                      ),
                      const SizedBox(height: 12),

                      // Scale Selector 1-5
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (idx) {
                          final score = idx + 1;
                          final isSelected = selectedVal == score;

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _answers[q.id] = score;
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 54,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryGreen
                                    : AppColors.warmCream
                                        .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryDark
                                      : AppColors.borderSubtle,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '$score',
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.primaryDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    score == 1
                                        ? 'STS'
                                        : (score == 5
                                            ? 'SS'
                                            : (score == 3
                                                ? 'N'
                                                : (score == 2 ? 'TS' : 'S'))),
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white70
                                          : AppColors.textSecondary,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 14),

            CustomButton(
              text: _isSubmitted
                  ? 'Perbarui Asesmen Sikap'
                  : 'Kirim Asesmen Sikap (+100 XP)',
              icon: Icons.check_circle_outline_rounded,
              isFullWidth: true,
              backgroundColor: AppColors.primaryGreen,
              onPressed: _calculateAndSubmit,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
