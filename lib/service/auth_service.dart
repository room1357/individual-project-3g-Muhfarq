import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _keyUser = 'current_user';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // Register
  Future<User?> register(String email, String password, String fullName) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan data lokal
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        _keyUser,
        jsonEncode({'email': email, 'fullName': fullName}),
      );
      prefs.setBool(_keyIsLoggedIn, true);

      return credential.user;
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  // Login
  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_keyUser, jsonEncode({'email': email}));
      prefs.setBool(_keyIsLoggedIn, true);

      return credential.user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // Cek status login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }
}
