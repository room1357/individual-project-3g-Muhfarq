import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String _keyUser = 'current_user';
  static const String _keyIsLoggedIn = 'is_logged_in';
  final Logger _logger = Logger(); // 🔹 inisialisasi logger

  // 🔹 Register user baru
  Future<User?> register(String email, String password, String fullName) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Simpan nama ke profil Firebase (displayName)
      await credential.user?.updateDisplayName(fullName);

      // Simpan ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _keyUser,
        jsonEncode({'email': email, 'fullName': fullName}),
      );
      await prefs.setBool(_keyIsLoggedIn, true);

      _logger.i('✅ Register berhasil untuk $email');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _logger.e(
        '⚠️ FirebaseAuthException saat register: ${e.code} - ${e.message}',
      );
      return null;
    } catch (e) {
      _logger.e('❌ Error tak terduga saat register: $e');
      return null;
    }
  }

  // 🔹 Login user
  Future<User?> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUser, jsonEncode({'email': email}));
      await prefs.setBool(_keyIsLoggedIn, true);

      _logger.i('✅ Login berhasil untuk $email');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _logger.e(
        '⚠️ FirebaseAuthException saat login: ${e.code} - ${e.message}',
      );
      return null;
    } catch (e) {
      _logger.e('❌ Error tak terduga saat login: $e');
      return null;
    }
  }

  // 🔹 Logout user
  Future<void> logout() async {
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _logger.i('👋 User berhasil logout');
    } catch (e) {
      _logger.e('❌ Gagal logout: $e');
    }
  }

  // 🔹 Cek status login
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    _logger.d('🔍 Status login: $loggedIn');
    return loggedIn;
  }
}
