import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class OfflineSyncQueue {
  static const _storageKey = 'pending_supabase_operations_v1';
  static SharedPreferences? _preferences;
  static Future<void> _mutation = Future.value();

  static void initialize(SharedPreferences preferences) {
    _preferences = preferences;
  }

  static List<Map<String, dynamic>> get pendingOperations {
    final raw = _preferences?.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return List<Map<String, dynamic>>.from(
        (jsonDecode(raw) as List).map(
          (item) => Map<String, dynamic>.from(item as Map),
        ),
      );
    } catch (_) {
      return [];
    }
  }

  static int get pendingCount => pendingOperations.length;

  static Future<void> enqueue({
    required String queueId,
    required String type,
    required Map<String, dynamic> payload,
  }) {
    return _serialize(() async {
      final operations = pendingOperations;
      final index =
          operations.indexWhere((item) => item['queue_id'] == queueId);
      final operation = {
        'queue_id': queueId,
        'type': type,
        'payload': payload,
        'queued_at': DateTime.now().toUtc().toIso8601String(),
        'attempts': index >= 0 ? operations[index]['attempts'] ?? 0 : 0,
      };
      if (index >= 0) {
        operations[index] = operation;
      } else {
        operations.add(operation);
      }
      await _save(operations);
    });
  }

  static Future<void> markAttempt(String queueId) {
    return _serialize(() async {
      final operations = pendingOperations;
      final index =
          operations.indexWhere((item) => item['queue_id'] == queueId);
      if (index < 0) return;
      operations[index]['attempts'] =
          ((operations[index]['attempts'] as num?)?.toInt() ?? 0) + 1;
      operations[index]['last_attempt_at'] =
          DateTime.now().toUtc().toIso8601String();
      await _save(operations);
    });
  }

  static Future<void> remove(String queueId) {
    return _serialize(() async {
      final operations = pendingOperations
          .where((item) => item['queue_id'] != queueId)
          .toList();
      await _save(operations);
    });
  }

  static Future<void> _save(List<Map<String, dynamic>> operations) async {
    final preferences = _preferences;
    if (preferences == null) return;
    await preferences.setString(_storageKey, jsonEncode(operations));
  }

  static Future<void> _serialize(Future<void> Function() action) {
    final result = _mutation.then((_) => action());
    _mutation = result.catchError((_) {});
    return result;
  }
}
