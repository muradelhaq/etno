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
}
