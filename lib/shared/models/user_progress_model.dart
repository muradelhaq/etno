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
  });

  bool get isRegistered =>
      studentId.isNotEmpty &&
      studentName.trim().isNotEmpty &&
      studentName.trim() != 'Siswa Etnosains';

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
      'likertAnswers':
          likertAnswers.map((k, v) => MapEntry(k.toString(), v)),
      'innovationIdeas': innovationIdeas.map((e) => e.toMap()).toList(),
      'caseStudyAnswers': caseStudyAnswers,
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
      culturalAwarenessScore: (map['culturalAwarenessScore'] as num?)?.toDouble() ?? 0.0,
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
    );
  }

  String toJson() => jsonEncode(toMap());
  factory UserProgressModel.fromJson(String source) =>
      UserProgressModel.fromMap(jsonDecode(source));
}
