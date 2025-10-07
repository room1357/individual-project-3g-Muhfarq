class User {
  final String username;
  final String password;
  final String? email;
  final String? fullName;

  User({
    required this.username,
    required this.password,
    this.email,
    this.fullName,
  });
}
