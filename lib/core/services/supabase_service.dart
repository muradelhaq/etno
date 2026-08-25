import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://lumhlhxbmdtlqmlbcumc.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx1bWhsaHhibWR0bHFtbGJjdW1jIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODczMDA0NTMsImV4cCI6MjEwMjg3NjQ1M30.aZQKELiqElVDuRo40HNPLqvUP6Cg8PeDGQuTL9eIhiE';

  static bool _isInitialized = false;

  static SupabaseClient get client => Supabase.instance.client;

  /// Initialize Supabase client
  static Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        // ignore: deprecated_member_use
        anonKey: supabaseAnonKey,
      );
      _isInitialized = true;
      debugPrint('✅ Supabase initialized successfully!');
    } catch (e) {
      debugPrint('⚠️ Supabase init error: $e');
    }
  }

  // ===========================================================================
  // 1. USER & STUDENT REGISTRATION / PROFILE
  // ===========================================================================

  /// Register or Login Student
  static Future<Map<String, dynamic>?> registerOrLoginStudent({
    required String name,
    required String className,
    required String school,
  }) async {
    try {
      final trimmedName = name.trim();
      final trimmedClass = className.trim();
      final trimmedSchool = school.trim();

      // Check if matching student exists
      final existing = await client
          .from('users')
          .select()
          .ilike('name', trimmedName)
          .ilike('class_name', trimmedClass)
          .ilike('school', trimmedSchool)
          .maybeSingle();

      if (existing != null) {
        // Update last active
        await client.from('users').update({
          'last_active': DateTime.now().toIso8601String(),
        }).eq('id', existing['id']);
        return existing;
      }

      // Create new student
      final inserted = await client
          .from('users')
          .insert({
            'name': trimmedName,
            'class_name': trimmedClass,
            'school': trimmedSchool,
            'role': 'siswa',
            'total_xp': 0,
            'current_slide': 1,
            'is_completed': false,
            'last_active': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return inserted;
    } catch (e) {
      debugPrint('Error registerOrLoginStudent: $e');
      return {
        'id': 'local-${DateTime.now().millisecondsSinceEpoch}',
        'name': name,
        'class_name': className,
        'school': school,
        'role': 'siswa',
      };
    }
  }

  /// Update student progress & XP in Supabase
  static Future<void> updateStudentProgress({
    required String userId,
    int? currentSlide,
    int? totalXp,
    bool? isCompleted,
  }) async {
    if (userId.startsWith('local-')) return;
    try {
      final data = <String, dynamic>{
        'last_active': DateTime.now().toIso8601String(),
      };
      if (currentSlide != null) data['current_slide'] = currentSlide;
      if (totalXp != null) data['total_xp'] = totalXp;
      if (isCompleted != null) data['is_completed'] = isCompleted;

      await client.from('users').update(data).eq('id', userId);
    } catch (e) {
      debugPrint('Error updateStudentProgress: $e');
    }
  }

  // ===========================================================================
  // 2. CASE STUDY OPINIONS & REFLECTIONS (PBL)
  // ===========================================================================

  /// Submit student opinion / hypothesis on a case study
  static Future<bool> submitCaseStudyOpinion({
    required String userId,
    required String studentName,
    required String studentClass,
    required String studentSchool,
    required String moduleId,
    required String caseTitle,
    required String researchQuestion,
    required String studentOpinion,
    String? studentVariables,
  }) async {
    try {
      await client.from('case_study_answers').insert({
        if (!userId.startsWith('local-')) 'user_id': userId,
        'student_name': studentName,
        'student_class': studentClass,
        'student_school': studentSchool,
        'module_id': moduleId,
        'case_title': caseTitle,
        'research_question': researchQuestion,
        'student_opinion': studentOpinion,
        'student_variables': studentVariables ?? '',
        'submitted_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('Error submitCaseStudyOpinion: $e');
      return false;
    }
  }

  // ===========================================================================
  // 3. QUIZ & EVALUATION RESULTS
  // ===========================================================================

  /// Record Quiz / Pre-test / Post-test Result
  static Future<bool> saveQuizResult({
    required String userId,
    required String studentName,
    required String studentClass,
    required String studentSchool,
    required String quizType,
    required double score,
    required int correctCount,
    required int totalQuestions,
    Map<String, dynamic>? answersDetail,
  }) async {
    try {
      await client.from('quiz_results').insert({
        if (!userId.startsWith('local-')) 'user_id': userId,
        'student_name': studentName,
        'student_class': studentClass,
        'student_school': studentSchool,
        'quiz_type': quizType,
        'score': score,
        'correct_count': correctCount,
        'total_questions': totalQuestions,
        'answers_detail': answersDetail ?? {},
        'completed_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('Error saveQuizResult: $e');
      return false;
    }
  }

  // ===========================================================================
  // 4. VIRTUAL LAB EXPERIMENT RECORDS
  // ===========================================================================

  /// Save lab experiment record
  static Future<bool> saveLabRecord({
    required String userId,
    required String studentName,
    required String experimentType,
    Map<String, dynamic>? observationData,
    String? conclusion,
  }) async {
    try {
      await client.from('lab_records').insert({
        if (!userId.startsWith('local-')) 'user_id': userId,
        'student_name': studentName,
        'experiment_type': experimentType,
        'observation_data': observationData ?? {},
        'conclusion': conclusion ?? '',
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint('Error saveLabRecord: $e');
      return false;
    }
  }

  // ===========================================================================
  // 5. ADMIN / TEACHER DASHBOARD QUERIES
  // ===========================================================================

  /// Fetch all registered students
  static Future<List<Map<String, dynamic>>> fetchAllStudents() async {
    try {
      final response = await client
          .from('users')
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetchAllStudents: $e');
      return [];
    }
  }

  /// Fetch all quiz results
  static Future<List<Map<String, dynamic>>> fetchAllQuizResults() async {
    try {
      final response = await client
          .from('quiz_results')
          .select()
          .order('completed_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetchAllQuizResults: $e');
      return [];
    }
  }

  /// Fetch all case study answers & reflections with optional filter
  static Future<List<Map<String, dynamic>>> fetchAllCaseStudyAnswers({
    String? moduleId,
    String? className,
  }) async {
    try {
      var query = client.from('case_study_answers').select();

      if (moduleId != null && moduleId != 'all') {
        query = query.eq('module_id', moduleId);
      }
      if (className != null && className != 'all') {
        query = query.eq('student_class', className);
      }

      final response = await query.order('submitted_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetchAllCaseStudyAnswers: $e');
      return [];
    }
  }

  /// Fetch student detailed portfolio (profile + quizzes + opinions + labs)
  static Future<Map<String, dynamic>> fetchStudentDetailedPortfolio(String userId) async {
    try {
      final user = await client.from('users').select().eq('id', userId).maybeSingle();
      final quizzes = await client
          .from('quiz_results')
          .select()
          .eq('user_id', userId)
          .order('completed_at', ascending: false);
      final opinions = await client
          .from('case_study_answers')
          .select()
          .eq('user_id', userId)
          .order('submitted_at', ascending: false);
      final labs = await client
          .from('lab_records')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return {
        'user': user,
        'quizzes': quizzes,
        'opinions': opinions,
        'labs': labs,
      };
    } catch (e) {
      debugPrint('Error fetchStudentDetailedPortfolio: $e');
      return {};
    }
  }

  // ===========================================================================
  // 6. REALTIME SUBSCRIPTIONS
  // ===========================================================================

  /// Berlangganan event real-time perubahan data Supabase (Kuis, Studi Kasus, dan Siswa)
  static RealtimeChannel subscribeToDashboardChanges({
    required void Function(Map<String, dynamic> record) onNewQuiz,
    required void Function(Map<String, dynamic> record) onNewOpinion,
    required void Function(Map<String, dynamic> record) onUserChange,
  }) {
    final channel = client.channel('public:admin_monitoring_${DateTime.now().millisecondsSinceEpoch}');

    channel
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'quiz_results',
        callback: (payload) {
          onNewQuiz(payload.newRecord);
        },
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'case_study_answers',
        callback: (payload) {
          onNewOpinion(payload.newRecord);
        },
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'users',
        callback: (payload) {
          onUserChange(payload.newRecord);
        },
      )
      ..subscribe();

    return channel;
  }

  // ===========================================================================
  // 7. MODULE ASSETS & MEDIA STORAGE (aset-sed)
  // ===========================================================================

  /// Fetch module assets from Supabase database
  static Future<List<Map<String, dynamic>>> fetchModuleAssets({
    String? moduleId,
    String? category,
  }) async {
    try {
      var query = client.from('module_assets').select();
      if (moduleId != null && moduleId != 'all') {
        query = query.eq('module_id', moduleId);
      }
      if (category != null && category != 'all') {
        query = query.eq('category', category);
      }
      final response = await query.order('step_number', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetchModuleAssets: $e');
      return [];
    }
  }

  /// Get public URL for an asset in 'aset-sed' storage bucket
  static String getStorageAssetUrl(String filename) {
    try {
      return client.storage.from('aset-sed').getPublicUrl(filename);
    } catch (e) {
      return '$supabaseUrl/storage/v1/object/public/aset-sed/$filename';
    }
  }
}


