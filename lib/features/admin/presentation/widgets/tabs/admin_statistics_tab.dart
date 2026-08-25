import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/theme/text_styles.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';
import '../summary/admin_metrics_summary_grid.dart';

class AdminStatisticsTab extends StatelessWidget {
  final bool isLandscape;
  final List<Map<String, dynamic>> students;
  final List<Map<String, dynamic>> quizzes;
  final List<Map<String, dynamic>> opinions;

  const AdminStatisticsTab({
    super.key,
    required this.isLandscape,
    required this.students,
    required this.quizzes,
    required this.opinions,
  });

  @override
  Widget build(BuildContext context) {
    final totalStudents = students.length;

    // Calculate Pre-test average
    final pretests = quizzes
        .where((q) => (q['quiz_type'] ?? '').toString().toLowerCase().contains('pre'))
        .toList();
    final double avgPretest = pretests.isEmpty
        ? 0.0
        : pretests
                .map((q) => (q['score'] as num?)?.toDouble() ?? 0.0)
                .reduce((a, b) => a + b) /
            pretests.length;

    // Calculate Post-test average
    final posttests = quizzes
        .where((q) =>
            (q['quiz_type'] ?? '').toString().toLowerCase().contains('post') ||
            (q['quiz_type'] ?? '').toString().toLowerCase().contains('evaluasi'))
        .toList();
    final double avgPosttest = posttests.isEmpty
        ? 0.0
        : posttests
                .map((q) => (q['score'] as num?)?.toDouble() ?? 0.0)
                .reduce((a, b) => a + b) /
            posttests.length;

    // Calculate KKM Passing Rate (score >= 75)
    final passedCount = posttests
        .where((q) => ((q['score'] as num?)?.toDouble() ?? 0.0) >= 75.0)
        .length;
    final double passingRate =
        posttests.isEmpty ? 0.0 : (passedCount / posttests.length) * 100;

    final totalOpinions = opinions.length;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 32 : 16,
        vertical: 18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Ringkasan Kelas
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.school_rounded, color: AppColors.goldenYellow, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ringkasan Capaian Pembelajaran Etnosains',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Rekapitulasi otomatis dari seluruh aktivitas siswa yang terhubung ke Cloud Supabase.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms),

          const SizedBox(height: 16),

          // 4 Grid Metric Cards
          AdminMetricsSummaryGrid(
            isLandscape: isLandscape,
            totalStudents: totalStudents,
            avgPretest: avgPretest,
            avgPosttest: avgPosttest,
            passingRate: passingRate,
          ),

          const SizedBox(height: 20),

          // N-Gain & Keterlibatan Card
          EthnoCard(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.white,
            borderColor: AppColors.primaryLight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.trending_up_rounded, color: AppColors.primaryGreen, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'Analisis Efektivitas Pembelajaran (N-Gain)',
                      style: AppTextStyles.h3.copyWith(fontSize: 14, color: AppColors.primaryDark),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: AppColors.borderSubtle),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildGainItem(
                        label: 'Skor Awal (Pre-test)',
                        score: avgPretest.toStringAsFixed(1),
                        color: Colors.amber.shade800,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_rounded, color: AppColors.primaryGreen),
                    Expanded(
                      child: _buildGainItem(
                        label: 'Skor Akhir (Post-test)',
                        score: avgPosttest.toStringAsFixed(1),
                        color: Colors.green.shade700,
                      ),
                    ),
                    Expanded(
                      child: _buildGainItem(
                        label: 'Peningkatan Skor',
                        score: '+${(avgPosttest - avgPretest).clamp(0, 100).toStringAsFixed(1)}',
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Aktivitas Pendapat & Inkuiri Siswa
          EthnoCard(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.white,
            borderColor: AppColors.goldenYellow,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFFF57F17), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Respons Studi Kasus & Pendapat: $totalOpinions Jawaban',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF1E3A2B)),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Buka tab "Koleksi Jawaban" untuk membaca teks utuh penalaran ilmiah seluruh siswa.',
                        style: TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGainItem({required String label, required String score, required Color color}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
        const SizedBox(height: 4),
        Text(
          score,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color),
        ),
      ],
    );
  }
}
