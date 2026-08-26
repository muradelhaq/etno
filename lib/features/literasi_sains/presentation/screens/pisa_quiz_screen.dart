import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/services/supabase_service.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/custom_button.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_scaffold.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';
import 'package:e_modul_etnosains/features/literasi_sains/data/models/pisa_questions_data.dart';
import 'package:e_modul_etnosains/features/literasi_sains/data/models/pisa_question_model.dart';
import '../widgets/cards/pisa_option_item_card.dart';
import '../widgets/cards/pisa_scenario_context_card.dart';
import '../widgets/dialogs/pisa_result_dialog.dart';
import '../widgets/sections/pisa_explanation_hint_box.dart';
import '../widgets/sections/pisa_navigation_bar.dart';
import '../widgets/sections/pisa_quiz_header.dart';

class PisaQuizScreen extends ConsumerStatefulWidget {
  const PisaQuizScreen({super.key});

  @override
  ConsumerState<PisaQuizScreen> createState() => _PisaQuizScreenState();
}

class _PisaQuizScreenState extends ConsumerState<PisaQuizScreen> {
  int _currentIndex = 0;
  late final List<PisaQuestionModel> _questions;
  final Map<int, int> _userSelectedAnswers = {};
  final Set<int> _revealedHints = {};
  bool _quizFinished = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProgressProvider);
    final identity = user.studentId.isNotEmpty
        ? user.studentId
        : '${user.studentName}|${user.studentSchool}|${user.studentClass}';
    _questions = _buildPersonalizedQuestions(identity);
    final saved = user.quizSelectedAnswers;
    if (saved.isNotEmpty) {
      _userSelectedAnswers.addAll(saved);
      if (_userSelectedAnswers.length == PisaQuestionsData.questions.length) {
        _quizFinished = true;
      }
    }
  }

  int _stableSeed(String value) {
    var seed = 0x45d9f3b;
    for (final codeUnit in value.codeUnits) {
      seed = ((seed * 31) + codeUnit) & 0x7fffffff;
    }
    return seed == 0 ? 1 : seed;
  }

  List<T> _shuffleForSeed<T>(List<T> source, int seed) {
    final result = List<T>.from(source);
    var state = seed;
    for (var i = result.length - 1; i > 0; i--) {
      state = (state * 1664525 + 1013904223) & 0x7fffffff;
      final j = state % (i + 1);
      final temp = result[i];
      result[i] = result[j];
      result[j] = temp;
    }
    return result;
  }

  List<PisaQuestionModel> _buildPersonalizedQuestions(String identity) {
    final seed = _stableSeed(identity);
    final questions = _shuffleForSeed(
      List<PisaQuestionModel>.from(PisaQuestionsData.questions),
      seed,
    );
    return questions.map((question) {
      final options = _shuffleForSeed(
        List<PisaQuestionOption>.from(question.options),
        seed ^ (question.id * 7919),
      );
      return PisaQuestionModel(
        id: question.id,
        title: question.title,
        competency: question.competency,
        competencyLabel: question.competencyLabel,
        scenarioContext: question.scenarioContext,
        questionText: question.questionText,
        tableDataSummary: question.tableDataSummary,
        imageAsset: question.imageAsset,
        options: options,
        correctOptionIndex: options.indexWhere((option) => option.isCorrect),
        scientificExplanation: question.scientificExplanation,
        hint: question.hint,
      );
    }).toList();
  }

  void _handleOptionSelect(int questionId, int optionIndex) {
    if (_userSelectedAnswers.containsKey(questionId)) return;

    setState(() {
      _userSelectedAnswers[questionId] = optionIndex;
    });

    final q = _questions.firstWhere((item) => item.id == questionId);
    final isCorrect = optionIndex == q.correctOptionIndex;

    ref
        .read(userProgressProvider.notifier)
        .saveQuizAnswer(questionId, optionIndex, isCorrect);
  }

  Future<void> _finishQuiz() async {
    int totalCorrect = 0;
    for (var q in _questions) {
      if (_userSelectedAnswers[q.id] == q.correctOptionIndex) {
        totalCorrect++;
      }
    }

    final finalScore = (totalCorrect * 10).clamp(0, 100);
    await ref.read(userProgressProvider.notifier).completeQuiz(finalScore);

    final user = ref.read(userProgressProvider);
    await Future.wait([
      SupabaseService.saveQuizResult(
        userId: user.studentId,
        studentName: user.studentName,
        studentClass: user.studentClass,
        studentSchool: user.studentSchool,
        quizType: 'Post-test Evaluasi PISA',
        score: finalScore.toDouble(),
        correctCount: totalCorrect,
        totalQuestions: _questions.length,
        answersDetail:
            _userSelectedAnswers.map((k, v) => MapEntry(k.toString(), v)),
      ),
      SupabaseService.updateStudentProgress(
        userId: user.studentId,
        currentSlide: 13,
        totalXp: user.earnedXP,
        isCompleted: true,
      ),
    ]);

    if (!mounted) return;

    setState(() {
      _quizFinished = true;
    });

    PisaResultDialog.show(context: context, finalScore: finalScore);
  }

  Future<void> _restartQuiz() async {
    await ref.read(userProgressProvider.notifier).resetQuizForRetry();
    if (!mounted) return;
    setState(() {
      _currentIndex = 0;
      _userSelectedAnswers.clear();
      _revealedHints.clear();
      _quizFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = _questions;
    final currentQ = questions[_currentIndex];
    final selectedOption = _userSelectedAnswers[currentQ.id];
    final isAnswered = selectedOption != null;

    return EthnoScaffold(
      title: 'Evaluasi Literasi Sains (PISA)',
      subtitle: 'Slide 13 / 13 • 10 Soal HOTS Berbasis Data',
      currentSlide: 13,
      totalSlides: 13,
      prevRoute: '/evaluasi-kearifan',
      nextRoute: '/sertifikat',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar & Competency Header
            PisaQuizHeader(
              currentIndex: _currentIndex,
              totalQuestions: questions.length,
              answeredCount: _userSelectedAnswers.length,
              competencyLabel: currentQ.competencyLabel,
            ),

            const SizedBox(height: 12),

            // Scenario Context Box
            PisaScenarioContextCard(
              scenarioContext: currentQ.scenarioContext,
              tableDataSummary: currentQ.tableDataSummary,
            ),

            const SizedBox(height: 14),

            // Question Prompt
            Text(
              currentQ.questionText,
              style: AppTextStyles.h3.copyWith(
                fontSize: 14.5,
                height: 1.4,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 14),

            // Options List
            ...List.generate(currentQ.options.length, (idx) {
              final option = currentQ.options[idx];
              return PisaOptionItemCard(
                option: option,
                optionIndex: idx,
                isAnswered: isAnswered,
                isChosen: selectedOption == idx,
                isCorrectAnswer: idx == currentQ.correctOptionIndex,
                onTap: () => _handleOptionSelect(currentQ.id, idx),
              );
            }),

            const SizedBox(height: 8),

            // Hint & Explanation Toggle
            PisaExplanationHintBox(
              isAnswered: isAnswered,
              explanation: currentQ.scientificExplanation,
              hint: currentQ.hint,
              isHintRevealed: _revealedHints.contains(currentQ.id),
              onRevealHint: () {
                setState(() {
                  _revealedHints.add(currentQ.id);
                });
              },
            ),

            const SizedBox(height: 16),

            // Navigation Buttons (Prev / Next / Finish)
            PisaNavigationBar(
              currentIndex: _currentIndex,
              totalQuestions: questions.length,
              canFinish: _userSelectedAnswers.length == questions.length,
              onPrevious: () => setState(() => _currentIndex--),
              onNext: () => setState(() => _currentIndex++),
              onFinish: _finishQuiz,
            ),

            if (_quizFinished) ...[
              const SizedBox(height: 18),
              CustomButton(
                text: 'Ulangi Evaluasi dari Awal',
                icon: Icons.restart_alt_rounded,
                isFullWidth: true,
                backgroundColor: AppColors.primaryGreen,
                onPressed: _restartQuiz,
              ),
              const SizedBox(height: 10),
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
