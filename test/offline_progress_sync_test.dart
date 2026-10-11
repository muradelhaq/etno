import 'package:e_modul_etnosains/shared/models/user_progress_model.dart';
import 'package:e_modul_etnosains/shared/services/local_storage_service.dart';
import 'package:e_modul_etnosains/shared/services/offline_sync_queue.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('offline student progress is queued and survives restarting storage',
      () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    OfflineSyncQueue.initialize(preferences);
    final storage = LocalStorageService(preferences);
    await storage.saveUserProgress(UserProgressModel(
      studentId: 'local-offline-student',
      studentName: 'Siswa Uji',
      studentClass: 'X',
      studentSchool: 'Sekolah Uji',
    ));
    final notifier = UserProgressNotifier(storage);
    addTearDown(notifier.dispose);

    await notifier.addXP(25);
    await notifier.markSlideRead(4);
    await notifier.addXP(10);

    OfflineSyncQueue.initialize(await SharedPreferences.getInstance());
    expect(OfflineSyncQueue.pendingCount, 1);
    final operation = OfflineSyncQueue.pendingOperations.single;
    expect(operation['type'], 'student_progress');
    final payload = operation['payload'] as Map;
    expect(payload['total_xp'], 35);
    expect(payload['current_slide'], 4);
    expect(payload['user_id'], 'local-offline-student');
    expect(storage.loadUserProgress().earnedXP, 35);
  });

  test('unregistered progress does not enqueue a student record', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    OfflineSyncQueue.initialize(preferences);
    final notifier = UserProgressNotifier(LocalStorageService(preferences));
    addTearDown(notifier.dispose);
    await notifier.addXP(10);
    expect(OfflineSyncQueue.pendingCount, 0);
  });
}
