import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../shared/services/offline_sync_queue.dart';
import '../../shared/services/student_session_store.dart';

class SupabaseServiceException implements Exception {
  const SupabaseServiceException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

class SupabaseService {
  static const String supabaseUrl = 'https://lumhlhxbmdtlqmlbcumc.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx1bWhsaHhibWR0bHFtbGJjdW1jIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODczMDA0NTMsImV4cCI6MjEwMjg3NjQ1M30.aZQKELiqElVDuRo40HNPLqvUP6Cg8PeDGQuTL9eIhiE';

  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static SupabaseClient get client => Supabase.instance.client;

  static User? get currentUser =>
      _isInitialized ? client.auth.currentUser : null;

  static bool get isCurrentUserAdmin =>
      currentUser?.appMetadata['role'] == 'admin';

  static String _newUuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex =
        bytes.map((value) => value.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }

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

  /// Authenticate a teacher account and verify its server-controlled role.
  static Future<void> signInAdmin({
    required String email,
    required String password,
  }) async {
    if (!_isInitialized) {
      throw StateError('Layanan autentikasi belum siap. Silakan coba lagi.');
    }

    await flushPendingSync();
    final studentSession =
        currentUser?.isAnonymous == true ? client.auth.currentSession : null;
    final studentRefreshToken = studentSession?.refreshToken;
    if (studentRefreshToken != null) {
      await StudentSessionStore.saveRefreshToken(studentRefreshToken);
    }
    final response = await client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    final role = response.user?.appMetadata['role'];
    if (role != 'admin') {
      await client.auth.signOut();
      throw StateError('Akun ini tidak memiliki akses guru/admin.');
    }
  }

  static Future<void> signOutAdmin() async {
    if (_isInitialized) {
      await client.auth.signOut();
      await _restoreStudentSession();
    }
  }

