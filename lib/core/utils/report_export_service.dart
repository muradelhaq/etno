import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'report_export_platform_stub.dart'
    if (dart.library.html) 'report_export_platform_web.dart' as platform_export;

/// Utility service untuk mengonversi data hasil belajar siswa ke format spreadsheet (CSV/Excel)
/// serta mengekspornya secara cross-platform (Web & Mobile).
class ReportExportService {
  /// Format CSV cell dengan standard RFC-4180 (escaping koma, kutip dua, dan baris baru)
  static String _escapeCsv(dynamic value) {
    if (value == null) return '""';
    final str = value.toString();
    if (str.contains(',') || str.contains('"') || str.contains('\n') || str.contains('\r')) {
      return '"${str.replaceAll('"', '""')}"';
    }
    return '"$str"';
  }

  /// Membungkus string CSV dengan UTF-8 Byte Order Mark (\uFEFF) agar Microsoft Excel
  /// membaca karakter aksen dan bahasa Indonesia dengan benar tanpa encoding rusak.
  static List<int> _encodeCsvWithBom(String csvContent) {
    final bom = [0xEF, 0xBB, 0xBF];
    final utf8Bytes = utf8.encode(csvContent);
    return [...bom, ...utf8Bytes];
  }

  static String _formatDisplayDate(DateTime dt) {
    try {
      return DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(dt);
    } catch (_) {
      return DateFormat('yyyy-MM-dd HH:mm').format(dt);
    }
  }

  static String _formatDateTimeSafe(String? isoString, {bool withSeconds = false}) {
    if (isoString == null) return '-';
    final dt = DateTime.tryParse(isoString);
    if (dt == null) return '-';
    try {
      final pattern = withSeconds ? 'dd/MM/yyyy HH:mm:ss' : 'dd/MM/yyyy HH:mm';
      return DateFormat(pattern).format(dt);
    } catch (_) {
      return dt.toIso8601String();
    }
  }

  /// 1. Ekspor Rekapitulasi Nilai & Status KKM Siswa
  static Future<bool> exportStudentScoresCsv({
    required List<Map<String, dynamic>> students,
    required List<Map<String, dynamic>> quizzes,
  }) async {
    final buffer = StringBuffer();
    final nowStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final displayDate = _formatDisplayDate(DateTime.now());

    // Title & Metadata
    buffer.writeln(_escapeCsv('REKAPITULASI NILAI EVALUASI DAN PROGRESS SISWA'));
    buffer.writeln(_escapeCsv('E-Modul Etnosains: Makanan Tradisional Berbasis Fermentasi'));
    buffer.writeln(_escapeCsv('Waktu Unduh: $displayDate WIB'));
    buffer.writeln('');

    // Header Table
    final headers = [
      'No',
      'Nama Siswa',
      'Kelas',
      'Asal Sekolah',
      'Skor Pre-Test',
      'Skor Post-Test (PISA)',
      'Status KKM (>=75)',
      'Peningkatan Skor (Gain)',
      'Total XP',
      'Status Modul',
      'Terakhir Aktif',
      'Tanggal Registrasi',
    ];
    buffer.writeln(headers.map(_escapeCsv).join(','));

    // Populate Rows
    for (int i = 0; i < students.length; i++) {
      final s = students[i];
      final studentId = s['id']?.toString() ?? '';
      final studentName = s['name']?.toString() ?? 'Siswa';

      // Find student's quizzes
      final studentQuizzes = quizzes.where((q) {
        final qUserId = q['user_id']?.toString() ?? '';
        final qName = q['student_name']?.toString() ?? '';
        return (studentId.isNotEmpty && qUserId == studentId) ||
            (qName.trim().toLowerCase() == studentName.trim().toLowerCase());
      }).toList();

      final preTest = studentQuizzes.where(
        (q) => (q['quiz_type'] ?? '').toString().toLowerCase().contains('pre'),
      ).firstOrNull;
      final postTest = studentQuizzes.where(
        (q) =>
            (q['quiz_type'] ?? '').toString().toLowerCase().contains('post') ||
            (q['quiz_type'] ?? '').toString().toLowerCase().contains('evaluasi'),
      ).firstOrNull;

      final preScore = (preTest?['score'] as num?)?.toDouble();
      final postScore = (postTest?['score'] as num?)?.toDouble();
      final double? gain = (postScore != null && preScore != null) ? (postScore - preScore) : null;
      final isPassedKkm = postScore != null ? (postScore >= 75.0 ? 'TUNTAS' : 'BELUM TUNTAS') : 'BELUM UJIAN';

      final lastActive = _formatDateTimeSafe(s['last_active']?.toString());
      final createdAt = _formatDateTimeSafe(s['created_at']?.toString());

      final row = [
        (i + 1).toString(),
        s['name'] ?? '',
        s['class_name'] ?? '',
        s['school'] ?? '',
        preScore != null ? preScore.toStringAsFixed(1) : '-',
        postScore != null ? postScore.toStringAsFixed(1) : '-',
        isPassedKkm,
        gain != null ? (gain >= 0 ? '+${gain.toStringAsFixed(1)}' : gain.toStringAsFixed(1)) : '-',
        (s['total_xp'] ?? 0).toString(),
        (s['is_completed'] == true) ? 'Selesai 100%' : 'Dalam Proses (${s['current_slide'] ?? 1}/13)',
        lastActive,
        createdAt,
      ];
      buffer.writeln(row.map(_escapeCsv).join(','));
    }

    final filename = 'Rekap_Nilai_Etnosains_$nowStr.csv';
    final bytes = Uint8List.fromList(_encodeCsvWithBom(buffer.toString()));

    return platform_export.saveAndDownloadFile(
      filename: filename,
      bytes: bytes,
      mimeType: 'text/csv;charset=utf-8',
    );
  }

