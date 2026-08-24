import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:e_modul_etnosains/features/auth/presentation/screens/auth_screen.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';

void main() {
  testWidgets('AuthScreen render and student tab test', (WidgetTester tester) async {
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
          builder: (context, state) => const Scaffold(body: Text('Home Screen')),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const Scaffold(body: Text('Admin Screen')),
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

    expect(find.textContaining('Portal khusus Guru'), findsOneWidget);
    expect(find.text('Buka Dashboard Guru / Admin'), findsOneWidget);

    // Test submit with empty PIN
    await tester.tap(find.text('Buka Dashboard Guru / Admin'));
    await tester.pumpAndSettle();

    expect(find.text('PIN Admin wajib diisi'), findsOneWidget);

    // Test enter wrong PIN
    final pinField = find.byType(TextFormField);
    await tester.enterText(pinField, '999999');
    await tester.tap(find.text('Buka Dashboard Guru / Admin'));
    await tester.pumpAndSettle();

    expect(find.textContaining('PIN / Kata Sandi Guru Salah!'), findsOneWidget);

    // Test enter correct PIN
    await tester.enterText(pinField, '123456');
    await tester.tap(find.text('Buka Dashboard Guru / Admin'));
    await tester.pumpAndSettle();

    expect(find.text('Admin Screen'), findsOneWidget);
  });
}