  static Future<User?> _restoreStudentSession() async {
    final refreshToken = StudentSessionStore.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return null;
    try {
      final response = await client.auth.setSession(refreshToken);
      if (response.user?.isAnonymous == true) return response.user;
    } catch (error) {
      debugPrint('Student session could not be restored: $error');
      await StudentSessionStore.clear();
    }
    return null;
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

      var authUser = currentUser;
      if (authUser == null || !authUser.isAnonymous) {
        if (authUser != null) await client.auth.signOut();
        authUser = await _restoreStudentSession();
        if (authUser == null) {
          final authResponse = await client.auth.signInAnonymously();
          authUser = authResponse.user;
        }
      }
      if (authUser == null) {
        throw StateError('Sesi siswa tidak dapat dibuat.');
      }
      final refreshToken = client.auth.currentSession?.refreshToken;
      if (refreshToken != null) {
        await StudentSessionStore.saveRefreshToken(refreshToken);
      }

      // A persisted anonymous session always resolves to its own profile.
      final existing = await client
          .from('users')
          .select()
          .eq('id', authUser.id)
          .maybeSingle();

      if (existing != null) {
        // Update last active
        await client.from('users').update({
          'name': trimmedName,
          'class_name': trimmedClass,
          'school': trimmedSchool,
          'last_active': DateTime.now().toIso8601String(),
        }).eq('id', authUser.id);
        final result = {
          ...existing,
          'name': trimmedName,
          'class_name': trimmedClass,
          'school': trimmedSchool,
        };
        await flushPendingSync();
        return result;
      }

      // Create new student
      final inserted = await client
          .from('users')
          .insert({
            'id': authUser.id,
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

      await flushPendingSync();
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
    final data = <String, dynamic>{
      'user_id': userId,
      'last_active': DateTime.now().toIso8601String(),
    };
    if (currentSlide != null) data['current_slide'] = currentSlide;
    if (totalXp != null) data['total_xp'] = totalXp;
    if (isCompleted != null) data['is_completed'] = isCompleted;

    try {
      if (userId.startsWith('local-')) {
        await OfflineSyncQueue.enqueue(
          queueId: 'progress-$userId',
          type: 'student_progress',
          payload: data,
        );
        return;
      }
      final updateData = Map<String, dynamic>.from(data)..remove('user_id');
      await client.from('users').update(updateData).eq('id', userId);
    } catch (e) {
      debugPrint('Error updateStudentProgress: $e');
      await OfflineSyncQueue.enqueue(
        queueId: 'progress-$userId',
        type: 'student_progress',
        payload: data,
      );
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
    final record = {
      'id': _newUuid(),
      'user_id': userId,
      'student_name': studentName,
      'student_class': studentClass,
      'student_school': studentSchool,
      'module_id': moduleId,
      'case_title': caseTitle,
      'research_question': researchQuestion,
      'student_opinion': studentOpinion,
      'student_variables': studentVariables ?? '',
      'submitted_at': DateTime.now().toIso8601String(),
    };
    return _writeOrQueue('case_study', 'case_study_answers', record);
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
    final record = {
      'id': _newUuid(),
      'user_id': userId,
      'student_name': studentName,
      'student_class': studentClass,
      'student_school': studentSchool,
      'quiz_type': quizType,
      'score': score,
      'correct_count': correctCount,
      'total_questions': totalQuestions,
      'answers_detail': answersDetail ?? {},
      'completed_at': DateTime.now().toIso8601String(),
    };
    return _writeOrQueue('quiz_result', 'quiz_results', record);
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
    final record = {
      'id': _newUuid(),
      'user_id': userId,
      'student_name': studentName,
      'experiment_type': experimentType,
      'observation_data': observationData ?? {},
      'conclusion': conclusion ?? '',
      'created_at': DateTime.now().toIso8601String(),
    };
    return _writeOrQueue('lab_record', 'lab_records', record);
  }

  static Future<bool> _writeOrQueue(
    String type,
    String table,
    Map<String, dynamic> record,
  ) async {
    final queueId = record['id']!.toString();
    try {
      final authUser = currentUser;
      if (authUser == null || isCurrentUserAdmin) {
        throw StateError('Sesi siswa tidak tersedia.');
      }
      final payload = Map<String, dynamic>.from(record)
        ..['user_id'] = authUser.id;
      await client
          .from(table)
          .upsert(payload, onConflict: 'id', ignoreDuplicates: true);
      return true;
    } catch (error) {
      await OfflineSyncQueue.enqueue(
        queueId: queueId,
        type: type,
        payload: record,
      );
      return false;
    }
  }

  /// Retry queued student writes. Successfully delivered operations are
  /// removed; failed operations remain persisted for the next opportunity.
  static Future<int> flushPendingSync() async {
    final authUser = currentUser;
    if (authUser == null || isCurrentUserAdmin) return 0;

    var synced = 0;
    final operations = OfflineSyncQueue.pendingOperations;
    for (final operation in operations) {
      final queueId = operation['queue_id']?.toString();
      final type = operation['type']?.toString();
      if (queueId == null || type == null) continue;

      await OfflineSyncQueue.markAttempt(queueId);
      try {
        final payload = Map<String, dynamic>.from(
          operation['payload'] as Map,
        );
        payload['user_id'] = authUser.id;

        switch (type) {
          case 'case_study':
            await client.from('case_study_answers').upsert(
                  payload,
                  onConflict: 'id',
                  ignoreDuplicates: true,
                );
            break;
          case 'quiz_result':
            await client.from('quiz_results').upsert(
                  payload,
                  onConflict: 'id',
                  ignoreDuplicates: true,
                );
            break;
          case 'lab_record':
            await client.from('lab_records').upsert(
                  payload,
                  onConflict: 'id',
                  ignoreDuplicates: true,
                );
            break;
          case 'student_progress':
            payload.remove('user_id');
            await client.from('users').update(payload).eq('id', authUser.id);
            break;
          default:
            continue;
        }

        await OfflineSyncQueue.remove(queueId);
        synced++;
      } catch (error) {
        debugPrint('Pending sync still waiting ($type): $error');
      }
    }
    return synced;
  }

  // ===========================================================================
  // 5. ADMIN / TEACHER DASHBOARD QUERIES
  // ===========================================================================

  /// Fetch all registered students
  static Future<List<Map<String, dynamic>>> fetchAllStudents() async {
    if (!_isInitialized) return [];
    try {
      final response = await client
          .from('users')
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw SupabaseServiceException('Data siswa gagal dimuat.', e);
    }
  }

  /// Fetch all quiz results
  static Future<List<Map<String, dynamic>>> fetchAllQuizResults() async {
    if (!_isInitialized) return [];
    try {
      final response = await client
          .from('quiz_results')
          .select()
          .order('completed_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw SupabaseServiceException('Hasil kuis gagal dimuat.', e);
    }
  }

  /// Fetch all case study answers & reflections with optional filter
  static Future<List<Map<String, dynamic>>> fetchAllCaseStudyAnswers({
    String? moduleId,
    String? className,
  }) async {
    if (!_isInitialized) return [];
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
      throw SupabaseServiceException('Jawaban studi kasus gagal dimuat.', e);
    }
  }

  /// Fetch student detailed portfolio (profile + quizzes + opinions + labs)
  static Future<Map<String, dynamic>> fetchStudentDetailedPortfolio(
      String userId) async {
    try {
      final user =
          await client.from('users').select().eq('id', userId).maybeSingle();
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
  static RealtimeChannel? subscribeToDashboardChanges({
    required void Function(Map<String, dynamic> record) onNewQuiz,
    required void Function(Map<String, dynamic> record) onNewOpinion,
    required void Function(Map<String, dynamic> record) onUserChange,
  }) {
    if (!_isInitialized) return null;
    final channel = client.channel(
        'public:admin_monitoring_${DateTime.now().millisecondsSinceEpoch}');

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
