import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import '../dialogs/student_portfolio_modal.dart';

class AdminStudentsTab extends StatefulWidget {
  final bool isLandscape;
  final List<Map<String, dynamic>> students;
  final List<Map<String, dynamic>> quizzes;

  const AdminStudentsTab({
    super.key,
    required this.isLandscape,
    required this.students,
    required this.quizzes,
  });

  @override
  State<AdminStudentsTab> createState() => _AdminStudentsTabState();
}

class _AdminStudentsTabState extends State<AdminStudentsTab> {
  String _selectedClassFilter = 'all';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final classes = <String>{'all'};
    for (final s in widget.students) {
      if (s['class_name'] != null && s['class_name'].toString().isNotEmpty) {
        classes.add(s['class_name'].toString());
      }
    }

    final filteredStudents = widget.students.where((s) {
      final name = (s['name'] ?? '').toString().toLowerCase();
      final school = (s['school'] ?? '').toString().toLowerCase();
      final className = (s['class_name'] ?? '').toString();

      final matchesQuery = _searchQuery.isEmpty ||
          name.contains(_searchQuery.toLowerCase()) ||
          school.contains(_searchQuery.toLowerCase());
      final matchesClass =
          _selectedClassFilter == 'all' || className == _selectedClassFilter;

      return matchesQuery && matchesClass;
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isLandscape ? 32 : 16,
        vertical: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari nama siswa atau sekolah...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedClassFilter,
                    items: classes.map((c) {
                      return DropdownMenuItem<String>(
                        value: c,
                        child: Text(
                          c == 'all' ? 'Semua Kelas' : c,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedClassFilter = val);
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            'Menampilkan ${filteredStudents.length} dari ${widget.students.length} siswa',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: filteredStudents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_search_rounded, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        const Text('Tidak ada siswa yang cocok dengan filter.', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredStudents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final student = filteredStudents[index];
                      return _buildStudentCard(student);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    final studentId = student['id']?.toString() ?? '';
    final name = student['name'] ?? 'Siswa';
    final className = student['class_name'] ?? '-';
    final school = student['school'] ?? '-';
    final xp = student['total_xp'] ?? 0;
    final isCompleted = student['is_completed'] == true;

    final studentQuizzes = widget.quizzes
        .where((q) => q['user_id'] == studentId || q['student_name'] == name)
        .toList();
    final latestQuiz = studentQuizzes.isNotEmpty ? studentQuizzes.first : null;
    final double score =
        latestQuiz != null ? (latestQuiz['score'] as num?)?.toDouble() ?? 0.0 : 0.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.15),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'S',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Color(0xFF1E3A2B)),
                    ),
                    if (isCompleted) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF2E7D32)),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Kelas: $className  •  $school',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.bolt_rounded, size: 12, color: Color(0xFFD97706)),
                          const SizedBox(width: 2),
                          Text(
                            '$xp XP',
                            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (studentQuizzes.isNotEmpty)
                      Text(
                        'Skor Terakhir: ${score.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: score >= 75 ? const Color(0xFF059669) : const Color(0xFFDC2626),
                        ),
                      )
                    else
                      const Text(
                        'Belum Kuis',
                        style: TextStyle(fontSize: 10.5, color: Colors.grey),
                      ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => StudentPortfolioModal.show(context, student),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A2B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: const Size(60, 32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Detail', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
