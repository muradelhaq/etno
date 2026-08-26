import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/supabase_service.dart';
import '../models/user_progress_model.dart';

class LocalStorageService {
  static const String _userProgressKey = 'user_progress_data_v1';
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  UserProgressModel loadUserProgress() {
    final rawJson = _prefs.getString(_userProgressKey);
    if (rawJson != null && rawJson.isNotEmpty) {
      try {
        return UserProgressModel.fromJson(rawJson);
      } catch (_) {
        return UserProgressModel();
      }
    }
    return UserProgressModel();
  }

  Future<void> saveUserProgress(UserProgressModel progress) async {
    await _prefs.setString(_userProgressKey, progress.toJson());
  }

  Future<void> resetProgress() async {
    await _prefs.remove(_userProgressKey);
  }
}

// StateNotifier for global user progress
class UserProgressNotifier extends StateNotifier<UserProgressModel> {
  final LocalStorageService _storageService;

  UserProgressNotifier(this._storageService)
      : super(_storageService.loadUserProgress());

  Future<void> _persistAndSync() async {
    await _storageService.saveUserProgress(state);
    if (SupabaseService.isInitialized &&
        state.studentId.isNotEmpty &&
        !state.studentId.startsWith('local-')) {
      await SupabaseService.updateStudentProgress(
        userId: state.studentId,
        currentSlide: state.readSlides.isEmpty
            ? 1
            : state.readSlides.reduce((a, b) => a > b ? a : b),
        totalXp: state.earnedXP,
        isCompleted: state.completedModules.contains('pisa_quiz'),
      );
    }
  }

  Future<void> updateStudentProfile({
    required String id,
    required String name,
    required String className,
    required String school,
    String role = 'siswa',
  }) async {
    state = state.copyWith(
      studentId: id,
      studentName: name,
      studentClass: className,
      studentSchool: school,
      role: role,
    );
    await _persistAndSync();
  }

  Future<void> updateStudentName(String name) async {
    state = state.copyWith(studentName: name);
    await _persistAndSync();
  }

  Future<void> addXP(int xp) async {
    final newXP = state.earnedXP + xp;
    state = state.copyWith(earnedXP: newXP);
    await _persistAndSync();
  }

  Future<void> markModuleCompleted(String moduleId,
      {int xpBonus = 50, int? slideNumber}) async {
    final updated = Set<String>.from(state.completedModules)..add(moduleId);
    final xp = state.completedModules.contains(moduleId)
        ? state.earnedXP
        : state.earnedXP + xpBonus;
    state = state.copyWith(completedModules: updated, earnedXP: xp);
    await _persistAndSync();
  }

  Future<void> markSlideRead(int slideNumber) async {
    if (state.readSlides.contains(slideNumber)) return;
    state = state.copyWith(
      readSlides: Set<int>.from(state.readSlides)..add(slideNumber),
    );
    await _persistAndSync();
  }

  Future<void> saveApersepsiReflection(String text) async {
    state = state.copyWith(apersepsiReflection: text);
    await _persistAndSync();
  }

  Future<void> saveQuizAnswer(
      int questionId, int optionIndex, bool isCorrect) async {
    final answers = Map<int, int>.from(state.quizSelectedAnswers);
    answers[questionId] = optionIndex;

    state = state.copyWith(
      quizSelectedAnswers: answers,
      totalQuizAnswered: answers.length,
    );
    await _persistAndSync();
  }

  Future<void> completeQuiz(int finalScore) async {
    final updated = Set<String>.from(state.completedModules)..add('pisa_quiz');
    int addedXP = (finalScore >= 80) ? 250 : 150;
    state = state.copyWith(
      quizScore: finalScore,
      completedModules: updated,
      earnedXP: state.completedModules.contains('pisa_quiz')
          ? state.earnedXP
          : state.earnedXP + addedXP,
    );
    await _persistAndSync();
  }

  /// Clears the current answer set so a student can retake the final
  /// evaluation from question one. The completion flag and latest score are
  /// kept until the new attempt is submitted.
  Future<void> resetQuizForRetry() async {
    state = state.copyWith(
      quizSelectedAnswers: <int, int>{},
      totalQuizAnswered: 0,
    );
    await _persistAndSync();
  }

  Future<void> saveLikertAnswers(
      Map<int, int> answers, double scoreIndex) async {
    final updated = Set<String>.from(state.completedModules)
      ..add('cultural_assessment');
    final alreadyCompleted =
        state.completedModules.contains('cultural_assessment');
    state = state.copyWith(
      likertAnswers: answers,
      culturalAwarenessScore: scoreIndex,
      completedModules: updated,
      earnedXP: alreadyCompleted ? state.earnedXP : state.earnedXP + 100,
    );
    await _persistAndSync();
  }

  Future<void> addInnovationIdea(InnovationIdea idea) async {
    final updatedList = List<InnovationIdea>.from(state.innovationIdeas)
      ..add(idea);
    final updatedModules = Set<String>.from(state.completedModules)
      ..add('inovasi_pangan');
    state = state.copyWith(
      innovationIdeas: updatedList,
      completedModules: updatedModules,
      earnedXP: state.earnedXP + 75,
    );
    await _storageService.saveUserProgress(state);
  }

  Future<void> saveCaseStudyAnswer(String foodId, String answer) async {
    final map = Map<String, String>.from(state.caseStudyAnswers);
    map[foodId] = answer;
    state = state.copyWith(caseStudyAnswers: map);
    await _persistAndSync();
  }

  Future<void> saveProjectSubmission({
    required String title,
    required String members,
    required String link,
    required String notes,
  }) async {
    state = state.copyWith(
      projectTitle: title.trim(),
      projectMembers: members.trim(),
      projectLink: link.trim(),
      projectNotes: notes.trim(),
      projectSubmitted: true,
    );
    await _persistAndSync();
  }

  Future<void> resetAll() async {
    await _storageService.resetProgress();
    state = UserProgressModel();
  }
}

// Providers
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize in main with override');
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
});

final userProgressProvider =
    StateNotifierProvider<UserProgressNotifier, UserProgressModel>((ref) {
  final service = ref.watch(localStorageServiceProvider);
  return UserProgressNotifier(service);
});
