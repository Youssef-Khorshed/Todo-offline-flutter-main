import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPref? _instance;
  static SharedPreferences? _prefs;

  // Private constructor
  SharedPref._();

  // Singleton instance getter
  static Future<SharedPref> getInstance() async {
    _instance ??= SharedPref._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Initialize method (alternative way to get instance)
  static Future<SharedPref> init() async {
    return getInstance();
  }

  // Email methods
  Future<void> saveEmail(String email) async {
    await _prefs?.setString('email', email);
  }

  String? getEmail() {
    return _prefs?.getString('email');
  }

  // Password methods
  Future<void> savePassword(String password) async {
    await _prefs?.setString('password', password);
  }

  String? getPassword() {
    return _prefs?.getString('password');
  }

  // Combined credentials methods
  Future<void> saveCredentials(String email, String password) async {
    await saveEmail(email);
    await savePassword(password);
  }

  bool isLogin() {
    String? email = getEmail();
    String? password = getPassword();
    return email != null &&
        password != null &&
        email.isNotEmpty &&
        password.isNotEmpty;
  }

  // Logout method
  Future<void> logout() async {
    await _prefs?.remove('email');
    await _prefs?.remove('password');
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs?.clear();
  }

  // Check if user has saved credentials
  Future<bool> hasSavedCredentials() async {
    String? email = getEmail();
    String? password = getPassword();
    return email != null &&
        password != null &&
        email.isNotEmpty &&
        password.isNotEmpty;
  }
}
