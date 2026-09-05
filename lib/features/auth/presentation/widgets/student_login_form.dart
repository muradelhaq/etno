import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/services/supabase_service.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';

class StudentLoginForm extends ConsumerStatefulWidget {
  final bool isLandscape;

  const StudentLoginForm({super.key, this.isLandscape = false});

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
    final landscapeMode = widget.isLandscape ||
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Form(
      key: _studentFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(landscapeMode ? 4 : 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.badge_outlined,
                    size: landscapeMode ? 14 : 16,
                    color: AppColors.primaryGreen),
              ),
              const SizedBox(width: 8),
              Text(
                'Identitas Belajar Siswa',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: landscapeMode ? 12 : 13,
                  color: const Color(0xFF1E3A2B),
                ),
              ),
            ],
          ),
          SizedBox(height: landscapeMode ? 8 : 14),

          // Field 1: Nama Lengkap
          _buildNameField(compact: landscapeMode),

          SizedBox(height: landscapeMode ? 8 : 12),

          // In landscape: Kelas & Asal Sekolah in a clean side-by-side Row
          if (landscapeMode)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildClassField(compact: true)),
                const SizedBox(width: 10),
                Expanded(child: _buildSchoolField(compact: true)),
              ],
            )
          else ...[
            _buildClassField(compact: false),
            const SizedBox(height: 12),
            _buildSchoolField(compact: false),
          ],

          SizedBox(height: landscapeMode ? 14 : 20),

          // Submit Button
          SizedBox(
            height: landscapeMode ? 44 : 48,
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
                                fontWeight: FontWeight.bold, fontSize: 13.5),
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

  Widget _buildNameField({required bool compact}) {
    return TextFormField(
      controller: _studentNameController,
      textInputAction: TextInputAction.next,
      style: TextStyle(fontSize: compact ? 13 : 14),
      decoration: InputDecoration(
        labelText: 'Nama Lengkap Siswa',
        hintText: 'Contoh: Dewi Sartika',
        prefixIcon: Icon(Icons.person_outline_rounded,
            size: compact ? 20 : 24, color: AppColors.primaryGreen),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primaryGreen, width: 1.8),
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAF8),
        isDense: compact,
        contentPadding: EdgeInsets.symmetric(
            horizontal: 14, vertical: compact ? 10 : 13),
      ),
      validator: (val) => (val == null || val.trim().isEmpty)
          ? 'Nama siswa wajib diisi'
          : null,
    );
  }

  Widget _buildClassField({required bool compact}) {
    return TextFormField(
      controller: _studentClassController,
      textInputAction: TextInputAction.next,
      style: TextStyle(fontSize: compact ? 13 : 14),
      decoration: InputDecoration(
        labelText: 'Kelas / Rombel',
        hintText: 'Contoh: XII MIPA 1',
        prefixIcon: Icon(Icons.class_outlined,
            size: compact ? 20 : 24, color: AppColors.primaryGreen),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primaryGreen, width: 1.8),
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAF8),
        isDense: compact,
        contentPadding: EdgeInsets.symmetric(
            horizontal: 14, vertical: compact ? 10 : 13),
      ),
      validator: (val) =>
          (val == null || val.trim().isEmpty) ? 'Kelas wajib diisi' : null,
    );
  }

  Widget _buildSchoolField({required bool compact}) {
    return TextFormField(
      controller: _studentSchoolController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleStudentSubmit(),
      style: TextStyle(fontSize: compact ? 13 : 14),
      decoration: InputDecoration(
        labelText: 'Asal Sekolah',
        hintText: 'Contoh: SMAN 1 Bandung',
        prefixIcon: Icon(Icons.account_balance_outlined,
            size: compact ? 20 : 24, color: AppColors.primaryGreen),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primaryGreen, width: 1.8),
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAF8),
        isDense: compact,
        contentPadding: EdgeInsets.symmetric(
            horizontal: 14, vertical: compact ? 10 : 13),
      ),
      validator: (val) =>
          (val == null || val.trim().isEmpty) ? 'Sekolah wajib diisi' : null,
    );
  }
}
