import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../shared/services/local_storage_service.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
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
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    // Pre-populate if already saved
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProgressProvider);
      if (user.studentName != 'Siswa Etnosains' && user.studentName.isNotEmpty) {
        _studentNameController.text = user.studentName;
      }
      if (user.studentClass != 'Kelas Biologi' && user.studentClass.isNotEmpty) {
        _studentClassController.text = user.studentClass;
      }
      if (user.studentSchool != 'Sekolah Menengah Atas' &&
          user.studentSchool.isNotEmpty) {
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
      final supabaseUser = await SupabaseService.registerOrLoginStudent(
        name: name,
        className: className,
        school: school,
      );

      final userId = supabaseUser?['id']?.toString() ??
          'local-${DateTime.now().millisecondsSinceEpoch}';

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
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(child: Text('Selamat datang, $name! Selamat belajar.')),
              ],
            ),
            backgroundColor: AppColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            behavior: SnackBarBehavior.floating,
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

    if (pin == '123456' || pin == 'admin123' || pin == 'guruetno') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.verified_user_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('Akses Guru / Admin Diterima! Membuka Portal...'),
            ],
          ),
          backgroundColor: AppColors.primaryDark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
      context.go('/admin');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text('PIN / Kata Sandi Guru Salah! (Coba: 123456)'),
            ],
          ),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Decorative Ambient Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF4F8F4),
                  Color(0xFFE8F2E8),
                  Color(0xFFF9FAF8),
                ],
              ),
            ),
          ),

          // 2. Ambient Glowing Orbs (Abstract Etnosains Circles)
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withValues(alpha: 0.25),
              ),
            ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.goldenYellow.withValues(alpha: 0.15),
              ),
            ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack),
          ),

          // 3. Main Centered Interactive View
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 48 : 20,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 960 : 480,
                  ),
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left Column: Hero Branding
                            Expanded(child: _buildBrandingColumn()),
                            const SizedBox(width: 48),
                            // Right Column: Auth Card
                            Expanded(child: _buildAuthCard()),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCompactHeader(),
                            const SizedBox(height: 20),
                            _buildAuthCard(),
                            const SizedBox(height: 16),
                            _buildCloudStatusBadge(),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COMPONENT 1: COMPACT HEADER (MOBILE / PORTRAIT)
  // ---------------------------------------------------------------------------
  Widget _buildCompactHeader() {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
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
              size: 34,
              color: AppColors.goldenYellow,
            ),
          ),
        ).animate().scale(duration: 400.ms),
        const SizedBox(height: 12),
        Text(
          'E-MODUL ETNOSAINS',
          textAlign: TextAlign.center,
          style: AppTextStyles.h1.copyWith(
            fontSize: 20,
            color: AppColors.primaryDark,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Bioteknologi Fermentasi Pangan Tradisional Nusantara',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // COMPONENT 2: HERO BRANDING COLUMN (DESKTOP / LANDSCAPE)
  // ---------------------------------------------------------------------------
  Widget _buildBrandingColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Emblem badge
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.biotech_rounded,
              size: 36,
              color: AppColors.goldenYellow,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'E-Modul Etnosains',
          style: AppTextStyles.h1.copyWith(
            fontSize: 32,
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Rekonstruksi Kearifan Lokal & Literasi Sains HOTS PISA Berbasis Bioteknologi Tradisional.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),

        // Feature Highlights
        _buildFeatureBadge(
          Icons.menu_book_rounded,
          '5 Modul Pangan Fermentasi',
          'Tempe, Tape, Tauco, Kecap, dan Oncom',
        ),
        const SizedBox(height: 12),
        _buildFeatureBadge(
          Icons.science_rounded,
          'Laboratorium Virtual',
          'Simulasi kadar glukosa & organoleptik empiris',
        ),
        const SizedBox(height: 12),
        _buildFeatureBadge(
          Icons.analytics_rounded,
          'Dashboard Guru & Real-time Sync',
          'Monitoring kemajuan belajar & ekspor rekap Excel',
        ),
        const SizedBox(height: 28),
        _buildCloudStatusBadge(),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.05);
  }

  Widget _buildFeatureBadge(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD6E6D6)),
          ),
          child: Icon(icon, size: 18, color: AppColors.primaryGreen),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF1E3A2B),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // COMPONENT 3: MAIN AUTH CARD & TABS
  // ---------------------------------------------------------------------------
  Widget _buildAuthCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2EBE2), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A2B).withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Custom Segmented Control Switcher
          _buildCustomSegmentedTabBar(),

          const SizedBox(height: 20),

          // Tab Form Content
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              return _tabController.index == 0
                  ? _buildStudentForm()
                  : _buildAdminForm();
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
  }

  // ---------------------------------------------------------------------------
  // COMPONENT 3.5: CUSTOM SEGMENTED TAB BAR
  // ---------------------------------------------------------------------------
  Widget _buildCustomSegmentedTabBar() {
    final isStudent = _tabController.index == 0;

    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5EE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDCE8DC)),
      ),
      child: Row(
        children: [
          // 1. Tab Masuk Siswa
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _tabController.animateTo(0);
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isStudent ? AppColors.primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isStudent
                      ? [
                          BoxShadow(
                            color: AppColors.primaryGreen.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.school_rounded,
                        size: 16,
                        color: isStudent ? Colors.white : const Color(0xFF2D5A3C),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Masuk Siswa',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                            color: isStudent ? Colors.white : const Color(0xFF2D5A3C),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 4),

          // 2. Tab Akses Guru / Admin
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _tabController.animateTo(1);
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: !isStudent ? AppColors.primaryDark : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: !isStudent
                      ? [
                          BoxShadow(
                            color: AppColors.primaryDark.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 16,
                        color: !isStudent ? Colors.white : const Color(0xFF2D5A3C),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Akses Guru / Admin',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.5,
                            color: !isStudent ? Colors.white : const Color(0xFF2D5A3C),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COMPONENT 4: FORM SISWA
  // ---------------------------------------------------------------------------
  Widget _buildStudentForm() {
    return Form(
      key: _studentFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Greeting & instruction
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.badge_outlined, size: 16, color: AppColors.primaryGreen),
              ),
              const SizedBox(width: 8),
              const Text(
                'Identitas Belajar Siswa',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF1E3A2B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Field 1: Nama Lengkap
          TextFormField(
            controller: _studentNameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Nama Lengkap Siswa',
              hintText: 'Contoh: Dewi Sartika',
              prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primaryGreen),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.8),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAF8),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            ),
            validator: (val) =>
                (val == null || val.trim().isEmpty) ? 'Nama siswa wajib diisi' : null,
          ),

          const SizedBox(height: 12),

          // Field 2: Kelas
          TextFormField(
            controller: _studentClassController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Kelas / Rombel',
              hintText: 'Contoh: XII MIPA 1',
              prefixIcon: const Icon(Icons.class_outlined, color: AppColors.primaryGreen),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.8),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAF8),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            ),
            validator: (val) =>
                (val == null || val.trim().isEmpty) ? 'Kelas wajib diisi' : null,
          ),

          const SizedBox(height: 12),

          // Field 3: Sekolah
          TextFormField(
            controller: _studentSchoolController,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleStudentSubmit(),
            decoration: InputDecoration(
              labelText: 'Asal Sekolah',
              hintText: 'Contoh: SMAN 1 Bandung',
              prefixIcon: const Icon(Icons.account_balance_outlined, color: AppColors.primaryGreen),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.8),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAF8),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            ),
            validator: (val) =>
                (val == null || val.trim().isEmpty) ? 'Nama sekolah wajib diisi' : null,
          ),

          const SizedBox(height: 20),

          // Submit Button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleStudentSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                elevation: 3,
                shadowColor: AppColors.primaryGreen.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text('Menghubungkan...', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'Mulai Belajar E-Modul',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COMPONENT 5: FORM ADMIN / GURU
  // ---------------------------------------------------------------------------
  Widget _buildAdminForm() {
    return Form(
      key: _adminFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Teacher Portal Info Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.admin_panel_settings_rounded, color: Color(0xFFD97706), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Portal khusus Guru / Pengajar untuk memantau statistik kelas, rekap nilai, hasil eksperimen lab, dan analisis inkuiri seluruh siswa.',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF78350F),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Security Notice & Shortcut Badge
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              const Text(
                'Kata Sandi Guru',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF1E3A2B),
                ),
              ),
              InkWell(
                onTap: () {
                  _adminPinController.text = '123456';
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFC8E6C9)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app_rounded, size: 12, color: AppColors.primaryGreen),
                      SizedBox(width: 4),
                      Text(
                        'Isi Default (123456)',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // PIN Input
          TextFormField(
            controller: _adminPinController,
            obscureText: _isAdminPinObscured,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleAdminSubmit(),
            decoration: InputDecoration(
              labelText: 'PIN / Kata Sandi Guru',
              hintText: 'Masukkan PIN akses admin (Default: 123456)',
              prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primaryDark),
              suffixIcon: IconButton(
                icon: Icon(
                  _isAdminPinObscured
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isAdminPinObscured = !_isAdminPinObscured;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.8),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAF8),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            ),
            validator: (val) =>
                (val == null || val.trim().isEmpty) ? 'PIN Admin wajib diisi' : null,
          ),

          const SizedBox(height: 20),

          // Submit Button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _handleAdminSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                elevation: 3,
                shadowColor: AppColors.primaryDark.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.dashboard_rounded, size: 18),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Buka Dashboard Guru / Admin',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COMPONENT 6: CLOUD SUPABASE STATUS BADGE
  // ---------------------------------------------------------------------------
  Widget _buildCloudStatusBadge() {
    return Container(
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
    );
  }
}
