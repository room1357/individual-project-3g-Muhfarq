import 'package:flutter/material.dart';

class UserInputController {
  // 🔹 Controller untuk tiap field input
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  // 🔹 Ambil nilai dari semua controller
  String get username => usernameController.text.trim();
  String get password => passwordController.text.trim();
  String get email => emailController.text.trim();
  String get fullName => fullNameController.text.trim();

  // 🔹 Reset semua field
  void clear() {
    usernameController.clear();
    passwordController.clear();
    emailController.clear();
    fullNameController.clear();
  }

  // 🔹 Hapus semua resource ketika tidak dipakai
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    fullNameController.dispose();
  }
}