  /// 2. Ekspor Transkrip Jawaban & Penalaran Studi Kasus Siswa
  static Future<bool> exportCaseStudyResponsesCsv({
    required List<Map<String, dynamic>> opinions,
  }) async {
    final buffer = StringBuffer();
    final nowStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final displayDate = _formatDisplayDate(DateTime.now());

    // Title & Metadata
    buffer.writeln(_escapeCsv('TRANSKRIP JAWABAN STUDI KASUS & HIPOTESIS SISWA'));
    buffer.writeln(_escapeCsv('E-Modul Etnosains: Makanan Tradisional Berbasis Fermentasi'));
    buffer.writeln(_escapeCsv('Waktu Unduh: $displayDate WIB'));
    buffer.writeln('');

    // Header Table
    final headers = [
      'No',
      'Nama Siswa',
      'Kelas',
      'Asal Sekolah',
      'Modul Fermentasi',
      'Judul Studi Kasus',
      'Rumusan Masalah Inkuiri',
      'Hipotesis & Opini Ilmiah Siswa',
      'Analisis Variabel',
      'Waktu Pengiriman',
    ];
    buffer.writeln(headers.map(_escapeCsv).join(','));

    // Populate Rows
    for (int i = 0; i < opinions.length; i++) {
      final op = opinions[i];
      final submittedAt = _formatDateTimeSafe(op['submitted_at']?.toString(), withSeconds: true);

      final row = [
        (i + 1).toString(),
        op['student_name'] ?? '',
        op['student_class'] ?? '',
        op['student_school'] ?? '',
        (op['module_id'] ?? '').toString().toUpperCase(),
        op['case_title'] ?? '',
        op['research_question'] ?? '',
        op['student_opinion'] ?? '',
        op['student_variables'] ?? '-',
        submittedAt,
      ];
      buffer.writeln(row.map(_escapeCsv).join(','));
    }

    final filename = 'Transkrip_Studi_Kasus_Etnosains_$nowStr.csv';
    final bytes = Uint8List.fromList(_encodeCsvWithBom(buffer.toString()));

    return platform_export.saveAndDownloadFile(
      filename: filename,
      bytes: bytes,
      mimeType: 'text/csv;charset=utf-8',
    );
  }

