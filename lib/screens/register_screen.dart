import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/screens/login_screen.dart';
import '../controllers/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final RegisterController _registerController = RegisterController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _handleRegister() {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      _showSnackBar("Password dan konfirmasi belum sesuai", Colors.redAccent);
      return;
    }

    final success = _registerController.register(
      username,
      password,
      email: email,
      fullName: fullName,
    );

    if (success) {
      _showSnackBar(
        "Akun berhasil dibuat! Silakan login.",
        const Color(0xFF1DC981),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      _showSnackBar("Username sudah digunakan", Colors.redAccent);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: color,
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCFDEB), // 🌿 background lembut
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 Logo
            Image.asset('assets/images/Logo.png', width: 100, height: 100),
            const SizedBox(height: 16),

            // 🔹 Title
            // const Text(
            //   "S a k u K u",
            //   style: TextStyle(
            //     fontSize: 26,
            //     color: Color(0xFF0B5A3D),
            //     fontWeight: FontWeight.w600,
            //     letterSpacing: 2,
            //   ),
            // ),
            // const SizedBox(height: 8),

            // 🔹 Subtitle
            const Text(
              "“Kelola keuanganmu dengan tenang,\nbersama SakuKu.”",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontStyle: FontStyle.italic,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 32),

            // 🔹 Input Fields
            _buildTextField(_fullNameController, "Fullname", Icons.person),
            const SizedBox(height: 12),
            _buildTextField(
              _usernameController,
              "Username",
              Icons.account_circle,
            ),
            const SizedBox(height: 12),
            _buildTextField(_emailController, "Email", Icons.email),
            const SizedBox(height: 12),
            _buildPasswordField(_passwordController, "Password", true),
            const SizedBox(height: 12),
            _buildPasswordField(
              _confirmPasswordController,
              "Confirm Password",
              false,
            ),
            const SizedBox(height: 24),

            // 🔹 Register Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DC981),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Login Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sudah punya akun? ",
                  style: TextStyle(color: Colors.black87),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Color(0xFF0B5A3D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget TextField Custom
  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Color(0xFF0B5A3D)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFDCFDEB)),
        filled: true,
        fillColor: const Color(0xFFABEFCA),
        prefixIcon: Icon(icon, color: const Color(0xFFDCFDEB)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
    );
  }

  // 🔹 Widget Password Field Custom
  Widget _buildPasswordField(
    TextEditingController controller,
    String hint,
    bool isMain,
  ) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Color(0xFF0B5A3D)),
      obscureText: isMain ? _obscurePassword : _obscureConfirmPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFDCFDEB)),
        filled: true,
        fillColor: const Color(0xFFABEFCA),
        prefixIcon: const Icon(Icons.lock, color: Color(0xFFDCFDEB)),
        suffixIcon: IconButton(
          icon: Icon(
            (isMain ? _obscurePassword : _obscureConfirmPassword)
                ? Icons.visibility_off
                : Icons.visibility,
            color: const Color(0xFFDCFDEB),
          ),
          onPressed: () {
            setState(() {
              if (isMain) {
                _obscurePassword = !_obscurePassword;
              } else {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              }
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
    );
  }
}
