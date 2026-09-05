import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/services/supabase_service.dart';

class AdminLoginForm extends StatefulWidget {
  final bool isLandscape;

  const AdminLoginForm({super.key, this.isLandscape = false});

  @override
  State<AdminLoginForm> createState() => _AdminLoginFormState();
}

class _AdminLoginFormState extends State<AdminLoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await SupabaseService.signInAdmin(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (!mounted) return;
      context.go('/admin');
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_friendlyMessage(error)),
          backgroundColor: AppColors.errorRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyMessage(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('invalid login credentials')) {
      return 'Email atau kata sandi guru salah.';
    }
    if (message.contains('tidak memiliki akses')) {
      return 'Akun ini tidak memiliki akses guru/admin.';
    }
    return 'Login guru gagal. Periksa koneksi dan coba lagi.';
  }

  @override
  Widget build(BuildContext context) {
    final landscapeMode = widget.isLandscape ||
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(landscapeMode ? 8 : 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.admin_panel_settings_rounded,
                    color: const Color(0xFFD97706),
                    size: landscapeMode ? 16 : 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Masuk menggunakan akun guru yang telah terdaftar dengan hak akses admin.',
                    style: TextStyle(
                      fontSize: landscapeMode ? 10.5 : 11.5,
                      color: const Color(0xFF78350F),
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: landscapeMode ? 8 : 16),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            style: TextStyle(fontSize: landscapeMode ? 13 : 14),
            decoration: _decoration(
              label: 'Email Guru',
              hint: 'guru@sekolah.id',
              icon: Icons.email_outlined,
              compact: landscapeMode,
            ),
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) return 'Email guru wajib diisi';
              if (!email.contains('@')) return 'Format email tidak valid';
              return null;
            },
          ),
          SizedBox(height: landscapeMode ? 8 : 12),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleSubmit(),
            style: TextStyle(fontSize: landscapeMode ? 13 : 14),
            decoration: _decoration(
              label: 'Kata Sandi',
              hint: 'Masukkan kata sandi akun guru',
              icon: Icons.lock_outline_rounded,
              compact: landscapeMode,
            ).copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  size: landscapeMode ? 18 : 20,
                ),
                onPressed: () => setState(
                  () => _obscurePassword = !_obscurePassword,
                ),
              ),
            ),
            validator: (value) => (value == null || value.isEmpty)
                ? 'Kata sandi wajib diisi'
                : null,
          ),
          SizedBox(height: landscapeMode ? 12 : 20),
          SizedBox(
            height: landscapeMode ? 44 : 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Masuk ke Dashboard Guru',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: landscapeMode ? 13.5 : 14),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration({
    required String label,
    required String hint,
    required IconData icon,
    bool compact = false,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon,
          color: AppColors.primaryDark, size: compact ? 20 : 24),
      isDense: compact,
      contentPadding: EdgeInsets.symmetric(
          horizontal: 14, vertical: compact ? 10 : 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD6E6D6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.8),
      ),
      filled: true,
      fillColor: const Color(0xFFF9FAF8),
    );
  }
}
