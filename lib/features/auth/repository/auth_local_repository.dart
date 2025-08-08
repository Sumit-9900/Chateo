import 'package:chateo_app/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthLocalRepository {
  Future<void> setAuthenticatedStatus();
  bool getAuthenticatedStatus();
  Future<void> setPhoneNumber(String phoneNumber);
  String getPhoneNumber();
}

class AuthLocalRepositoryImpl extends AuthLocalRepository {
  final SharedPreferences sharedPreferences;
  AuthLocalRepositoryImpl(this.sharedPreferences);
  @override
  Future<void> setAuthenticatedStatus() async {
    try {
      await sharedPreferences.setBool(AppConstants.isAuthenticatedKey, true);
    } catch (e) {
      throw Exception('Failed to set authenticated status: $e');
    }
  }

  @override
  bool getAuthenticatedStatus() {
    return sharedPreferences.getBool(AppConstants.isAuthenticatedKey) ?? false;
  }

  @override
  String getPhoneNumber() {
    return sharedPreferences.getString(AppConstants.phoneNumberKey) ?? '';
  }

  @override
  Future<void> setPhoneNumber(String phoneNumber) async {
    try {
      print('setPhoneNumber: $phoneNumber');
      await sharedPreferences.setString(
        AppConstants.phoneNumberKey,
        phoneNumber,
      );
    } catch (e) {
      throw Exception('Failed to set phone number: $e');
    }
  }
}
