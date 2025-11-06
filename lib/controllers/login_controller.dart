import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:pemrograman_mobile/service/auth_service.dart';

class LoginController {
  static final LoginController _instance = LoginController._internal();
  factory LoginController() => _instance;
  LoginController._internal();

  final AuthService _authService = AuthService();
  final Logger _logger = Logger();
  User? currentUser;

  Future<User?> login(String email, String password) async {
    try {
      final user = await _authService.login(email, password);
      currentUser = user;
      _logger.i('Login success: ${user?.email}');
      return user;
    } on FirebaseAuthException catch (e) {
      _logger.w('Login failed: ${e.code} - ${e.message}');
      return null;
    } catch (e, stackTrace) {
      _logger.e(
        'Unexpected error during login',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<User?> register(String email, String password, String fullName) async {
    try {
      final user = await _authService.register(email, password, fullName);
      currentUser = user;
      _logger.i('User registered and logged in: ${user?.email}');
      return user;
    } catch (e, stackTrace) {
      _logger.e('Registration failed', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      _logger.i('User logged out successfully');
      currentUser = null;
    } catch (e) {
      _logger.w('Logout error: $e');
    }
  }

  Future<bool> checkExistingLogin() async {
    final loggedIn = await _authService.isLoggedIn();
    if (loggedIn) {
      currentUser = FirebaseAuth.instance.currentUser;
      _logger.i('Existing login found: ${currentUser?.email}');
    } else {
      _logger.i('No existing user session found');
    }
    return loggedIn;
  }

  bool get isLoggedIn => currentUser != null;
}
