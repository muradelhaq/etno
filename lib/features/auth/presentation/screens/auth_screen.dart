import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import '../widgets/auth_hero_branding_column.dart';
import '../widgets/auth_compact_header.dart';
import '../widgets/auth_cloud_status_badge.dart';
import '../widgets/auth_segmented_tab_bar.dart';
import '../widgets/student_login_form.dart';
import '../widgets/admin_login_form.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

          // 2. Ambient Glowing Orbs
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
                            const Expanded(child: AuthHeroBrandingColumn()),
                            const SizedBox(width: 48),
                            Expanded(child: _buildAuthCard()),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AuthCompactHeader(),
                            const SizedBox(height: 20),
                            _buildAuthCard(),
                            const SizedBox(height: 16),
                            const AuthCloudStatusBadge(),
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
          AuthSegmentedTabBar(
            tabController: _tabController,
            onTabChanged: (index) {
              setState(() {
                _tabController.animateTo(index);
              });
            },
          ),
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              return _tabController.index == 0
                  ? const StudentLoginForm()
                  : const AdminLoginForm();
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
  }
}