  /// 3. Ekspor Laporan Terpadu Kelas (Statistik, Nilai, dan Seluruh Jawaban Studi Kasus)
  static Future<bool> exportFullClassReportCsv({
    required List<Map<String, dynamic>> students,
    required List<Map<String, dynamic>> quizzes,
    required List<Map<String, dynamic>> opinions,
  }) async {
    final buffer = StringBuffer();
    final nowStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final displayDate = _formatDisplayDate(DateTime.now());

    // Hitung Statistik Agregat Kelas
    final totalStudents = students.length;
    final pretests = quizzes.where((q) => (q['quiz_type'] ?? '').toString().toLowerCase().contains('pre')).toList();
    final double avgPretest = pretests.isEmpty
        ? 0.0
        : pretests.map((q) => (q['score'] as num?)?.toDouble() ?? 0.0).reduce((a, b) => a + b) / pretests.length;

    final posttests = quizzes
        .where((q) =>
            (q['quiz_type'] ?? '').toString().toLowerCase().contains('post') ||
            (q['quiz_type'] ?? '').toString().toLowerCase().contains('evaluasi'))
        .toList();
    final double avgPosttest = posttests.isEmpty
        ? 0.0
        : posttests.map((q) => (q['score'] as num?)?.toDouble() ?? 0.0).reduce((a, b) => a + b) / posttests.length;

    final passedCount = posttests.where((q) => ((q['score'] as num?)?.toDouble() ?? 0.0) >= 75.0).length;
    final double passingRate = posttests.isEmpty ? 0.0 : (passedCount / posttests.length) * 100;
    final double nGain = (100.0 - avgPretest > 0) ? (avgPosttest - avgPretest) / (100.0 - avgPretest) : 0.0;

    // SECTION 1: RINGKASAN EKSEKUTIF KELAS
    buffer.writeln(_escapeCsv('LAPORAN LENGKAP EVALUASI & CAPAIAN PEMBELAJARAN ETNOSAINS'));
    buffer.writeln(_escapeCsv('Waktu Penerbitan: $displayDate WIB'));
    buffer.writeln('');
    buffer.writeln(_escapeCsv('RINGKASAN STATISTIK KELAS'));
    buffer.writeln('${_escapeCsv("Metrik")},${_escapeCsv("Nilai Agregat")}');
    buffer.writeln('${_escapeCsv("Total Siswa Terdaftar")},${_escapeCsv(totalStudents)}');
    buffer.writeln('${_escapeCsv("Rata-rata Skor Pre-Test")},${_escapeCsv(avgPretest.toStringAsFixed(2))}');
    buffer.writeln('${_escapeCsv("Rata-rata Skor Post-Test PISA")},${_escapeCsv(avgPosttest.toStringAsFixed(2))}');
    buffer.writeln('${_escapeCsv("Persentase Kelulusan KKM (>= 75)")},${_escapeCsv("${passingRate.toStringAsFixed(1)}% ($passedCount/${posttests.length} siswa)")}');
    buffer.writeln('${_escapeCsv("Efektivitas Pembelajaran (N-Gain)")},${_escapeCsv("${nGain.toStringAsFixed(3)} (${_getGainCategory(nGain)})")}');
    buffer.writeln('${_escapeCsv("Total Respons Studi Kasus Terkumpul")},${_escapeCsv(opinions.length)}');
    buffer.writeln('');
    buffer.writeln('');

    // SECTION 2: DATA NILAI SISWA
    buffer.writeln(_escapeCsv('--- BAGIAN 1: REKAPITULASI NILAI SISWA ---'));
    final studentHeaders = [
      'No',
      'Nama Siswa',
      'Kelas',
      'Asal Sekolah',
      'Skor Pre-Test',
      'Skor Post-Test PISA',
      'Status KKM',
      'Selisih Peningkatan',
      'Total XP',
      'Status Modul',
    ];
    buffer.writeln(studentHeaders.map(_escapeCsv).join(','));

    for (int i = 0; i < students.length; i++) {
      final s = students[i];
      final studentId = s['id']?.toString() ?? '';
      final studentName = s['name']?.toString() ?? '';

      final studentQuizzes = quizzes.where((q) {
        final qUserId = q['user_id']?.toString() ?? '';
        final qName = q['student_name']?.toString() ?? '';
        return (studentId.isNotEmpty && qUserId == studentId) ||
            (qName.trim().toLowerCase() == studentName.trim().toLowerCase());
      }).toList();

      final preTest = studentQuizzes.where(
        (q) => (q['quiz_type'] ?? '').toString().toLowerCase().contains('pre'),
      ).firstOrNull;
      final postTest = studentQuizzes.where(
        (q) =>
            (q['quiz_type'] ?? '').toString().toLowerCase().contains('post') ||
            (q['quiz_type'] ?? '').toString().toLowerCase().contains('evaluasi'),
      ).firstOrNull;

      final preScore = (preTest?['score'] as num?)?.toDouble();
      final postScore = (postTest?['score'] as num?)?.toDouble();
      final gain = (postScore != null && preScore != null) ? (postScore - preScore) : null;
      final kkm = postScore != null ? (postScore >= 75.0 ? 'TUNTAS' : 'BELUM TUNTAS') : 'BELUM UJIAN';

      final row = [
        (i + 1).toString(),
        s['name'] ?? '',
        s['class_name'] ?? '',
        s['school'] ?? '',
        preScore != null ? preScore.toStringAsFixed(1) : '-',
        postScore != null ? postScore.toStringAsFixed(1) : '-',
        kkm,
        gain != null ? (gain >= 0 ? '+${gain.toStringAsFixed(1)}' : gain.toStringAsFixed(1)) : '-',
        (s['total_xp'] ?? 0).toString(),
        (s['is_completed'] == true) ? 'Selesai' : 'Dalam Proses (${s['current_slide'] ?? 1}/13)',
      ];
      buffer.writeln(row.map(_escapeCsv).join(','));
    }

    buffer.writeln('');
    buffer.writeln('');

    // SECTION 3: TRANSKRIP JAWABAN STUDI KASUS
    buffer.writeln(_escapeCsv('--- BAGIAN 2: TRANSKRIP JAWABAN STUDI KASUS SISWA ---'));
    final opinionHeaders = [
      'No',
      'Nama Siswa',
      'Kelas',
      'Modul',
      'Judul Kasus',
      'Rumusan Masalah',
      'Hipotesis & Opini Siswa',
      'Variabel',
      'Waktu Submit',
    ];
    buffer.writeln(opinionHeaders.map(_escapeCsv).join(','));

    for (int i = 0; i < opinions.length; i++) {
      final op = opinions[i];
      final submittedAtRaw = op['submitted_at']?.toString();
      final submittedAt = submittedAtRaw != null
          ? DateFormat('dd/MM/yyyy HH:mm').format(DateTime.tryParse(submittedAtRaw) ?? DateTime.now())
          : '-';

      final row = [
        (i + 1).toString(),
        op['student_name'] ?? '',
        op['student_class'] ?? '',
        (op['module_id'] ?? '').toString().toUpperCase(),
        op['case_title'] ?? '',
        op['research_question'] ?? '',
        op['student_opinion'] ?? '',
        op['student_variables'] ?? '-',
        submittedAt,
      ];
      buffer.writeln(row.map(_escapeCsv).join(','));
    }

    final filename = 'Laporan_Lengkap_Etnosains_$nowStr.csv';
    final bytes = Uint8List.fromList(_encodeCsvWithBom(buffer.toString()));

    return platform_export.saveAndDownloadFile(
      filename: filename,
      bytes: bytes,
      mimeType: 'text/csv;charset=utf-8',
    );
  }

  static String _getGainCategory(double g) {
    if (g >= 0.7) return 'Tinggi';
    if (g >= 0.3) return 'Sedang';
    return 'Rendah';
  }
}
