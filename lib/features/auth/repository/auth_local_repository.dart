import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthLocalRepository {
  Future<void> setAuthenticatedStatus();
  bool getAuthenticatedStatus();
}

class AuthLocalRepositoryImpl extends AuthLocalRepository {
  final SharedPreferences _sharedPreferences;
  AuthLocalRepositoryImpl(this._sharedPreferences);
  @override
  Future<void> setAuthenticatedStatus() async {
    try {
      await _sharedPreferences.setBool('isAuthenticated', true);
    } catch (e) {
      throw Exception('Failed to set authenticated status: $e');
    }
  }

  @override
  bool getAuthenticatedStatus() {
    return _sharedPreferences.getBool('isAuthenticated') ?? false;
  }
}
