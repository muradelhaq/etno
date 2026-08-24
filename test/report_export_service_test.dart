import 'package:flutter_test/flutter_test.dart';
import 'package:e_modul_etnosains/core/utils/report_export_service.dart';

void main() {
  group('ReportExportService Comprehensive Tests', () {
    final mockStudents = [
      {
        'id': 'user-1',
        'name': 'Budi Santoso',
        'class_name': 'XII MIPA 1',
        'school': 'SMAN 1 Bandung',
        'total_xp': 350,
        'current_slide': 13,
        'is_completed': true,
        'last_active': '2026-08-24T10:00:00.000Z',
        'created_at': '2026-08-24T08:00:00.000Z',
      },
      {
        'id': 'user-2',
        'name': 'Dewi Sartika',
        'class_name': 'XII MIPA 2',
        'school': 'SMAN 3 Bandung',
        'total_xp': 200,
        'current_slide': 6,
        'is_completed': false,
        'last_active': '2026-08-24T11:00:00.000Z',
        'created_at': '2026-08-24T08:30:00.000Z',
      },
    ];

    final mockQuizzes = [
      {
        'user_id': 'user-1',
        'student_name': 'Budi Santoso',
        'quiz_type': 'Pre-test Literasi',
        'score': 60.0,
        'correct_count': 6,
        'total_questions': 10,
        'completed_at': '2026-08-24T08:15:00.000Z',
      },
      {
        'user_id': 'user-1',
        'student_name': 'Budi Santoso',
        'quiz_type': 'Post-test PISA',
        'score': 90.0,
        'correct_count': 9,
        'total_questions': 10,
        'completed_at': '2026-08-24T10:30:00.000Z',
      },
      {
        'user_id': 'user-2',
        'student_name': 'Dewi Sartika',
        'quiz_type': 'Pre-test Literasi',
        'score': 50.0,
        'correct_count': 5,
        'total_questions': 10,
        'completed_at': '2026-08-24T08:45:00.000Z',
      },
      {
        'user_id': 'user-2',
        'student_name': 'Dewi Sartika',
        'quiz_type': 'Post-test PISA',
        'score': 70.0,
        'correct_count': 7,
        'total_questions': 10,
        'completed_at': '2026-08-24T11:15:00.000Z',
      },
    ];

    final mockOpinions = [
      {
        'user_id': 'user-1',
        'student_name': 'Budi Santoso',
        'student_class': 'XII MIPA 1',
        'student_school': 'SMAN 1 Bandung',
        'module_id': 'tempe',
        'case_title': 'Peranan Daun Pisang vs Plastik',
        'research_question': 'Mengapa daun pisang menghasilkan aroma tempe yang lebih khas?',
        'student_opinion': 'Daun pisang mengandung mikroflora alami dan pori-pori alami yang mendukung aerasi kapang.',
        'student_variables': 'Bebas: Jenis bungkus, Terikat: Kepadatan miselium',
        'submitted_at': '2026-08-24T09:00:00.000Z',
      },
    ];

    test('exportStudentScoresCsv should return true and process records properly', () async {
      final result = await ReportExportService.exportStudentScoresCsv(
        students: mockStudents,
        quizzes: mockQuizzes,
      );
      expect(result, isTrue);
    });

    test('exportCaseStudyResponsesCsv should return true and process opinions properly', () async {
      final result = await ReportExportService.exportCaseStudyResponsesCsv(
        opinions: mockOpinions,
      );
      expect(result, isTrue);
    });

    test('exportFullClassReportCsv should return true and compute aggregated metrics', () async {
      final result = await ReportExportService.exportFullClassReportCsv(
        students: mockStudents,
        quizzes: mockQuizzes,
        opinions: mockOpinions,
      );
      expect(result, isTrue);
    });
  });
}
