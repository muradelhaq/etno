import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashPillarsWrap extends StatelessWidget {
  const SplashPillarsWrap({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 6,
      children: [
        _buildPill('🌿 Tempe Kedelai'),
        _buildPill('🍚 Tape Singkong & Ketan'),
        _buildPill('🫘 Tauco Manis'),
        _buildPill('🫙 Kecap Tradisional'),
        _buildPill('🍄 Oncom Merah'),
      ],
    ).animate().fadeIn(delay: 550.ms, duration: 500.ms);
  }

  Widget _buildPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFFEFAE0),
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
