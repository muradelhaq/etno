import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import '../widgets/auth_hero_branding_column.dart';
import '../widgets/auth_landscape_branding.dart';
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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isDesktop = size.width >= 900;
    final useDualPane = isLandscape || isDesktop;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                physics: const ClampingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop
                      ? 48
                      : (isLandscape ? 24 : 20),
                  vertical: isLandscape ? 12 : 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isDesktop ? 960 : (isLandscape ? 840 : 480),
                  ),
                  child: useDualPane
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: isDesktop ? 5 : 4,
                              child: (isDesktop && size.height >= 550)
                                  ? const AuthHeroBrandingColumn()
                                  : const AuthLandscapeBranding(),
                            ),
                            SizedBox(width: isDesktop ? 48 : 24),
                            Expanded(
                              flex: isDesktop ? 5 : 6,
                              child: _buildAuthCard(isLandscape: true),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AuthCompactHeader(),
                            const SizedBox(height: 20),
                            _buildAuthCard(isLandscape: false),
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

  Widget _buildAuthCard({bool isLandscape = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isLandscape ? 18 : 24),
        border: Border.all(color: const Color(0xFFE2EBE2), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A2B).withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(isLandscape ? 16 : 22),
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
          SizedBox(height: isLandscape ? 12 : 20),
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              return _tabController.index == 0
                  ? StudentLoginForm(isLandscape: isLandscape)
                  : AdminLoginForm(isLandscape: isLandscape);
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
  }
}
