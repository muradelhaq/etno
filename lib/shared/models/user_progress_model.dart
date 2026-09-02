import 'dart:convert';

class InnovationIdea {
  final String id;
  final String title;
  final String baseProduct;
  final String ingredients;
  final String bioConcept;
  final String description;
  final DateTime createdAt;

  InnovationIdea({
    required this.id,
    required this.title,
    required this.baseProduct,
    required this.ingredients,
    required this.bioConcept,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'baseProduct': baseProduct,
        'ingredients': ingredients,
        'bioConcept': bioConcept,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
      };

  factory InnovationIdea.fromMap(Map<String, dynamic> map) => InnovationIdea(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        baseProduct: map['baseProduct'] ?? '',
        ingredients: map['ingredients'] ?? '',
        bioConcept: map['bioConcept'] ?? '',
        description: map['description'] ?? '',
        createdAt: map['createdAt'] != null
            ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
            : DateTime.now(),
      );
}

class UserProgressModel {
  final String studentId;
  final String studentName;
  final String studentClass;
  final String studentSchool;
  final String role; // 'siswa' or 'admin'
  final int earnedXP;
  final Set<String> completedModules;
  final String apersepsiReflection;
  final int quizScore;
  final int totalQuizAnswered;
  final Map<int, int> quizSelectedAnswers; // questionId -> selectedOptionIndex
  final double culturalAwarenessScore; // percentage or index (0-100)
  final Map<int, int> likertAnswers; // questionId -> score 1-5
  final List<InnovationIdea> innovationIdeas;
  final Map<String, String> caseStudyAnswers; // foodId -> student answer
  final Set<int> readSlides;
  final String projectTitle;
  final String projectMembers;
  final String projectLink;
  final String projectNotes;
  final bool projectSubmitted;

  UserProgressModel({
    this.studentId = '',
    this.studentName = 'Siswa Etnosains',
    this.studentClass = 'Kelas Biologi',
    this.studentSchool = 'Sekolah Menengah Atas',
    this.role = 'siswa',
    this.earnedXP = 0,
    this.completedModules = const {},
    this.apersepsiReflection = '',
    this.quizScore = 0,
    this.totalQuizAnswered = 0,
    this.quizSelectedAnswers = const {},
    this.culturalAwarenessScore = 0.0,
    this.likertAnswers = const {},
    this.innovationIdeas = const [],
    this.caseStudyAnswers = const {},
    this.readSlides = const {},
    this.projectTitle = '',
    this.projectMembers = '',
    this.projectLink = '',
    this.projectNotes = '',
    this.projectSubmitted = false,
  });

  bool canProceedFromSlide(int slide) {
    if (!readSlides.contains(slide)) return false;
    switch (slide) {
      case 2:
        return apersepsiReflection.trim().isNotEmpty;
      case 4:
        return (caseStudyAnswers['tempe'] ?? '').trim().isNotEmpty;
      case 5:
        return (caseStudyAnswers['tape'] ?? '').trim().isNotEmpty;
      case 6:
        return (caseStudyAnswers['tape-ketan'] ?? '').trim().isNotEmpty;
      case 7:
        return (caseStudyAnswers['tauco'] ?? '').trim().isNotEmpty;
      case 9:
        return completedModules.contains('virtual_lab') &&
            completedModules.contains('virtual_lab_game');
      case 11:
        return completedModules.contains('cultural_assessment');
      case 12:
        return completedModules.contains('pisa_quiz');
      default:
        return true;
    }
  }

  String requirementForSlide(int slide) {
    if (!readSlides.contains(slide)) {
      return 'Baca seluruh isi slide sampai bagian paling bawah terlebih dahulu.';
    }
    if (slide == 2) return 'Isi kolom refleksi sebelum melanjutkan.';
    if (slide >= 4 && slide <= 7) {
      return 'Isi dan simpan jawaban studi kasus sebelum melanjutkan.';
    }
    if (slide == 9) {
      return 'Rekam hasil percobaan virtual lab terlebih dahulu.';
    }
    if (slide == 11) return 'Jawab dan kirim seluruh pernyataan asesmen.';
    if (slide == 12) return 'Jawab dan selesaikan seluruh soal evaluasi.';
    return 'Selesaikan aktivitas pada slide ini terlebih dahulu.';
  }

  int get highestUnlockedSlide {
    for (var slide = 1; slide < 12; slide++) {
      if (!canProceedFromSlide(slide)) return slide;
    }
    return 12;
  }

  bool get isRegistered =>
      studentId.isNotEmpty &&
      studentName.trim().isNotEmpty &&
      studentName.trim() != 'Siswa Etnosains';

  bool get isCertificateEligible =>
      isRegistered && completedModules.contains('pisa_quiz');

