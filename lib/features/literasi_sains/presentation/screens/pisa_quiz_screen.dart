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
import '../../data/models/pisa_questions_data.dart';

class PisaQuizScreen extends ConsumerStatefulWidget {
  const PisaQuizScreen({super.key});

  @override
  ConsumerState<PisaQuizScreen> createState() => _PisaQuizScreenState();
}

class _PisaQuizScreenState extends ConsumerState<PisaQuizScreen> {
  int _currentIndex = 0;
  final Map<int, int> _userSelectedAnswers = {};
  final Set<int> _revealedHints = {};
  bool _quizFinished = false;

  @override
  void initState() {
    super.initState();
    final saved = ref.read(userProgressProvider).quizSelectedAnswers;
    if (saved.isNotEmpty) {
      _userSelectedAnswers.addAll(saved);
      if (_userSelectedAnswers.length == PisaQuestionsData.questions.length) {
        _quizFinished = true;
      }
    }
  }

  void _handleOptionSelect(int questionId, int optionIndex) {
    if (_userSelectedAnswers.containsKey(questionId)) return; // Lock answer once picked

    setState(() {
      _userSelectedAnswers[questionId] = optionIndex;
    });

    final q = PisaQuestionsData.questions.firstWhere((item) => item.id == questionId);
    final isCorrect = optionIndex == q.correctOptionIndex;

    ref.read(userProgressProvider.notifier).saveQuizAnswer(questionId, optionIndex, isCorrect);
  }

