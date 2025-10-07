import '../models/user.dart';
import 'register_controller.dart';
import 'package:collection/collection.dart';

class LoginController {
  final RegisterController _registerController;

  LoginController(this._registerController);

  User? login(String username, String password) {
    return _registerController.users.firstWhereOrNull(
      (user) => user.username == username && user.password == password,
    );
  }

  bool validate(String username, String password) {
    return login(username, password) != null;
  }
}
