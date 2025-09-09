import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyIsAdmin = 'isAdmin';
  static const String _keyEmployeeId = 'employeeId';
  static const String _keyFingerprintId = 'fingerprintId';

  // Save user session data
  static Future<void> saveSession({
    required bool isLoggedIn,
    required bool isAdmin,
    required String employeeId,
    required String fingerprintId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
    await prefs.setBool(_keyIsAdmin, isAdmin);
    await prefs.setString(_keyEmployeeId, employeeId);
    await prefs.setString(_keyFingerprintId, fingerprintId);
  }

  // Get current session data
  static Future<SessionData?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;

    if (!isLoggedIn) return null;

    final isAdmin = prefs.getBool(_keyIsAdmin) ?? false;
    final employeeId = prefs.getString(_keyEmployeeId);
    final fingerprintId = prefs.getString(_keyFingerprintId);

    if (employeeId == null || fingerprintId == null) {
      // Invalid session, clear it
      await clearSession();
      return null;
    }

    return SessionData(
      isLoggedIn: isLoggedIn,
      isAdmin: isAdmin,
      employeeId: employeeId,
      fingerprintId: fingerprintId,
    );
  }

  // Clear all session data
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyIsAdmin);
    await prefs.remove(_keyEmployeeId);
    await prefs.remove(_keyFingerprintId);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final session = await getSession();
    return session != null;
  }
}

class SessionData {
  final bool isLoggedIn;
  final bool isAdmin;
  final String employeeId;
  final String fingerprintId;

  SessionData({
    required this.isLoggedIn,
    required this.isAdmin,
    required this.employeeId,
    required this.fingerprintId,
  });
}