  void _finishQuiz() {
    int totalCorrect = 0;
    for (var q in PisaQuestionsData.questions) {
      if (_userSelectedAnswers[q.id] == q.correctOptionIndex) {
        totalCorrect++;
      }
    }

    final finalScore = (totalCorrect * 10).clamp(0, 100);

    ref.read(userProgressProvider.notifier).completeQuiz(finalScore);

    setState(() {
      _quizFinished = true;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              finalScore >= 80 ? Icons.military_tech_rounded : Icons.emoji_events_rounded,
              color: AppColors.goldenYellow,
              size: 32,
            ),
            const SizedBox(width: 8),
            Text('Hasil Uji Literasi Sains', style: AppTextStyles.h3),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Skor Akhir Kamu:',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              '$finalScore / 100',
              style: AppTextStyles.scientificData.copyWith(
                fontSize: 44,
                color: finalScore >= 80 ? AppColors.primaryGreen : AppColors.warmTerracotta,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              finalScore >= 80
                  ? 'Predikat: Master Bioteknologi Tradisional (Sangat Unggul)'
                  : 'Predikat: Terampil & Terus Belajar Etnosains',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyBold.copyWith(
                color: finalScore >= 80 ? AppColors.primaryDark : AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Kamu telah menyelesaikan seluruh 12 slide modul pembelajaran. E-Sertifikat Digital kelulusanmu telah siap diterbitkan!',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Review Jawaban'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.workspace_premium_rounded, size: 18),
            label: const Text('Buka E-Sertifikat'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/sertifikat');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const questions = PisaQuestionsData.questions;
    final currentQ = questions[_currentIndex];
    final selectedOption = _userSelectedAnswers[currentQ.id];
    final isAnswered = selectedOption != null;

    return EthnoScaffold(
      title: 'Evaluasi Literasi Sains (PISA)',
      subtitle: 'Slide 12 / 12 • 10 Soal HOTS Berbasis Data',
      currentSlide: 12,
      totalSlides: 12,
      prevRoute: '/evaluasi-kearifan',
      nextRoute: '/sertifikat',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Progress Bar & Stepper Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nomor ${_currentIndex + 1} dari ${questions.length}',
                  style: AppTextStyles.bodyBold.copyWith(color: AppColors.primaryDark),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.sageLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_userSelectedAnswers.length}/${questions.length} Terjawab',
                    style: AppTextStyles.tagText.copyWith(color: AppColors.primaryDark, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: (_currentIndex + 1) / questions.length,
              backgroundColor: AppColors.borderSubtle,
              color: AppColors.primaryGreen,
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),

            const SizedBox(height: 16),

            // Competency Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warmCream,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.goldenYellow),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.psychology_alt_rounded, size: 14, color: AppColors.warmTerracotta),
                  const SizedBox(width: 6),
                  Text(
                    'Kompetensi: ${currentQ.competencyLabel}',
                    style: AppTextStyles.tagText.copyWith(color: AppColors.terracottaDark, fontSize: 10.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Scenario Context Box
            EthnoCard(
              padding: const EdgeInsets.all(14),
              backgroundColor: AppColors.sageLight.withValues(alpha: 0.4),
              borderColor: AppColors.primaryLight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primaryGreen),
                      const SizedBox(width: 6),
                      Text('Konteks Stimulus Soal:', style: AppTextStyles.tagText.copyWith(color: AppColors.primaryDark)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currentQ.scenarioContext,
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 13, height: 1.45),
                  ),
                  if (currentQ.tableDataSummary != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Text(
                        '📊 Data Rujukan: ${currentQ.tableDataSummary}',
                        style: AppTextStyles.scientificFormula.copyWith(fontSize: 11),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Question Prompt
            Text(
              currentQ.questionText,
              style: AppTextStyles.h3.copyWith(fontSize: 14.5, height: 1.4, color: AppColors.textPrimary),
            ),

            const SizedBox(height: 14),

            // Options List
            ...List.generate(currentQ.options.length, (idx) {
              final option = currentQ.options[idx];
              final isChosen = selectedOption == idx;
              final isTheCorrectAnswer = idx == currentQ.correctOptionIndex;

              Color bgColor = Colors.white;
              Color borderColor = AppColors.borderSubtle;
              Color textColor = AppColors.textPrimary;
              IconData icon = Icons.circle_outlined;
              Color iconColor = AppColors.textSecondary;

              if (isAnswered) {
                if (isTheCorrectAnswer) {
                  bgColor = AppColors.successLight;
                  borderColor = AppColors.successGreen;
                  icon = Icons.check_circle_rounded;
                  iconColor = AppColors.successGreen;
                } else if (isChosen) {
                  bgColor = AppColors.errorLight;
                  borderColor = AppColors.errorRed;
                  icon = Icons.cancel_rounded;
                  iconColor = AppColors.errorRed;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: EthnoCard(
                  padding: const EdgeInsets.all(12),
                  backgroundColor: bgColor,
                  borderColor: borderColor,
                  onTap: isAnswered ? null : () => _handleOptionSelect(currentQ.id, idx),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(icon, color: iconColor, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              option.text,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 13,
                                color: textColor,
                                fontWeight: isChosen ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isAnswered && (isChosen || isTheCorrectAnswer)) ...[
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Text(
                            option.justification,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 11,
                              color: isTheCorrectAnswer ? AppColors.primaryDark : AppColors.errorRed,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 8),

            // Hint & Explanation Toggle
            if (isAnswered) ...[
              EthnoCard(
                padding: const EdgeInsets.all(14),
                backgroundColor: AppColors.warmCream,
                borderColor: AppColors.goldenYellow,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.school_rounded, color: AppColors.terracottaDark, size: 20),
                        const SizedBox(width: 8),
                        Text('Pembahasan Ilmiah Resmi:', style: AppTextStyles.bodyBold.copyWith(color: AppColors.terracottaDark)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      currentQ.scientificExplanation,
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 12.5, height: 1.5),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
            ] else ...[
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  icon: const Icon(Icons.lightbulb_outline, size: 16, color: AppColors.warmTerracotta),
                  label: Text(
                    _revealedHints.contains(currentQ.id) ? currentQ.hint : 'Butuh Petunjuk / Hint?',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.warmTerracotta,
                      fontStyle: _revealedHints.contains(currentQ.id) ? FontStyle.italic : FontStyle.normal,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _revealedHints.add(currentQ.id);
                    });
                  },
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Stepper Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: _currentIndex > 0
                      ? () {
                          setState(() {
                            _currentIndex--;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.arrow_back_rounded, size: 16),
                  label: const Text('Sebelumnya'),
                ),
                if (_currentIndex < questions.length - 1) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentIndex++;
                      });
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: const Text('Selanjutnya'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    onPressed: _userSelectedAnswers.length == questions.length ? _finishQuiz : null,
                    icon: const Icon(Icons.check_circle_rounded, size: 16),
                    label: const Text('Selesaikan Kuis'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                  ),
                ],
              ],
            ),

            if (_quizFinished) ...[
              const SizedBox(height: 18),
              CustomButton(
                text: 'Buka E-Sertifikat Kelulusan Digital',
                icon: Icons.workspace_premium_rounded,
                isFullWidth: true,
                backgroundColor: AppColors.warmTerracotta,
                onPressed: () => context.go('/sertifikat'),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
