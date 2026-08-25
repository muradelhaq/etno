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
    extends State<VirtualMicroscopeSimulator> {
  double _microscopeZoom = 100.0;
  bool _isDetailExpanded = false;

  @override
  Widget build(BuildContext context) {
    final activeMicrobe = MicroorganismData.microbes.firstWhere(
      (m) => m.id == widget.selectedMicrobeId,
      orElse: () => MicroorganismData.microbes.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Microbe selector tabs
        MicrobeSelectorChips(
          selectedMicrobeId: widget.selectedMicrobeId,
          onSelected: widget.onMicrobeChanged,
        ),

        const SizedBox(height: 14),

        // Microscope Viewport Card
        EthnoCard(
          padding: const EdgeInsets.all(16),
          backgroundColor: const Color(0xFF14241D),
          borderColor: AppColors.primaryLight,
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              final isLandscape =
                  MediaQuery.of(context).orientation == Orientation.landscape;
              final lensSize = isLandscape ? 125.0 : 170.0;

              final lensSection = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MicroscopeLensVisualizer(
                    activeMicrobe: activeMicrobe,
                    zoom: _microscopeZoom,
                    lensSize: lensSize,
                    isLandscape: isLandscape,
                  ),
                  SizedBox(height: isLandscape ? 8 : 12),
                  Row(
                    children: [
                      const Text('100x',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 10)),
                      Expanded(
                        child: Slider(
                          value: _microscopeZoom,
                          min: 100.0,
                          max: 1000.0,
                          divisions: 9,
                          activeColor: AppColors.primaryLight,
                          inactiveColor: Colors.white24,
                          label: '${_microscopeZoom.toInt()}x',
                          onChanged: (v) {
                            setState(() {
                              _microscopeZoom = v;
                            });
                          },
                        ),
                      ),
                      const Text('1000x',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 10)),
                    ],
                  ),
                ],
              );

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

              if (isLandscape) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: lensSection),
                    const SizedBox(width: 14),
                    Expanded(flex: 6, child: detailsSection),
                  ],
                );
              } else {
                return Column(
                  children: [
                    lensSection,
                    const SizedBox(height: 10),
                    detailsSection,
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