  UserProgressModel copyWith({
    String? studentId,
    String? studentName,
    String? studentClass,
    String? studentSchool,
    String? role,
    int? earnedXP,
    Set<String>? completedModules,
    String? apersepsiReflection,
    int? quizScore,
    int? totalQuizAnswered,
    Map<int, int>? quizSelectedAnswers,
    double? culturalAwarenessScore,
    Map<int, int>? likertAnswers,
    List<InnovationIdea>? innovationIdeas,
    Map<String, String>? caseStudyAnswers,
    Set<int>? readSlides,
    String? projectTitle,
    String? projectMembers,
    String? projectLink,
    String? projectNotes,
    bool? projectSubmitted,
  }) {
    return UserProgressModel(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentClass: studentClass ?? this.studentClass,
      studentSchool: studentSchool ?? this.studentSchool,
      role: role ?? this.role,
      earnedXP: earnedXP ?? this.earnedXP,
      completedModules: completedModules ?? this.completedModules,
      apersepsiReflection: apersepsiReflection ?? this.apersepsiReflection,
      quizScore: quizScore ?? this.quizScore,
      totalQuizAnswered: totalQuizAnswered ?? this.totalQuizAnswered,
      quizSelectedAnswers: quizSelectedAnswers ?? this.quizSelectedAnswers,
      culturalAwarenessScore:
          culturalAwarenessScore ?? this.culturalAwarenessScore,
      likertAnswers: likertAnswers ?? this.likertAnswers,
      innovationIdeas: innovationIdeas ?? this.innovationIdeas,
      caseStudyAnswers: caseStudyAnswers ?? this.caseStudyAnswers,
      readSlides: readSlides ?? this.readSlides,
      projectTitle: projectTitle ?? this.projectTitle,
      projectMembers: projectMembers ?? this.projectMembers,
      projectLink: projectLink ?? this.projectLink,
      projectNotes: projectNotes ?? this.projectNotes,
      projectSubmitted: projectSubmitted ?? this.projectSubmitted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'studentClass': studentClass,
      'studentSchool': studentSchool,
      'role': role,
      'earnedXP': earnedXP,
      'completedModules': completedModules.toList(),
      'apersepsiReflection': apersepsiReflection,
      'quizScore': quizScore,
      'totalQuizAnswered': totalQuizAnswered,
      'quizSelectedAnswers':
          quizSelectedAnswers.map((k, v) => MapEntry(k.toString(), v)),
      'culturalAwarenessScore': culturalAwarenessScore,
      'likertAnswers': likertAnswers.map((k, v) => MapEntry(k.toString(), v)),
      'innovationIdeas': innovationIdeas.map((e) => e.toMap()).toList(),
      'caseStudyAnswers': caseStudyAnswers,
      'readSlides': readSlides.toList(),
      'projectTitle': projectTitle,
      'projectMembers': projectMembers,
      'projectLink': projectLink,
      'projectNotes': projectNotes,
      'projectSubmitted': projectSubmitted,
    };
  }

  factory UserProgressModel.fromMap(Map<String, dynamic> map) {
    return UserProgressModel(
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? 'Siswa Etnosains',
      studentClass: map['studentClass'] ?? 'Kelas Biologi',
      studentSchool: map['studentSchool'] ?? 'Sekolah Menengah Atas',
      role: map['role'] ?? 'siswa',
      earnedXP: map['earnedXP'] ?? 0,
      completedModules: (map['completedModules'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toSet() ??
          {},
      apersepsiReflection: map['apersepsiReflection'] ?? '',
      quizScore: map['quizScore'] ?? 0,
      totalQuizAnswered: map['totalQuizAnswered'] ?? 0,
      quizSelectedAnswers: (map['quizSelectedAnswers'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(int.tryParse(k) ?? 0, v as int)) ??
          {},
      culturalAwarenessScore:
          (map['culturalAwarenessScore'] as num?)?.toDouble() ?? 0.0,
      likertAnswers: (map['likertAnswers'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(int.tryParse(k) ?? 0, v as int)) ??
          {},
      innovationIdeas: (map['innovationIdeas'] as List<dynamic>?)
              ?.map((e) => InnovationIdea.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      caseStudyAnswers: (map['caseStudyAnswers'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v.toString())) ??
          {},
      readSlides: (map['readSlides'] as List<dynamic>?)
              ?.map((value) => (value as num).toInt())
              .toSet() ??
          {},
      projectTitle: map['projectTitle']?.toString() ?? '',
      projectMembers: map['projectMembers']?.toString() ?? '',
      projectLink: map['projectLink']?.toString() ?? '',
      projectNotes: map['projectNotes']?.toString() ?? '',
      projectSubmitted: map['projectSubmitted'] == true,
    );
  }

  String toJson() => jsonEncode(toMap());
  factory UserProgressModel.fromJson(String source) =>
      UserProgressModel.fromMap(jsonDecode(source));
}
