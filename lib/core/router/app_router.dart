import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/cover/presentation/screens/cover_screen.dart';
import '../../features/apersepsi/presentation/screens/apersepsi_screen.dart';
import '../../features/peta_konsep/presentation/screens/peta_konsep_screen.dart';
import '../../features/produk_fermentasi/presentation/screens/food_detail_screen.dart';
import '../../features/jelajah_budaya/presentation/screens/jelajah_budaya_screen.dart';
import '../../features/virtual_lab/presentation/screens/virtual_lab_screen.dart';
import '../../features/challenge_proyek/presentation/screens/challenge_screen.dart';
import '../../features/evaluasi_kearifan/presentation/screens/cultural_assessment_screen.dart';
import '../../features/inovasi_makanan/presentation/screens/food_innovation_screen.dart';
import '../../features/literasi_sains/presentation/screens/pisa_quiz_screen.dart';
import '../../features/sertifikat/presentation/screens/certificate_view_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const CoverScreen(),
    ),
    GoRoute(
      path: '/cover',
      builder: (context, state) => const CoverScreen(),
    ),
    GoRoute(
      path: '/apersepsi',
      builder: (context, state) => const ApersepsiScreen(),
    ),
    GoRoute(
      path: '/peta-konsep',
      builder: (context, state) => const PetaKonsepScreen(),
    ),
    GoRoute(
      path: '/produk/:foodId',
      builder: (context, state) {
        final foodId = state.pathParameters['foodId'] ?? 'tempe';
        return FoodDetailScreen(foodId: foodId);
      },
    ),
    GoRoute(
      path: '/jelajah-budaya',
      builder: (context, state) => const JelajahBudayaScreen(),
    ),
    GoRoute(
      path: '/virtual-lab',
      builder: (context, state) => const VirtualLabScreen(),
    ),
    GoRoute(
      path: '/challenge-proyek',
      builder: (context, state) => const ChallengeScreen(),
    ),
    GoRoute(
      path: '/evaluasi-kearifan',
      builder: (context, state) => const CulturalAssessmentScreen(),
    ),
    GoRoute(
      path: '/inovasi-pangan',
      builder: (context, state) => const FoodInnovationScreen(),
    ),
    GoRoute(
      path: '/literasi-sains-quiz',
      builder: (context, state) => const PisaQuizScreen(),
    ),
    GoRoute(
      path: '/sertifikat',
      builder: (context, state) => const CertificateViewScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text('Halaman tidak ditemukan: ${state.uri}'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Kembali ke Beranda'),
          ),
        ],
      ),
    ),
  ),
);
