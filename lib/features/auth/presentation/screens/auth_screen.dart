import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/ethno_card.dart';
import '../../../../shared/services/local_storage_service.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Student Controllers
  final _studentNameController = TextEditingController();
  final _studentClassController = TextEditingController();
  final _studentSchoolController = TextEditingController();
  final _studentFormKey = GlobalKey<FormState>();

  // Admin Controllers
  final _adminPinController = TextEditingController();
  final _adminFormKey = GlobalKey<FormState>();
  bool _isAdminPinObscured = true;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Pre-populate if already in local storage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProgressProvider);
      if (user.studentName != 'Siswa Etnosains' && user.studentName.isNotEmpty) {
        _studentNameController.text = user.studentName;
      }
      if (user.studentClass != 'Kelas Biologi' && user.studentClass.isNotEmpty) {
        _studentClassController.text = user.studentClass;
      }
      if (user.studentSchool != 'Sekolah Menengah Atas' && user.studentSchool.isNotEmpty) {
        _studentSchoolController.text = user.studentSchool;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _studentNameController.dispose();
    _studentClassController.dispose();
    _studentSchoolController.dispose();
    _adminPinController.dispose();
    super.dispose();
  }

  Future<void> _handleStudentSubmit() async {
    if (!_studentFormKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final name = _studentNameController.text.trim();
    final className = _studentClassController.text.trim();
    final school = _studentSchoolController.text.trim();

    try {
      // Register or Login in Supabase
      final supabaseUser = await SupabaseService.registerOrLoginStudent(
        name: name,
        className: className,
        school: school,
      );

      final userId = supabaseUser?['id']?.toString() ?? 'local-${DateTime.now().millisecondsSinceEpoch}';

      // Save locally to Riverpod / SharedPreferences
      await ref.read(userProgressProvider.notifier).updateStudentProfile(
        id: userId,
        name: name,
        className: className,
        school: school,
        role: 'siswa',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text('Selamat datang, $name! Selamat belajar.')),
              ],
            ),
            backgroundColor: AppColors.primaryGreen,
            duration: const Duration(seconds: 2),
          ),
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleAdminSubmit() {
    if (!_adminFormKey.currentState!.validate()) return;

    final pin = _adminPinController.text.trim();

    // Accepted Admin PINs
    if (pin == '123456' || pin == 'admin123' || pin == 'guruetno') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.verified_user_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('Akses Guru / Admin Diterima!'),
            ],
          ),
          backgroundColor: AppColors.primaryDark,
          duration: Duration(seconds: 2),
        ),
      );
      context.go('/admin');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Text('PIN / Kata Sandi Guru Salah! (Coba: 123456)'),
            ],
          ),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isLandscape ? 40 : 20,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Emblem Header
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark.withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.biotech_rounded,
                          size: 38,
                          color: AppColors.goldenYellow,
                        ),
                      ),
                    ),
                  ).animate().scale(duration: 400.ms),

                  const SizedBox(height: 14),

                  // Title & Subtitle
                  Text(
                    'E-MODUL ETNOSAINS',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h1.copyWith(
                      fontSize: 22,
                      color: AppColors.primaryDark,
                      letterSpacing: 0.8,
                    ),
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 4),

                  Text(
                    'Bioteknologi Fermentasi Pangan Tradisional Nusantara',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 24),

                  // Auth Card with Tabs
                  EthnoCard(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.white,
                    borderColor: AppColors.primaryLight.withValues(alpha: 0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Custom Tab Bar
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF3EA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              color: AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: const Color(0xFF2D5A3C),
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            tabs: const [
                              Tab(
                                icon: Icon(Icons.school_rounded, size: 18),
                                text: 'Masuk Siswa',
                              ),
                              Tab(
                                icon: Icon(Icons.admin_panel_settings_rounded, size: 18),
                                text: 'Akses Guru / Admin',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Tab Views
                        SizedBox(
                          height: 320,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // 1. FORM SISWA
                              _buildStudentForm(),

                              // 2. FORM ADMIN / GURU
                              _buildAdminForm(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().slideY(begin: 0.1, duration: 400.ms).fadeIn(),

                  const SizedBox(height: 16),

                  // Cloud Supabase Connection Status Badge
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFC8E6C9)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cloud_done_rounded, size: 14, color: Color(0xFF2E7D32)),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Database Supabase Aktif & Tersinkronisasi',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 1. STUDENT FORM
  Widget _buildStudentForm() {
    return Form(
      key: _studentFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Nama Lengkap Input
          TextFormField(
            controller: _studentNameController,
            decoration: InputDecoration(
              labelText: 'Nama Lengkap Siswa',
              hintText: 'Contoh: Ahmad Fauzi',
              prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primaryGreen),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: const Color(0xFFFAFBF9),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            validator: (val) =>
                (val == null || val.trim().isEmpty) ? 'Nama siswa wajib diisi' : null,
          ),

          const SizedBox(height: 12),

          // Kelas Input
          TextFormField(
            controller: _studentClassController,
            decoration: InputDecoration(
              labelText: 'Kelas / Jurusan',
              hintText: 'Contoh: XII MIPA 1 / XI IPA 2',
              prefixIcon: const Icon(Icons.class_outlined, color: AppColors.primaryGreen),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: const Color(0xFFFAFBF9),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            validator: (val) =>
                (val == null || val.trim().isEmpty) ? 'Kelas wajib diisi' : null,
          ),

          const SizedBox(height: 12),

          // Sekolah Input
          TextFormField(
            controller: _studentSchoolController,
            decoration: InputDecoration(
              labelText: 'Nama Sekolah',
              hintText: 'Contoh: SMAN 1 Bandung',
              prefixIcon: const Icon(Icons.account_balance_outlined, color: AppColors.primaryGreen),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: const Color(0xFFFAFBF9),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            validator: (val) =>
                (val == null || val.trim().isEmpty) ? 'Nama sekolah wajib diisi' : null,
          ),

          const Spacer(),

          // Submit Button
          CustomButton(
            text: _isLoading ? 'Menghubungkan...' : 'Mulai Belajar E-Modul',
            icon: Icons.play_arrow_rounded,
            isFullWidth: true,
            backgroundColor: AppColors.primaryGreen,
            onPressed: _isLoading ? null : _handleStudentSubmit,
          ),
        ],
      ),
    );
  }

  // 2. ADMIN / TEACHER FORM
  Widget _buildAdminForm() {
    return Form(
      key: _adminFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Color(0xFFF57F17), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Portal khusus Guru / Pengajar untuk memantau statistik kelas, rekap nilai, dan membaca jawaban seluruh siswa.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF5D4037),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // PIN Input
          TextFormField(
            controller: _adminPinController,
            obscureText: _isAdminPinObscured,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'PIN / Kata Sandi Guru',
              hintText: 'Masukkan PIN akses admin (Default: 123456)',
              prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primaryDark),
              suffixIcon: IconButton(
                icon: Icon(
                  _isAdminPinObscured ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isAdminPinObscured = !_isAdminPinObscured;
                  });
                },
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: const Color(0xFFFAFBF9),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            validator: (val) =>
                (val == null || val.trim().isEmpty) ? 'PIN Admin wajib diisi' : null,
          ),

          const Spacer(),

          // Submit Button
          CustomButton(
            text: 'Buka Dashboard Guru / Admin',
            icon: Icons.dashboard_rounded,
            isFullWidth: true,
            backgroundColor: AppColors.primaryDark,
            onPressed: _handleAdminSubmit,
          ),
        ],
      ),
    );
  }
}
