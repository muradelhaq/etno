import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:e_modul_etnosains/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';

void main() {
  testWidgets('AdminDashboardScreen render and tab navigation test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = await SharedPreferences.getInstance();

    final router = GoRouter(
      initialLocation: '/admin',
      routes: [
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('Home Screen')),
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => const Scaffold(body: Text('Auth Screen')),
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

    // Initial pump and wait for future data loading
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Verify AppBar and Tabs
    expect(find.byType(AdminDashboardScreen), findsOneWidget);
    expect(find.text('Dashboard Guru & Evaluasi Etnosains'), findsOneWidget);
    expect(find.text('Statistik Kelas'), findsOneWidget);
    expect(find.text('Data Siswa'), findsOneWidget);
    expect(find.text('Koleksi Jawaban'), findsOneWidget);

    // Switch to Tab 2: Data Siswa
    await tester.tap(find.text('Data Siswa'));
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.textContaining('siswa'), findsWidgets);

    // Switch to Tab 3: Koleksi Jawaban
    await tester.tap(find.text('Koleksi Jawaban'));
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.textContaining('jawaban studi kasus'), findsWidgets);
  });
}
