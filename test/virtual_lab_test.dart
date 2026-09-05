import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:e_modul_etnosains/features/virtual_lab/presentation/screens/virtual_lab_screen.dart';
import 'package:e_modul_etnosains/shared/models/user_progress_model.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';

void main() {
  testWidgets('VirtualLabScreen render test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final initialProgress = UserProgressModel(
      studentId: 'test-student-1',
      studentName: 'Dewi Sartika',
      studentClass: 'XII MIPA 1',
      studentSchool: 'SMAN 1 Bandung',
    );

    SharedPreferences.setMockInitialValues({
      'user_progress_data_v1': initialProgress.toJson(),
    });
    final sharedPrefs = await SharedPreferences.getInstance();

    final router = GoRouter(
      initialLocation: '/virtual-lab',
      routes: [
        GoRoute(
          path: '/virtual-lab',
          builder: (context, state) => const VirtualLabScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(VirtualLabScreen), findsOneWidget);
    expect(find.textContaining('Simulasi'), findsWidgets);
    expect(find.text('Simpan & Rekam Uji Lab ke Portofolio'), findsOneWidget);

    // Test tap save lab record button
    await tester.tap(find.text('Simpan & Rekam Uji Lab ke Portofolio'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Hasil uji lab'), findsOneWidget);
  });

  testWidgets('VirtualLabScreen landscape and game tab interaction test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final initialProgress = UserProgressModel(
      studentId: 'test-student-1',
      studentName: 'Dewi Sartika',
      studentClass: 'XII MIPA 1',
      studentSchool: 'SMAN 1 Bandung',
    );

    SharedPreferences.setMockInitialValues({
      'user_progress_data_v1': initialProgress.toJson(),
    });
    final sharedPrefs = await SharedPreferences.getInstance();

    final router = GoRouter(
      initialLocation: '/virtual-lab',
      routes: [
        GoRoute(
          path: '/virtual-lab',
          builder: (context, state) => const VirtualLabScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify dual-column landscape layout elements rendered
    expect(find.text('Pengaturan Variabel Eksperimen'), findsOneWidget);
    expect(find.text('DIGITAL GLUCOMETER PRO'), findsOneWidget);

    // Switch to Game Misi Sains tab via the reminder button inside the simulator tab
    await tester.tap(find.text('Buka Game Misi Sains'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Verify game tab elements
    expect(find.text('Game Interaktif Misi Sains'), findsOneWidget);
    expect(find.text('Pasangkan Mikroba dengan Produk Fermentasi'),
        findsOneWidget);
    expect(find.text('Tebak Gambar Mikroskop Mikroorganisme'),
        findsOneWidget);
    expect(find.textContaining('0 XP'), findsWidgets);

    // Test answering a Misi 1 question: tap 'Tempe Kedelai'
    final tempeOption = find.text('Tempe Kedelai').first;
    await tester.tap(tempeOption);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify score increases by 30 XP
    expect(find.text('30 XP'), findsWidgets);
    expect(find.text('Tepat!'), findsOneWidget);
  });
}
