import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../theme/text_styles.dart';
import '../providers/landscape_nav_provider.dart';
import 'app_drawer.dart';
import 'custom_app_bar.dart';
import 'module_nav_bar.dart';

class EthnoScaffold extends ConsumerWidget {
  final Widget body;
  final String? title;
  final String? subtitle;
  final bool showBackButton;
  final List<Widget>? actions;
  final PreferredSizeWidget? customAppBar;
  final int? currentSlide;
  final int totalSlides;
  final String? prevRoute;
  final String? nextRoute;
  final VoidCallback? onNext;
  final VoidCallback? onPrev;
  final Widget? customBottomBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;

  const EthnoScaffold({
    super.key,
    required this.body,
    this.title,
    this.subtitle,
    this.showBackButton = true,
    this.actions,
    this.customAppBar,
    this.currentSlide,
    this.totalSlides = 12,
    this.prevRoute,
    this.nextRoute,
    this.onNext,
    this.onPrev,
    this.customBottomBar,
    this.drawer = const AppDrawer(),
    this.floatingActionButton,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isNavVisible = ref.watch(landscapeNavVisibleProvider);

    // Determine if AppBar & BottomBar should be visible
    final showBars = !isLandscape || isNavVisible;

    PreferredSizeWidget? effectiveAppBar;
    if (showBars) {
      if (customAppBar != null) {
        effectiveAppBar = customAppBar;
      } else if (title != null) {
        effectiveAppBar = CustomAppBar(
          title: title!,
          subtitle: subtitle,
          showBackButton: showBackButton,
          actions: actions,
        );
      }
    }

    Widget? effectiveBottomBar;
    if (showBars) {
      if (customBottomBar != null) {
        effectiveBottomBar = customBottomBar;
      } else if (currentSlide != null) {
        effectiveBottomBar = ModuleNavBar(
          currentSlide: currentSlide!,
          totalSlides: totalSlides,
          prevRoute: prevRoute,
          nextRoute: nextRoute,
          onNext: onNext,
          onPrev: onPrev,
        );
      }
    }

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.background,
      drawer: drawer,
      appBar: effectiveAppBar,
      bottomNavigationBar: effectiveBottomBar,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: isLandscape
            ? () {
                ref.read(landscapeNavVisibleProvider.notifier).state =
                    !isNavVisible;
              }
            : null,
        child: Stack(
          children: [
            Positioned.fill(child: body),

            // Floating Navigation Cue in Landscape when hidden
            if (isLandscape && !isNavVisible && currentSlide != null)
              Positioned(
                bottom: 12,
                right: 16,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      ref.read(landscapeNavVisibleProvider.notifier).state =
                          true;
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.touch_app_rounded,
                            color: AppColors.goldenYellow,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Slide $currentSlide/$totalSlides • Ketuk Navigasi',
                            style: AppTextStyles.tagText.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
