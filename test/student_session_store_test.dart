import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_modul_etnosains/shared/services/student_session_store.dart';

void main() {
  test('student refresh token persists until explicitly cleared', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    StudentSessionStore.initialize(preferences);

    await StudentSessionStore.saveRefreshToken('student-refresh-token');
    expect(StudentSessionStore.refreshToken, 'student-refresh-token');

    await StudentSessionStore.clear();
    expect(StudentSessionStore.refreshToken, isNull);
  });
}
