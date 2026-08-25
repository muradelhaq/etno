import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminOpinionsTab extends StatefulWidget {
  final bool isLandscape;
  final List<Map<String, dynamic>> opinions;

  const AdminOpinionsTab({
    super.key,
    required this.isLandscape,
    required this.opinions,
  });

  @override
  State<AdminOpinionsTab> createState() => _AdminOpinionsTabState();
}

class _AdminOpinionsTabState extends State<AdminOpinionsTab> {
  String _selectedModuleFilter = 'all';
  String _opinionSearchQuery = '';

  @override
  Widget build(BuildContext context) {
    final modules = [
      {'id': 'all', 'label': 'Semua Modul'},
      {'id': 'tempe', 'label': 'Modul 1: Tempe'},
      {'id': 'tape', 'label': 'Modul 2: Tape'},
      {'id': 'tauco', 'label': 'Modul 3: Tauco'},
      {'id': 'kecap', 'label': 'Modul 4: Kecap'},
      {'id': 'oncom', 'label': 'Modul 5: Oncom'},
      {'id': 'budaya', 'label': 'Jelajah Budaya'},
    ];

    final filteredOpinions = widget.opinions.where((op) {
      final text = (op['student_opinion'] ?? '').toString().toLowerCase();
      final student = (op['student_name'] ?? '').toString().toLowerCase();
      final moduleId = (op['module_id'] ?? '').toString().toLowerCase();

      final matchesQuery = _opinionSearchQuery.isEmpty ||
          text.contains(_opinionSearchQuery.toLowerCase()) ||
          student.contains(_opinionSearchQuery.toLowerCase());
      final matchesModule = _selectedModuleFilter == 'all' || moduleId.contains(_selectedModuleFilter);

      return matchesQuery && matchesModule;
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isLandscape ? 32 : 16,
        vertical: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari kata kunci dalam jawaban siswa...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  onChanged: (val) => setState(() => _opinionSearchQuery = val),
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
                    value: _selectedModuleFilter,
                    items: modules.map((m) {
                      return DropdownMenuItem<String>(
                        value: m['id'],
                        child: Text(
                          m['label']!,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedModuleFilter = val);
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            'Menampilkan ${filteredOpinions.length} dari ${widget.opinions.length} jawaban studi kasus & refleksi',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: filteredOpinions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.forum_outlined, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        const Text(
                          'Belum ada jawaban studi kasus yang terekam.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredOpinions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final op = filteredOpinions[index];
                      return _buildOpinionCard(op);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpinionCard(Map<String, dynamic> op) {
    final studentName = op['student_name'] ?? 'Siswa';
    final studentClass = op['student_class'] ?? '-';
    final studentSchool = op['student_school'] ?? '-';
    final moduleTitle = op['case_title'] ?? 'Studi Kasus Inkuiri';
    final question = op['research_question'] ?? '';
    final opinion = op['student_opinion'] ?? '';
    final variables = op['student_variables'] ?? '';
    final submittedAt = op['submitted_at'] != null
        ? DateFormat('dd MMM yyyy, HH:mm')
            .format(DateTime.tryParse(op['submitted_at']) ?? DateTime.now())
        : '-';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD6E8D0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Student Name + Timestamp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: const Color(0xFF2D5A3C),
                    child: Text(
                      studentName.isNotEmpty ? studentName[0].toUpperCase() : 'S',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    studentName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E3A2B)),
                  ),
                ],
              ),
              Text(
                submittedAt,
                style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '📚 $studentClass  •  🏫 $studentSchool',
            style: const TextStyle(fontSize: 10.5, color: Color(0xFF6B7280)),
          ),

          const SizedBox(height: 8),
          const Divider(color: Color(0xFFE5E7EB)),
          const SizedBox(height: 6),

          // Case Title Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              moduleTitle,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
            ),
          ),

          if (question.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Pertanyaan: $question',
              style: const TextStyle(
                  fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF4B5563)),
            ),
          ],

          const SizedBox(height: 8),

          // Student Opinion Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDF8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFE0A3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, size: 14, color: Color(0xFFD97706)),
                    SizedBox(width: 4),
                    Text(
                      'Pendapat & Hipotesis Siswa:',
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  opinion,
                  style: const TextStyle(fontSize: 12, height: 1.45, color: Color(0xFF1F2937)),
                ),
              ],
            ),
          ),

          if (variables.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              '🧪 Analisis Variabel: $variables',
              style: const TextStyle(fontSize: 11, color: Color(0xFF374151)),
            ),
          ],
        ],
      ),
    );
  }
}
