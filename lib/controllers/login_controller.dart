import '../models/user.dart';
import 'register_controller.dart';
import 'package:collection/collection.dart';

class LoginController {
  //singleton instance
  static final LoginController _instance = LoginController._internal();
  factory LoginController() => _instance;
  LoginController._internal();

  // Ambil singleton RegisterController
  final RegisterController _registerController = RegisterController();
  //Login
  User? login(String username, String password) {
    return _registerController.users.firstWhereOrNull(
      (user) => user.username == username && user.password == password,
    );
  }

  bool validate(String username, String password) {
    return login(username, password) != null;
  }
}
