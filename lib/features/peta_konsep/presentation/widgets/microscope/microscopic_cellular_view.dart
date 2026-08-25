import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/core/constants/app_colors.dart';
import 'package:e_modul_etnosains/features/peta_konsep/data/models/microorganism_model.dart';

class MicroscopicCellularView extends StatelessWidget {
  final MicroorganismModel microbe;
  final double zoom;

  const MicroscopicCellularView({
    super.key,
    required this.microbe,
    required this.zoom,
  });

  @override
  Widget build(BuildContext context) {
    if (microbe.id == 'rhizopus') {
      // Tempe: Rhizopus mycelium network with sporangium heads
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSporangium(),
              const SizedBox(width: 16),
              _buildSporangium(),
            ],
          ),
          Container(
            width: 120,
            height: 3,
            color: const Color(0xFFCDEAC0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(width: 2, height: 25, color: const Color(0xFFCDEAC0)),
              Container(width: 2, height: 35, color: const Color(0xFFCDEAC0)),
              Container(width: 2, height: 22, color: const Color(0xFFCDEAC0)),
            ],
          ),
        ],
      );
    } else if (microbe.id == 'saccharomyces') {
      // Tape: Budding Yeast cells (Saccharomyces cerevisiae)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildYeastCell(radius: 20, hasBud: true),
          const SizedBox(width: 12),
          _buildYeastCell(radius: 16, hasBud: false),
          const SizedBox(width: 8),
          _buildYeastCell(radius: 18, hasBud: true),
        ],
      );
    } else if (microbe.id == 'aspergillus_sp' || microbe.id == 'aspergillus_oryzae') {
      // Koji / Amylase: Conidiophore stalk with radiating conidiospores
      final isKoji = microbe.id == 'aspergillus_oryzae';
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildConidialHead(isKoji: isKoji),
          Container(
            width: 3.5,
            height: 32,
            color: isKoji ? const Color(0xFFD4E09B) : const Color(0xFFE0E0E0),
          ),
        ],
      );
    } else if (microbe.id == 'tetragenococcus') {
      // Halophilic bacteria: Tetrad clusters (groups of 4 spherical cocci)
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          _buildTetradGroup(),
          _buildTetradGroup(),
          _buildTetradGroup(),
        ],
      );
    } else if (microbe.id == 'neurospora') {
      // Oncom: Coral-orange macroconidia chains on branching hyphae
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOrangeSporeChain(),
              const SizedBox(width: 14),
              _buildOrangeSporeChain(),
            ],
          ),
          Container(width: 100, height: 3, color: const Color(0xFFFFB703)),
        ],
      );
    } else {
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: List.generate(
          6,
          (i) => Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: AppColors.goldenYellow,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildSporangium() {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF2E1C11),
            border: Border.fromBorderSide(BorderSide(color: AppColors.sageLight, width: 1.5)),
          ),
          child: const Center(
            child: Icon(Icons.grain, color: AppColors.goldenYellow, size: 14),
          ),
        ),
        Container(
          width: 3,
          height: 20,
          color: const Color(0xFFCDEAC0),
        ),
      ],
    );
  }

  Widget _buildYeastCell({required double radius, required bool hasBud}) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            color: const Color(0xFF6B9080),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white70, width: 1.5),
          ),
          child: const Center(
            child: Icon(Icons.circle, color: Colors.white38, size: 8),
          ),
        ),
        if (hasBud)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: radius * 0.9,
              height: radius * 0.9,
              decoration: BoxDecoration(
                color: const Color(0xFFA4C3B2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildConidialHead({required bool isKoji}) {
    final headColor = isKoji ? const Color(0xFF8DAA51) : const Color(0xFF708D81);
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: headColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white70, width: 1.2),
          ),
        ),
        const Icon(Icons.flare_rounded, color: AppColors.goldenYellow, size: 24),
      ],
    );
  }

  Widget _buildTetradGroup() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Wrap(
        spacing: 2,
        runSpacing: 2,
        alignment: WrapAlignment.center,
        children: List.generate(
          4,
          (i) => Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFF5390D9),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrangeSporeChain() {
    return Column(
      children: List.generate(
        3,
        (i) => Container(
          width: 12,
          height: 10,
          margin: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFFB8500),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white60, width: 0.8),
          ),
        ),
      ),
    );
  }
}
