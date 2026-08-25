import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/supabase_service.dart';

class StudentPortfolioModal extends StatelessWidget {
  final Map<String, dynamic> student;

  const StudentPortfolioModal({super.key, required this.student});

  static void show(BuildContext context, Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (ctx) => StudentPortfolioModal(student: student),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentId = student['id']?.toString() ?? '';
    final name = student['name'] ?? 'Siswa';
    final className = student['class_name'] ?? '-';
    final school = student['school'] ?? '-';

    return FutureBuilder<Map<String, dynamic>>(
      future: SupabaseService.fetchStudentDetailedPortfolio(studentId),
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final data = snapshot.data ?? {};
        final quizzes = data['quizzes'] as List<dynamic>? ?? [];
        final opinions = data['opinions'] as List<dynamic>? ?? [];
        final labs = data['labs'] as List<dynamic>? ?? [];

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryGreen,
                child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'S', style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    Text('Kelas: $className  •  $school', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: isLoading
                ? const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Riwayat Nilai
                        const Text('📊 Riwayat Nilai Kuis & Evaluasi:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        if (quizzes.isEmpty)
                          const Text('Belum ada kuis yang diselesaikan.', style: TextStyle(fontSize: 11, color: Colors.grey))
                        else
                          ...quizzes.map((q) {
                            final score = (q['score'] as num?)?.toDouble() ?? 0.0;
                            final type = q['quiz_type'] ?? 'Evaluasi';
                            final correct = q['correct_count'] ?? 0;
                            final total = q['total_questions'] ?? 10;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('$type ($correct/$total benar)', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                                  Text(
                                    'Nilai: ${score.toStringAsFixed(1)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: score >= 75 ? Colors.green.shade700 : Colors.red.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                        const SizedBox(height: 14),

                        // Riwayat Jawaban Studi Kasus
                        const Text('💡 Pendapat & Studi Kasus yang Dijawab:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        if (opinions.isEmpty)
                          const Text('Belum ada studi kasus yang dijawab.', style: TextStyle(fontSize: 11, color: Colors.grey))
                        else
                          ...opinions.map((op) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFDF8),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFFFE082)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(op['case_title'] ?? 'Studi Kasus', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                                  const SizedBox(height: 2),
                                  Text(op['student_opinion'] ?? '', style: const TextStyle(fontSize: 11.5, height: 1.35)),
                                ],
                              ),
                            );
                          }),

                        const SizedBox(height: 14),

                        // Riwayat Eksperimen Lab Virtual
                        const Text('🧪 Riwayat Eksperimen Lab Virtual:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        if (labs.isEmpty)
                          const Text('Belum ada catatan eksperimen lab virtual.', style: TextStyle(fontSize: 11, color: Colors.grey))
                        else
                          ...labs.map((lab) {
                            final expType = lab['experiment_type'] ?? 'Simulasi Lab Glukosa';
                            final obs = (lab['observation_data'] as Map<String, dynamic>?) ?? {};
                            final conclusion = lab['conclusion'] ?? '';
                            final glucose = (obs['glucose_level'] as num?)?.toDouble();
                            final yeast = obs['yeast_percent'] != null ? '${obs['yeast_percent']}%' : '-';
                            final days = obs['fermentation_days'] != null ? '${obs['fermentation_days']} Hari' : '-';
                            final container = obs['container_type'] ?? (obs['is_banana_leaf'] == true ? 'Daun Pisang' : 'Plastik');
                            final taste = obs['taste_profile'] ?? '-';
                            final rating = obs['organoleptic_rating'] ?? 0;
                            final createdAt = lab['created_at'] != null
                                ? DateFormat('dd MMM yyyy, HH:mm').format(DateTime.tryParse(lab['created_at']) ?? DateTime.now())
                                : '-';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFF86EFAC)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(expType, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                                      Text(createdAt, style: const TextStyle(fontSize: 9.5, color: Color(0xFF6B7280))),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: const Color(0xFFBBF7D0)),
                                        ),
                                        child: Text('Ragi: $yeast', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF14532D))),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: const Color(0xFFBBF7D0)),
                                        ),
                                        child: Text('Lama: $days', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF14532D))),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: const Color(0xFFBBF7D0)),
                                        ),
                                        child: Text('Wadah: $container', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF14532D))),
                                      ),
                                      if (glucose != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: glucose >= 51.14 ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: glucose >= 51.14 ? const Color(0xFF22C55E) : const Color(0xFFF59E0B)),
                                          ),
                                          child: Text(
                                            'Glukosa: ${glucose.toStringAsFixed(2)}%',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: glucose >= 51.14 ? const Color(0xFF15803D) : const Color(0xFFB45309),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (taste != '-' || rating > 0) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text('Sensori: $taste', style: const TextStyle(fontSize: 10.5, color: Color(0xFF374151))),
                                        const Spacer(),
                                        Row(
                                          children: List.generate(
                                            5,
                                            (i) => Icon(
                                              Icons.star_rounded,
                                              size: 12,
                                              color: i < (rating as num) ? AppColors.goldenYellow : Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  if (conclusion.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      'Kesimpulan: $conclusion',
                                      style: const TextStyle(fontSize: 10.5, fontStyle: FontStyle.italic, color: Color(0xFF1F2937)),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
