import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/services/supabase_service.dart';
import '../../../../../shared/services/local_storage_service.dart';
import '../../../domain/entities/fermented_food_entity.dart';

class FoodCaseStudyAccordion extends ConsumerStatefulWidget {
  final FermentedFoodEntity food;

  const FoodCaseStudyAccordion({super.key, required this.food});

  @override
  ConsumerState<FoodCaseStudyAccordion> createState() =>
      _FoodCaseStudyAccordionState();
}

class _FoodCaseStudyAccordionState
    extends ConsumerState<FoodCaseStudyAccordion> {
  late TextEditingController _caseStudyController;
  bool _showHypothesisGuide = false;
  bool _isCaseStudyExpanded = false;

  @override
  void initState() {
    super.initState();
    final savedAns =
        ref.read(userProgressProvider).caseStudyAnswers[widget.food.id] ?? '';
    _caseStudyController = TextEditingController(text: savedAns);
  }

  @override
  void didUpdateWidget(covariant FoodCaseStudyAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.food.id != widget.food.id) {
      final savedAns =
          ref.read(userProgressProvider).caseStudyAnswers[widget.food.id] ?? '';
      _caseStudyController.text = savedAns;
      _showHypothesisGuide = false;
      _isCaseStudyExpanded = false;
    }
  }

  @override
  void dispose() {
    _caseStudyController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final text = _caseStudyController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Silakan tulis analisis atau hipotesismu terlebih dahulu.'),
          backgroundColor: AppColors.warmTerracotta,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final user = ref.read(userProgressProvider);
    final caseStudy = widget.food.caseStudy;

    // Save locally
    await ref
        .read(userProgressProvider.notifier)
        .saveCaseStudyAnswer(widget.food.id, text);
    await ref.read(userProgressProvider.notifier).addXP(25);

    // Submit to Supabase
    final synced = await SupabaseService.submitCaseStudyOpinion(
      userId: user.studentId,
      studentName: user.studentName,
      studentClass: user.studentClass,
      studentSchool: user.studentSchool,
      moduleId: widget.food.id,
      caseTitle: caseStudy.title,
      researchQuestion: caseStudy.researchQuestion,
      studentOpinion: text,
      studentVariables:
          'Bebas: ${caseStudy.manipulatedVariable}, Terikat: ${caseStudy.respondingVariable}',
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              synced ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                synced
                    ? 'Jawaban tersimpan ke Database! (+25 XP)'
                    : 'Jawaban tersimpan offline dan akan disinkronkan otomatis. (+25 XP)',
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final caseStudy = widget.food.caseStudy;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
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
                          .saveCaseStudyAnswer(widget.food.id, val);
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
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.send_rounded,
                                size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text('Kirim'),
                          ],
                        ),
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
                          Text(
                              '• Variabel Bebas: ${caseStudy.manipulatedVariable}',
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
}
