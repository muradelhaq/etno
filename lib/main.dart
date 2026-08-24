import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'core/services/supabase_service.dart';
import 'shared/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations & status bar style
  try {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } catch (_) {}

  try {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  } catch (_) {}

  // Initialize Indonesian date formatting
  try {
    await initializeDateFormatting('id_ID', null);
  } catch (_) {}

  // Initialize local storage persistence
  SharedPreferences? sharedPrefs;
  try {
    sharedPrefs = await SharedPreferences.getInstance();
  } catch (_) {}

  // Initialize Supabase backend
  try {
    await SupabaseService.initialize();
  } catch (_) {}

  runApp(
    ProviderScope(
      overrides: [
        if (sharedPrefs != null)
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      ],
      child: const EModulApp(),
    ),
  );
}
