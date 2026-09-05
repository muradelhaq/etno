import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_modul_etnosains/features/cover/presentation/widgets/dialogs/cover_media_dialogs.dart';

void main() {
  testWidgets('showVideoPengantarDialog renders without overflow in landscape',
      (WidgetTester tester) async {
    // Landscape mobile resolution: 800 x 380
    tester.view.physicalSize = const Size(800, 380);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () =>
                    CoverMediaDialogs.showVideoPengantarDialog(ctx),
                child: const Text('Buka Dialog'),
              ),
            ),
          ),
        ),
      ),
    );

    // Open dialog
    await tester.tap(find.text('Buka Dialog'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify dialog content is present and rendered
    expect(find.text('Pengantar E-Modul'), findsOneWidget);
    expect(find.text('Selamat Datang di E-Modul Etnosains Fermentasi!'),
        findsOneWidget);
    expect(find.text('Di Browser'), findsOneWidget);
    expect(find.text('Mulai Bab 1'), findsOneWidget);

    // Close dialog
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Pengantar E-Modul'), findsNothing);
  });
}
