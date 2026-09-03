import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/core/widgets/ethno_card.dart';
import 'package:e_modul_etnosains/features/peta_konsep/data/models/microorganism_model.dart';
import 'microbe_details_panel.dart';
import 'microbe_selector_chips.dart';
import 'microscope_lens_visualizer.dart';

class VirtualMicroscopeSimulator extends StatefulWidget {
  final String selectedMicrobeId;
  final ValueChanged<String> onMicrobeChanged;

  const VirtualMicroscopeSimulator({
    super.key,
    required this.selectedMicrobeId,
    required this.onMicrobeChanged,
  });

  @override
  State<VirtualMicroscopeSimulator> createState() =>
      _VirtualMicroscopeSimulatorState();
}

class _VirtualMicroscopeSimulatorState
    extends State<VirtualMicroscopeSimulator> with SingleTickerProviderStateMixin {
  double _microscopeZoom = 100.0;
  bool _isDetailExpanded = false;
  bool _showReticle = true;
  bool _isIlluminated = true;

  late AnimationController _animController;
  Animation<double>? _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() {
        if (_zoomAnimation != null) {
          setState(() {
            _microscopeZoom = _zoomAnimation!.value;
          });
        }
      });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _animateToZoom(double targetZoom) {
    _zoomAnimation = Tween<double>(
      begin: _microscopeZoom,
      end: targetZoom.clamp(100.0, 1000.0),
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final activeMicrobe = MicroorganismData.microbes.firstWhere(
      (m) => m.id == widget.selectedMicrobeId,
      orElse: () => MicroorganismData.microbes.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Microbe selector chips
        MicrobeSelectorChips(
          selectedMicrobeId: widget.selectedMicrobeId,
          onSelected: (id) {
            widget.onMicrobeChanged(id);
          },
        ),

        const SizedBox(height: 12),

        // 2. Microscope Console Viewport Card
        EthnoCard(
          padding: const EdgeInsets.all(14),
          backgroundColor: const Color(0xFF0C1913),
          borderColor: AppColors.primaryLight.withValues(alpha: 0.6),
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              final isLandscape =
                  MediaQuery.of(context).orientation == Orientation.landscape;
              final availableWidth = constraints.maxWidth;
              final lensSize = isLandscape
                  ? 145.0
                  : (availableWidth * 0.68).clamp(235.0, 280.0);

              // Top Console Header Bar
              final consoleHeader = Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    // Status LED
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isIlluminated
                            ? const Color(0xFF4ADE80)
                            : Colors.grey,
                        boxShadow: [
                          if (_isIlluminated)
                            BoxShadow(
                              color: const Color(0xFF4ADE80)
                                  .withValues(alpha: 0.8),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'KONSOL LENSA MIKROSKOP',
                      style: TextStyle(
                        color: AppColors.sageLight,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),

                    // Reticle Toggle
                    _buildConsoleIconButton(
                      icon: _showReticle
                          ? Icons.grid_on_rounded
                          : Icons.grid_off_rounded,
                      tooltip: 'Grid Kalibrasi & Retikel',
                      isActive: _showReticle,
                      onPressed: () {
                        setState(() {
                          _showReticle = !_showReticle;
                        });
                      },
                    ),
                    const SizedBox(width: 4),

                    // Illumination Toggle
                    _buildConsoleIconButton(
                      icon: _isIlluminated
                          ? Icons.wb_sunny_rounded
                          : Icons.wb_sunny_outlined,
                      tooltip: 'Iluminasi Cahaya LED',
                      isActive: _isIlluminated,
                      onPressed: () {
                        setState(() {
                          _isIlluminated = !_isIlluminated;
                        });
                      },
                    ),
                    const SizedBox(width: 4),

                    // Reset Focus
                    _buildConsoleIconButton(
                      icon: Icons.refresh_rounded,
                      tooltip: 'Reset Perbesaran 100x',
                      isActive: _microscopeZoom == 100.0,
                      onPressed: () => _animateToZoom(100.0),
                    ),
                  ],
                ),
              );

              // Lens & Controls Section
              final lensSection = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MicroscopeLensVisualizer(
                    activeMicrobe: activeMicrobe,
                    zoom: _microscopeZoom,
                    lensSize: lensSize,
                    isLandscape: isLandscape,
                    showReticle: _showReticle,
                    isIlluminated: _isIlluminated,
                  ),
                  SizedBox(height: isLandscape ? 10 : 14),

                  // Turret Objective Quick Presets (40x, 100x, 400x, 1000x)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTurretPresetButton('40x (Scan)', 100.0),
                      const SizedBox(width: 6),
                      _buildTurretPresetButton('100x (Low)', 250.0),
                      const SizedBox(width: 6),
                      _buildTurretPresetButton('400x (High)', 600.0),
                      const SizedBox(width: 6),
                      _buildTurretPresetButton('1000x (Oil)', 1000.0),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Continuous Zoom Slider
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        // Zoom Out Fine Button
                        IconButton(
                          icon: const Icon(Icons.zoom_out_rounded,
                              color: Colors.white70, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                              minWidth: 28, minHeight: 28),
                          onPressed: () {
                            _animateToZoom(_microscopeZoom - 100);
                          },
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.primaryLight,
                              inactiveTrackColor: Colors.white24,
                              thumbColor: AppColors.goldenYellow,
                              overlayColor: AppColors.goldenYellow
                                  .withValues(alpha: 0.2),
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 7),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 14),
                              valueIndicatorTextStyle: const TextStyle(
                                color: Colors.black87,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: Slider(
                              value: _microscopeZoom,
                              min: 100.0,
                              max: 1000.0,
                              divisions: 18,
                              label: '${_microscopeZoom.toInt()}x',
                              onChanged: (v) {
                                setState(() {
                                  _microscopeZoom = v;
                                });
                              },
                            ),
                          ),
                        ),
                        // Zoom In Fine Button
                        IconButton(
                          icon: const Icon(Icons.zoom_in_rounded,
                              color: Colors.white70, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                              minWidth: 28, minHeight: 28),
                          onPressed: () {
                            _animateToZoom(_microscopeZoom + 100);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );

              // Details Panel
              final detailsSection = MicrobeDetailsPanel(
                activeMicrobe: activeMicrobe,
                isExpanded: _isDetailExpanded,
                isLandscape: isLandscape,
                onToggle: () {
                  setState(() {
                    _isDetailExpanded = !_isDetailExpanded;
                  });
                },
              );

              return Column(
                children: [
                  consoleHeader,
                  const SizedBox(height: 12),
                  if (isLandscape)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: lensSection),
                        const SizedBox(width: 14),
                        Expanded(flex: 6, child: detailsSection),
                      ],
                    )
                  else
                    Column(
                      children: [
                        lensSection,
                        const SizedBox(height: 12),
                        detailsSection,
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConsoleIconButton({
    required IconData icon,
    required String tooltip,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primaryGreen.withValues(alpha: 0.4)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isActive ? AppColors.primaryLight : Colors.transparent,
                width: 0.8,
              ),
            ),
            child: Icon(
              icon,
              size: 15,
              color: isActive ? AppColors.sageLight : Colors.white54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTurretPresetButton(String label, double zoomTarget) {
    final isSelected = (_microscopeZoom - zoomTarget).abs() < 50;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _animateToZoom(zoomTarget),
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryGreen
                  : Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryLight
                    : Colors.white12,
                width: isSelected ? 1.2 : 0.8,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColors.primaryLight.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
              ],
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 9.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
