import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/supabase_service.dart';
import '../widgets/dialogs/admin_export_modal.dart';
import '../widgets/tabs/admin_statistics_tab.dart';
import '../widgets/tabs/admin_students_tab.dart';
import '../widgets/tabs/admin_opinions_tab.dart';

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

  RealtimeChannel? _realtimeChannel;
  int _liveEventCount = 0;

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
      try {
        SupabaseService.client.removeChannel(_realtimeChannel!);
      } catch (_) {}
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
            message:
                '${record['student_name'] ?? 'Siswa'} (${record['student_class'] ?? '-'}) menyelesaikan kuis (Skor: ${record['score'] ?? 0}).',
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
            message:
                '${record['student_name'] ?? 'Siswa'} mengirim opini inkuiri pada Modul ${(record['module_id'] ?? '').toString().toUpperCase()}.',
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

      if (mounted) {
        setState(() {
          _students = results[0];
          _quizzes = results[1];
          _opinions = results[2];
          _isLoading = false;
        });
      }
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
                Flexible(
                  child: Text(
                    _liveEventCount > 0
                        ? 'Live Sync • $_liveEventCount event baru'
                        : 'Real-time Live Connected',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFB8D5C2),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
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
                  onPressed: () => AdminExportModal.show(
                    context,
                    students: _students,
                    quizzes: _quizzes,
                    opinions: _opinions,
                    onExport: _handleExport,
                  ),
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
                // TAB 1: STATISTIK KELAS
                AdminStatisticsTab(
                  isLandscape: isLandscape,
                  students: _students,
                  quizzes: _quizzes,
                  opinions: _opinions,
                ),

                // TAB 2: DATA & PORTOFOLIO SISWA
                AdminStudentsTab(
                  isLandscape: isLandscape,
                  students: _students,
                  quizzes: _quizzes,
                ),

                // TAB 3: KOLEKSI JAWABAN & REFLEKSI SISWA
                AdminOpinionsTab(
                  isLandscape: isLandscape,
                  opinions: _opinions,
                ),
              ],
            ),
    );
  }
}
