import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/utils/report_export_service.dart';
import '../../../../core/widgets/ethno_card.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _isLoading = true;
  bool _isExporting = false;
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _quizzes = [];
  List<Map<String, dynamic>> _opinions = [];

  // Realtime Channel
  RealtimeChannel? _realtimeChannel;
  int _liveEventCount = 0;

  // Filter States
  String _selectedClassFilter = 'all';
  String _selectedModuleFilter = 'all';
  String _searchQuery = '';
  String _opinionSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDashboardData();
    _setupRealtimeSubscription();
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (_realtimeChannel != null) {
      SupabaseService.client.removeChannel(_realtimeChannel!);
    }
    super.dispose();
  }

  void _setupRealtimeSubscription() {
    try {
      _realtimeChannel = SupabaseService.subscribeToDashboardChanges(
        onNewQuiz: (record) {
          if (!mounted) return;
          setState(() {
            _quizzes.insert(0, record);
            _liveEventCount++;
          });
          _showLiveAlert(
            title: '🔔 Evaluasi Kuis Masuk!',
            message: '${record['student_name'] ?? 'Siswa'} (${record['student_class'] ?? '-'}) menyelesaikan kuis (Skor: ${record['score'] ?? 0}).',
            color: const Color(0xFF2E7D32),
          );
        },
        onNewOpinion: (record) {
          if (!mounted) return;
          setState(() {
            _opinions.insert(0, record);
            _liveEventCount++;
          });
          _showLiveAlert(
            title: '💬 Studi Kasus Baru Masuk!',
            message: '${record['student_name'] ?? 'Siswa'} mengirim opini inkuiri pada Modul ${(record['module_id'] ?? '').toString().toUpperCase()}.',
            color: const Color(0xFFE65100),
          );
        },
        onUserChange: (record) {
          if (!mounted) return;
          setState(() {
            final idx = _students.indexWhere((s) => s['id'] == record['id']);
            if (idx >= 0) {
              _students[idx] = record;
            } else {
              _students.insert(0, record);
            }
            _liveEventCount++;
          });
        },
      );
    } catch (e) {
      debugPrint('Error setting up realtime subscription: $e');
    }
  }

  void _showLiveAlert({required String title, required String message, required Color color}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.bolt_rounded, color: AppColors.goldenYellow, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                  Text(message, style: const TextStyle(fontSize: 11.5, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        SupabaseService.fetchAllStudents(),
        SupabaseService.fetchAllQuizResults(),
        SupabaseService.fetchAllCaseStudyAnswers(),
      ]);

      setState(() {
        _students = results[0];
        _quizzes = results[1];
        _opinions = results[2];
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading admin data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleExport(Future<bool> Function() exportFn, String successMessage) async {
    setState(() => _isExporting = true);
    try {
      final success = await exportFn();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(success ? Icons.check_circle_rounded : Icons.error_outline_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Text(success ? successMessage : 'Gagal mengekspor laporan.'),
              ],
            ),
            backgroundColor: success ? const Color(0xFF2D6A4F) : Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan ekspor: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  void _showExportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
                Navigator.pop(ctx);
                _handleExport(
                  () => ReportExportService.exportStudentScoresCsv(
                    students: _students,
                    quizzes: _quizzes,
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
                Navigator.pop(ctx);
                _handleExport(
                  () => ReportExportService.exportCaseStudyResponsesCsv(
                    opinions: _opinions,
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
                Navigator.pop(ctx);
                _handleExport(
                  () => ReportExportService.exportFullClassReportCsv(
                    students: _students,
                    quizzes: _quizzes,
                    opinions: _opinions,
                  ),
                  'Laporan Lengkap Kelas berhasil diekspor!',
                );
              },
            ),
            const SizedBox(height: 14),
          ],
        ),
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

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A2B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.go('/'),
          tooltip: 'Kembali ke E-Modul',
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard Guru & Evaluasi Etnosains',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.3, 1.3),
                      duration: 800.ms,
                    ),
                const SizedBox(width: 6),
                Text(
                  _liveEventCount > 0
                      ? 'Live Sync Aktif • $_liveEventCount aktivitas masuk'
                      : 'Database Supabase Online • Real-time Live Connected',
                  style: const TextStyle(
                    color: Color(0xFFB8D5C2),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Tombol Ekspor Excel / CSV
          _isExporting
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.goldenYellow),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.file_download_rounded, color: AppColors.goldenYellow),
                  onPressed: () => _showExportModal(context),
                  tooltip: 'Ekspor Rekap Nilai (Excel / CSV)',
                ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _loadDashboardData,
            tooltip: 'Segarkan Data',
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white70),
            onPressed: () => context.go('/auth'),
            tooltip: 'Ganti Akun / Keluar',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.goldenYellow,
          indicatorWeight: 3,
          labelColor: AppColors.goldenYellow,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.analytics_rounded, size: 18), text: 'Statistik Kelas'),
            Tab(icon: Icon(Icons.people_alt_rounded, size: 18), text: 'Data Siswa'),
            Tab(icon: Icon(Icons.forum_rounded, size: 18), text: 'Koleksi Jawaban'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryGreen),
                  SizedBox(height: 14),
                  Text('Memuat data dari Supabase...', style: TextStyle(color: Color(0xFF2D5A3C))),
                ],
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                // TAB 1: STATISTIK & RINGKASAN KELAS
                _buildTabStatistics(isLandscape),

                // TAB 2: DATA & PORTOFOLIO SISWA
                _buildTabStudents(isLandscape),

                // TAB 3: KOLEKSI JAWABAN & REFLEKSI SELURUH SISWA
                _buildTabOpinions(isLandscape),
              ],
            ),
    );
  }

  // ===========================================================================
  // TAB 1: STATISTIK KELAS
  // ===========================================================================
  Widget _buildTabStatistics(bool isLandscape) {
    final totalStudents = _students.length;

    // Calculate Pre-test average
    final pretests = _quizzes.where((q) => (q['quiz_type'] ?? '').toString().toLowerCase().contains('pre')).toList();
    final double avgPretest = pretests.isEmpty
        ? 0.0
        : pretests.map((q) => (q['score'] as num?)?.toDouble() ?? 0.0).reduce((a, b) => a + b) / pretests.length;

    // Calculate Post-test average
    final posttests = _quizzes.where((q) => (q['quiz_type'] ?? '').toString().toLowerCase().contains('post') || (q['quiz_type'] ?? '').toString().toLowerCase().contains('evaluasi')).toList();
    final double avgPosttest = posttests.isEmpty
        ? 0.0
        : posttests.map((q) => (q['score'] as num?)?.toDouble() ?? 0.0).reduce((a, b) => a + b) / posttests.length;

    // Calculate KKM Passing Rate (score >= 75)
    final passedCount = posttests.where((q) => ((q['score'] as num?)?.toDouble() ?? 0.0) >= 75.0).length;
    final double passingRate = posttests.isEmpty ? 0.0 : (passedCount / posttests.length) * 100;

    // Total Opinions Submitted
    final totalOpinions = _opinions.length;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isLandscape ? 32 : 16, vertical: 18),
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
          GridView.count(
            crossAxisCount: isLandscape ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isLandscape ? 1.4 : 1.3,
            children: [
              _buildMetricCard(
                title: 'Total Siswa',
                value: '$totalStudents',
                unit: 'Siswa Terdaftar',
                icon: Icons.people_alt_rounded,
                color: const Color(0xFF1E3A2B),
                bgColor: const Color(0xFFE8F5E9),
              ),
              _buildMetricCard(
                title: 'Rata-rata Pre-test',
                value: avgPretest.toStringAsFixed(1),
                unit: 'Skala 100',
                icon: Icons.assignment_outlined,
                color: const Color(0xFFD97706),
                bgColor: const Color(0xFFFEF3C7),
              ),
              _buildMetricCard(
                title: 'Rata-rata Post-test',
                value: avgPosttest.toStringAsFixed(1),
                unit: 'Skala 100',
                icon: Icons.verified_rounded,
                color: const Color(0xFF059669),
                bgColor: const Color(0xFFD1FAE5),
              ),
              _buildMetricCard(
                title: 'Kelulusan KKM',
                value: '${passingRate.toStringAsFixed(0)}%',
                unit: 'KKM ≥ 75.0',
                icon: Icons.military_tech_rounded,
                color: const Color(0xFF2563EB),
                bgColor: const Color(0xFFDBEAFE),
              ),
            ],
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

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4B5563),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
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

  // ===========================================================================
  // TAB 2: DATA & PORTOFOLIO SISWA
  // ===========================================================================
  Widget _buildTabStudents(bool isLandscape) {
    // Extract unique classes for filter
    final classes = <String>{'all'};
    for (final s in _students) {
      if (s['class_name'] != null && s['class_name'].toString().isNotEmpty) {
        classes.add(s['class_name'].toString());
      }
    }

    final filteredStudents = _students.where((s) {
      final name = (s['name'] ?? '').toString().toLowerCase();
      final school = (s['school'] ?? '').toString().toLowerCase();
      final className = (s['class_name'] ?? '').toString();

      final matchesQuery = _searchQuery.isEmpty ||
          name.contains(_searchQuery.toLowerCase()) ||
          school.contains(_searchQuery.toLowerCase());
      final matchesClass = _selectedClassFilter == 'all' || className == _selectedClassFilter;

      return matchesQuery && matchesClass;
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isLandscape ? 32 : 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter & Search Row
          Row(
            children: [
              // Search Field
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

              // Class Filter Dropdown
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

          // Total Count Header
          Text(
            'Menampilkan ${filteredStudents.length} dari ${_students.length} siswa',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),

          const SizedBox(height: 8),

          // Student List
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

    // Find student's quizzes
    final studentQuizzes = _quizzes.where((q) => q['user_id'] == studentId || q['student_name'] == name).toList();
    final latestQuiz = studentQuizzes.isNotEmpty ? studentQuizzes.first : null;
    final double score = latestQuiz != null ? (latestQuiz['score'] as num?)?.toDouble() ?? 0.0 : 0.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.6)),
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
          // Avatar Initial
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primaryGreen,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'S',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),

          // Student Identity
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A2B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCompleted) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF059669)),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '📚 $className  •  🏫 $school',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF4B5563)),
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
                      child: Text(
                        '⭐ $xp XP',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (latestQuiz != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: score >= 75 ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Nilai: ${score.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: score >= 75 ? const Color(0xFF065F46) : const Color(0xFF991B1B),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Detail Button
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primaryGreen),
            onPressed: () => _showStudentDetailDialog(student),
            tooltip: 'Lihat Detail Portofolio',
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TAB 3: KOLEKSI JAWABAN & REFLEKSI SISWA
  // ===========================================================================
  Widget _buildTabOpinions(bool isLandscape) {
    final modules = [
      {'id': 'all', 'label': 'Semua Modul'},
      {'id': 'tempe', 'label': 'Modul 1: Tempe'},
      {'id': 'tape', 'label': 'Modul 2: Tape'},
      {'id': 'tauco', 'label': 'Modul 3: Tauco'},
      {'id': 'kecap', 'label': 'Modul 4: Kecap'},
      {'id': 'oncom', 'label': 'Modul 5: Oncom'},
      {'id': 'budaya', 'label': 'Jelajah Budaya'},
    ];

    final filteredOpinions = _opinions.where((op) {
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
      padding: EdgeInsets.symmetric(horizontal: isLandscape ? 32 : 16, vertical: 14),
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
            'Menampilkan ${filteredOpinions.length} dari ${_opinions.length} jawaban studi kasus & refleksi',
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
        ? DateFormat('dd MMM yyyy, HH:mm').format(DateTime.tryParse(op['submitted_at']) ?? DateTime.now())
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
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    studentName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E3A2B)),
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
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
            ),
          ),

          if (question.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Pertanyaan: $question',
              style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF4B5563)),
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
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
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

  // ===========================================================================
  // MODAL DIALOG DETAIL PORTOFOLIO SISWA
  // ===========================================================================
  void _showStudentDetailDialog(Map<String, dynamic> student) async {
    final studentId = student['id']?.toString() ?? '';
    final name = student['name'] ?? 'Siswa';
    final className = student['class_name'] ?? '-';
    final school = student['school'] ?? '-';

    showDialog(
      context: context,
      builder: (ctx) {
        return FutureBuilder<Map<String, dynamic>>(
          future: SupabaseService.fetchStudentDetailedPortfolio(studentId),
          builder: (context, snapshot) {
            final isLoading = snapshot.connectionState == ConnectionState.waiting;
            final data = snapshot.data ?? {};
            final quizzes = data['quizzes'] as List<dynamic>? ?? [];
            final opinions = data['opinions'] as List<dynamic>? ?? [];

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryGreen,
                    child: Text(name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
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
                          ],
                        ),
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Tutup'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
