import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../theme/text_styles.dart';
import '../providers/landscape_nav_provider.dart';
import '../../shared/services/local_storage_service.dart';
import 'app_drawer.dart';
import 'custom_app_bar.dart';
import 'module_nav_bar.dart';

class EthnoScaffold extends ConsumerStatefulWidget {
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
    this.totalSlides = 13,
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
  ConsumerState<EthnoScaffold> createState() => _EthnoScaffoldState();
}

class _EthnoScaffoldState extends ConsumerState<EthnoScaffold> {
  bool _markingRead = false;

  bool _onScrollNotification(ScrollNotification notification) {
    if (widget.currentSlide == null ||
        notification.metrics.axis != Axis.vertical) {
      return false;
    }
    if (notification.metrics.extentAfter <= 8) _markCurrentSlideRead();
    return false;
  }

  bool _onMetricsNotification(ScrollMetricsNotification notification) {
    if (widget.currentSlide != null &&
        notification.metrics.axis == Axis.vertical &&
        notification.metrics.maxScrollExtent <= 8) {
      _markCurrentSlideRead();
    }
    return false;
  }

  Future<void> _markCurrentSlideRead() async {
    final slide = widget.currentSlide;
    if (slide == null || _markingRead) return;
    if (ref.read(userProgressProvider).readSlides.contains(slide)) return;
    _markingRead = true;
    await ref.read(userProgressProvider.notifier).markSlideRead(slide);
    _markingRead = false;
  }

  void _handleNext() {
    final slide = widget.currentSlide;
    final progress = ref.read(userProgressProvider);
    if (slide != null && !progress.canProceedFromSlide(slide)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(progress.requirementForSlide(slide)),
          backgroundColor: AppColors.warmTerracotta,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (widget.onNext != null) {
      widget.onNext!();
    } else if (widget.nextRoute != null) {
      context.go(widget.nextRoute!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If student is not registered, redirect immediately to /auth
    final userProgress = ref.watch(userProgressProvider);
    if (!userProgress.isRegistered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go('/auth');
        }
      });
    }

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isNavVisible = ref.watch(landscapeNavVisibleProvider);
    final hideBars = isLandscape && !isNavVisible;

    // Resolve AppBar widget
    PreferredSizeWidget? effectiveAppBar;
    if (widget.customAppBar != null) {
      effectiveAppBar = widget.customAppBar;
    } else if (widget.title != null) {
      effectiveAppBar = CustomAppBar(
        title: widget.title!,
        subtitle: widget.subtitle,
        showBackButton: widget.showBackButton,
        actions: widget.actions,
      );
    }

    // Resolve BottomBar widget
    Widget? effectiveBottomBar;
    if (widget.customBottomBar != null) {
      effectiveBottomBar = widget.customBottomBar;
    } else if (widget.currentSlide != null) {
      effectiveBottomBar = ModuleNavBar(
        currentSlide: widget.currentSlide!,
        totalSlides: widget.totalSlides,
        prevRoute: widget.prevRoute,
        nextRoute: widget.nextRoute,
        onNext: _handleNext,
        onPrev: widget.onPrev,
      );
    }

    final effectiveBody = NotificationListener<ScrollMetricsNotification>(
      onNotification: _onMetricsNotification,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: widget.body,
      ),
    );

    // In Portrait mode: standard Scaffold layout
    if (!isLandscape) {
      return Scaffold(
        backgroundColor: widget.backgroundColor ?? AppColors.background,
        drawer: widget.drawer,
        appBar: effectiveAppBar,
        bottomNavigationBar: effectiveBottomBar,
        floatingActionButton: widget.floatingActionButton,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        body: effectiveBody,
      );
    }

    // In Landscape mode: full-bleed body with smoothly animated top & bottom bars
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? AppColors.background,
      drawer: widget.drawer,
      floatingActionButton: widget.floatingActionButton,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          ref.read(landscapeNavVisibleProvider.notifier).state = !isNavVisible;
        },
        child: Stack(
          children: [
            // Full-screen content
            Positioned.fill(child: effectiveBody),

            // Top Header: Smooth Slide Up/Down & Fade
            if (effectiveAppBar != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedSlide(
                  offset: hideBars ? const Offset(0, -1.15) : Offset.zero,
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeInOutCubic,
                  child: AnimatedOpacity(
                    opacity: hideBars ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: IgnorePointer(
                      ignoring: hideBars,
                      child: Material(
                        color: Colors.transparent,
                        elevation: 0.5,
                        child: effectiveAppBar,
                      ),
                    ),
                  ),
                ),
              ),

            // Bottom Navigation Bar: Smooth Slide Down/Up & Fade
            if (effectiveBottomBar != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: AnimatedSlide(
                  offset: hideBars ? const Offset(0, 1.15) : Offset.zero,
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeInOutCubic,
                  child: AnimatedOpacity(
                    opacity: hideBars ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: IgnorePointer(
                      ignoring: hideBars,
                      child: effectiveBottomBar,
                    ),
                  ),
                ),
              ),

            // Floating Navigation Cue in Landscape when hidden
            if (widget.currentSlide != null)
              Positioned(
                bottom: 12,
                right: 16,
                child: AnimatedSlide(
                  offset: hideBars ? Offset.zero : const Offset(0, 1.6),
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeInOutCubic,
                  child: AnimatedOpacity(
                    opacity: hideBars ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: IgnorePointer(
                      ignoring: !hideBars,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ref
                                .read(landscapeNavVisibleProvider.notifier)
                                .state = true;
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryDark.withValues(alpha: 0.88),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 8,
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
                                  'Slide ${widget.currentSlide}/${widget.totalSlides} • Ketuk Navigasi',
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
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
