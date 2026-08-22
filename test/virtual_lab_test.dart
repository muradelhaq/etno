import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:e_modul_etnosains/features/virtual_lab/presentation/screens/virtual_lab_screen.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';

void main() {
  testWidgets('VirtualLabScreen render test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPrefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        ],
        child: const MaterialApp(
          home: VirtualLabScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Virtual Lab & Game Interaktif'), findsOneWidget);
    expect(find.text('DIGITAL GLUCOMETER PRO'), findsOneWidget);
  });
}

