import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_modul_etnosains/shared/services/offline_sync_queue.dart';

void main() {
  test('offline queue persists, deduplicates, and removes operations',
      () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    OfflineSyncQueue.initialize(preferences);

    await OfflineSyncQueue.enqueue(
      queueId: 'record-1',
      type: 'quiz_result',
      payload: {'score': 70},
    );
    await OfflineSyncQueue.enqueue(
      queueId: 'record-1',
      type: 'quiz_result',
      payload: {'score': 80},
    );

    expect(OfflineSyncQueue.pendingCount, 1);
    expect(
      (OfflineSyncQueue.pendingOperations.single['payload'] as Map)['score'],
      80,
    );

    await OfflineSyncQueue.markAttempt('record-1');
    expect(OfflineSyncQueue.pendingOperations.single['attempts'], 1);

    await OfflineSyncQueue.remove('record-1');
    expect(OfflineSyncQueue.pendingCount, 0);
  });
}
