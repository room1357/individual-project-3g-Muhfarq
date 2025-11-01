import 'package:pemrograman_mobile/service/auth_service.dart';
import '../models/user.dart';
import 'register_controller.dart';
// import 'package:collection/collection.dart';

class LoginController {
  static final LoginController _instance = LoginController._internal();
  factory LoginController() => _instance;
  LoginController._internal();

  User? currentUser;
  final RegisterController _registerController = RegisterController();
  final AuthService _authService = AuthService();

  // Validasi cepat (synchronous) - hanya cek kredensial
  bool validateCredentials(String username, String password) {
    return _registerController.users.any(
      (user) => user.username == username && user.password == password,
    );
  }

  // Login lengkap (asynchronous) - dengan save ke storage
  Future<User?> login(String username, String password) async {
    if (validateCredentials(username, password)) {
      final user = _registerController.users.firstWhere(
        (user) => user.username == username && user.password == password,
      );
      currentUser = user;
      await _authService.saveUser(user);
      return user;
    }
    return null;
  }

  // Untuk kompatibilitas - validate yang lama
  bool validate(String username, String password) {
    return validateCredentials(username, password);
  }

  // Cek apakah user sudah login dari SharedPreferences
  Future<bool> checkExistingLogin() async {
    final user = await _authService.getUser();
    if (user != null) {
      currentUser = user;
      return true;
    }
    return false;
  }

  // Logout
  Future<void> logout() async {
    currentUser = null;
    await _authService.logout();
  }

  // Getter untuk cek status login
  bool get isLoggedIn => currentUser != null;
}
