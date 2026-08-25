import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'core/services/supabase_service.dart';
import 'shared/services/local_storage_service.dart';
import 'shared/services/offline_sync_queue.dart';
import 'shared/services/student_session_store.dart';

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
    OfflineSyncQueue.initialize(sharedPrefs);
    StudentSessionStore.initialize(sharedPrefs);
  } catch (_) {}

  // Initialize Supabase backend
  try {
    await SupabaseService.initialize();
  } catch (_) {}

  // Upgrade legacy local student profiles to an owned anonymous Auth session.
  if (sharedPrefs != null && !SupabaseService.isCurrentUserAdmin) {
    try {
      final storage = LocalStorageService(sharedPrefs);
      final progress = storage.loadUserProgress();
      if (progress.isRegistered) {
        final student = await SupabaseService.registerOrLoginStudent(
          name: progress.studentName,
          className: progress.studentClass,
          school: progress.studentSchool,
        );
        final studentId = student?['id']?.toString();
        if (studentId != null && studentId != progress.studentId) {
          await storage.saveUserProgress(
            progress.copyWith(studentId: studentId),
          );
        }
      }
    } catch (_) {}
  }

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
