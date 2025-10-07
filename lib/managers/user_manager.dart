import '../models/user.dart';

class UserManager {
  static final List<User> _users = [
    User(username: "admin", password: "1234"), // default
  ];

  static void addUser(User user) {
    _users.add(user);
  }

  static User? login(String username, String password) {
    try {
      return _users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}
