import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/services/supabase_service.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';

class StudentLoginForm extends ConsumerStatefulWidget {
  const StudentLoginForm({super.key});

  @override
  ConsumerState<StudentLoginForm> createState() => _StudentLoginFormState();
}

class _StudentLoginFormState extends ConsumerState<StudentLoginForm> {
  final _studentNameController = TextEditingController();
  final _studentClassController = TextEditingController();
  final _studentSchoolController = TextEditingController();
  final _studentFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userProgressProvider);
      if (user.studentName != 'Siswa Etnosains' &&
          user.studentName.isNotEmpty) {
        _studentNameController.text = user.studentName;
      }
      if (user.studentClass != 'Kelas Biologi' &&
          user.studentClass.isNotEmpty) {
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
    _studentNameController.dispose();
    _studentClassController.dispose();
    _studentSchoolController.dispose();
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
        final isOffline = supabaseUser?['sync_status'] == 'offline';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  isOffline
                      ? Icons.cloud_off_rounded
                      : Icons.check_circle_rounded,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isOffline
                        ? 'Profil tersimpan di perangkat. Sinkronisasi cloud akan dicoba lagi saat online.'
                        : 'Selamat datang, $name! Selamat belajar.',
                  ),
                ),
              ],
            ),
            backgroundColor:
                isOffline ? AppColors.warmTerracotta : AppColors.primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _studentFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.badge_outlined,
                    size: 16, color: AppColors.primaryGreen),
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
              prefixIcon: const Icon(Icons.person_outline_rounded,
                  color: AppColors.primaryGreen),
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
                borderSide:
                    const BorderSide(color: AppColors.primaryGreen, width: 1.8),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAF8),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            ),
            validator: (val) => (val == null || val.trim().isEmpty)
                ? 'Nama siswa wajib diisi'
                : null,
          ),

          const SizedBox(height: 12),

          // Field 2: Kelas
          TextFormField(
            controller: _studentClassController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Kelas / Rombel',
              hintText: 'Contoh: XII MIPA 1',
              prefixIcon: const Icon(Icons.class_outlined,
                  color: AppColors.primaryGreen),
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
                borderSide:
                    const BorderSide(color: AppColors.primaryGreen, width: 1.8),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAF8),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            ),
            validator: (val) => (val == null || val.trim().isEmpty)
                ? 'Kelas wajib diisi'
                : null,
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
              prefixIcon: const Icon(Icons.account_balance_outlined,
                  color: AppColors.primaryGreen),
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
                borderSide:
                    const BorderSide(color: AppColors.primaryGreen, width: 1.8),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAF8),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            ),
            validator: (val) => (val == null || val.trim().isEmpty)
                ? 'Nama sekolah wajib diisi'
                : null,
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
                        Text('Menghubungkan...',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'Mulai Belajar E-Modul',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
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
}
