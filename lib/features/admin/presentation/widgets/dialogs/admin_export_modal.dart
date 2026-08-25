import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/utils/report_export_service.dart';

class AdminExportModal extends StatelessWidget {
  final List<Map<String, dynamic>> students;
  final List<Map<String, dynamic>> quizzes;
  final List<Map<String, dynamic>> opinions;
  final Function(Future<bool> Function() exportFn, String successMessage) onExport;

  const AdminExportModal({
    super.key,
    required this.students,
    required this.quizzes,
    required this.opinions,
    required this.onExport,
  });

  static void show(
    BuildContext context, {
    required List<Map<String, dynamic>> students,
    required List<Map<String, dynamic>> quizzes,
    required List<Map<String, dynamic>> opinions,
    required Function(Future<bool> Function() exportFn, String successMessage) onExport,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AdminExportModal(
        students: students,
        quizzes: quizzes,
        opinions: opinions,
        onExport: onExport,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A2B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.file_download_rounded, color: Color(0xFF1E3A2B), size: 26),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ekspor Laporan (Excel / CSV)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E3A2B)),
                    ),
                    Text(
                      'Format spreadsheet standar UTF-8 BOM kompatibel dengan Microsoft Excel & Google Sheets',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _buildExportTile(
            icon: Icons.table_chart_rounded,
            title: '1. Rekapitulasi Nilai & KKM Siswa',
            subtitle: 'Nilai Pre-test, Post-test PISA, ketercapaian KKM (>=75), Gain score, & XP.',
            color: const Color(0xFF2D6A4F),
            onTap: () {
              Navigator.pop(context);
              onExport(
                () => ReportExportService.exportStudentScoresCsv(
                  students: students,
                  quizzes: quizzes,
                ),
                'Rekap Nilai Siswa berhasil diekspor!',
              );
            },
          ),
          const SizedBox(height: 10),
          _buildExportTile(
            icon: Icons.forum_rounded,
            title: '2. Transkrip Jawaban Studi Kasus Inkuiri',
            subtitle: 'Koleksi penalaran ilmiah, hipotesis, dan rumusan masalah per modul pangan.',
            color: const Color(0xFFBC6C25),
            onTap: () {
              Navigator.pop(context);
              onExport(
                () => ReportExportService.exportCaseStudyResponsesCsv(
                  opinions: opinions,
                ),
                'Transkrip Studi Kasus berhasil diekspor!',
              );
            },
          ),
          const SizedBox(height: 10),
          _buildExportTile(
            icon: Icons.description_rounded,
            title: '3. Laporan Lengkap Terpadu (Semua Data)',
            subtitle: 'Statistik eksekutif kelas, tabel rekap nilai, & seluruh jawaban studi kasus.',
            color: const Color(0xFF1B4332),
            onTap: () {
              Navigator.pop(context);
              onExport(
                () => ReportExportService.exportFullClassReportCsv(
                  students: students,
                  quizzes: quizzes,
                  opinions: opinions,
                ),
                'Laporan Lengkap Kelas berhasil diekspor!',
              );
            },
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _buildExportTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E3A2B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
