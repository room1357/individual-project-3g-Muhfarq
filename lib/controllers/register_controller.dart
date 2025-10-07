import '../models/user.dart';
import 'package:collection/collection.dart';

class RegisterController {
  //singleton instance
  static final RegisterController _instance = RegisterController._internal();
  factory RegisterController() => _instance;
  RegisterController._internal();

  final List<User> _registeredUsers = [];

  List<User> get users => List.unmodifiable(_registeredUsers);

  //fungsi
  bool register(
    String username,
    String password, {
    String? email,
    String? fullName,
  }) {
    final exists = _registeredUsers.any((u) => u.username == username);
    if (exists) return false;

    _registeredUsers.add(
      User(
        username: username,
        password: password,
        email: email,
        fullName: fullName,
      ),
    );
    return true;
  }

  User? findUser(String username) {
    return _registeredUsers.where((u) => u.username == username).firstOrNull;
  }

  void clearUsers() {
    _registeredUsers.clear();
  }
}
