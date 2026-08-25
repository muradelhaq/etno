import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:e_modul_etnosains/features/auth/presentation/screens/auth_screen.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';

void main() {
  testWidgets('AuthScreen render and student tab test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = await SharedPreferences.getInstance();

    final router = GoRouter(
      initialLocation: '/auth',
      routes: [
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) =>
              const Scaffold(body: Text('Home Screen')),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) =>
              const Scaffold(body: Text('Admin Screen')),
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

    // Verify initial render
    expect(find.byType(AuthScreen), findsOneWidget);
    expect(find.text('Masuk Siswa'), findsOneWidget);
    expect(find.text('Akses Guru / Admin'), findsOneWidget);

    // Switch to Guru tab
    await tester.tap(find.text('Akses Guru / Admin'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Masuk menggunakan akun guru'), findsOneWidget);
    expect(find.text('Masuk ke Dashboard Guru'), findsOneWidget);

    // Both credentials are required.
    await tester.tap(find.text('Masuk ke Dashboard Guru'));
    await tester.pumpAndSettle();

    expect(find.text('Email guru wajib diisi'), findsOneWidget);
    expect(find.text('Kata sandi wajib diisi'), findsOneWidget);

    // Reject malformed email before any network request is made.
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'bukan-email');
    await tester.enterText(fields.at(1), 'rahasia');
    await tester.tap(find.text('Masuk ke Dashboard Guru'));
    await tester.pumpAndSettle();

    expect(find.text('Format email tidak valid'), findsOneWidget);
  });
}
