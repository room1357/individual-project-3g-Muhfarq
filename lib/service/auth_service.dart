import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'dart:convert';

class AuthService {
  static const String _keyUser = 'current_user';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // Simpan user ke SharedPreferences (tanpa password)
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      _keyUser,
      jsonEncode({
        'username': user.username,
        'email': user.email,
        'fullName': user.fullName,
        // Jangan simpan password!
      }),
    );
    prefs.setBool(_keyIsLoggedIn, true);
  }

  // Ambil user yang tersimpan
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyUser);
    if (jsonString == null) return null;

    final data = jsonDecode(jsonString);
    return User(
      username: data['username'],
      password: '', // Kosongkan password
      email: data['email'],
      fullName: data['fullName'],
    );
  }

  // Cek status login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Hapus user (logout)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyUser);
    prefs.setBool(_keyIsLoggedIn, false);
  }
}
