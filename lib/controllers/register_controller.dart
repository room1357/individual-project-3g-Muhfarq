import '../models/user.dart';

class RegisterController {
  // List private untuk simpan semua user
  final List<User> _registeredUsers = [];

  /// Getter untuk ambil daftar user
  List<User> get users => List.unmodifiable(_registeredUsers);

  /// Daftarkan user baru
  /// return true jika sukses, false jika username sudah ada
  bool register(
    String username,
    String password, {
    String? email,
    String? fullName,
  }) {
    // Cek apakah username sudah dipakai
    final exists = _registeredUsers.any((u) => u.username == username);
    if (exists) return false;

    // Tambahkan user baru
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

  /// Cari user berdasarkan username
  User? findUser(String username) {
    return _registeredUsers.where((u) => u.username == username).firstOrNull;
  }

  /// Hapus semua user (reset)
  void clearUsers() {
    _registeredUsers.clear();
  }
}
