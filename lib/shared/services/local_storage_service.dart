import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    await _storageService.saveUserProgress(state);
  }

  Future<void> updateStudentName(String name) async {
    state = state.copyWith(studentName: name);
    await _storageService.saveUserProgress(state);
  }

  Future<void> addXP(int xp) async {
    final newXP = state.earnedXP + xp;
    state = state.copyWith(earnedXP: newXP);
    await _storageService.saveUserProgress(state);
  }

  Future<void> markModuleCompleted(String moduleId,
      {int xpBonus = 50, int? slideNumber}) async {
    final updated = Set<String>.from(state.completedModules)..add(moduleId);
    final xp = state.completedModules.contains(moduleId)
        ? state.earnedXP
        : state.earnedXP + xpBonus;
    state = state.copyWith(completedModules: updated, earnedXP: xp);
    await _storageService.saveUserProgress(state);
  }

  Future<void> markSlideRead(int slideNumber) async {
    if (state.readSlides.contains(slideNumber)) return;
    state = state.copyWith(
      readSlides: Set<int>.from(state.readSlides)..add(slideNumber),
    );
    await _storageService.saveUserProgress(state);
  }

  Future<void> saveApersepsiReflection(String text) async {
    state = state.copyWith(apersepsiReflection: text);
    await _storageService.saveUserProgress(state);
  }

  Future<void> saveQuizAnswer(
      int questionId, int optionIndex, bool isCorrect) async {
    final answers = Map<int, int>.from(state.quizSelectedAnswers);
    answers[questionId] = optionIndex;

    state = state.copyWith(
      quizSelectedAnswers: answers,
      totalQuizAnswered: answers.length,
    );
    await _storageService.saveUserProgress(state);
  }

  Future<void> completeQuiz(int finalScore) async {
    final updated = Set<String>.from(state.completedModules)..add('pisa_quiz');
    int addedXP = (finalScore >= 80) ? 250 : 150;
    state = state.copyWith(
      quizScore: finalScore,
      completedModules: updated,
      earnedXP: state.earnedXP + addedXP,
    );
    await _storageService.saveUserProgress(state);
  }

  Future<void> saveLikertAnswers(
      Map<int, int> answers, double scoreIndex) async {
    final updated = Set<String>.from(state.completedModules)
      ..add('cultural_assessment');
    state = state.copyWith(
      likertAnswers: answers,
      culturalAwarenessScore: scoreIndex,
      completedModules: updated,
      earnedXP: state.earnedXP + 100,
    );
    await _storageService.saveUserProgress(state);
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
    await _storageService.saveUserProgress(state);
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
