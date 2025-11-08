import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/controllers/register_controller.dart';
import 'package:pemrograman_mobile/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final RegisterController _registerController = RegisterController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // 🔹 Validasi field
    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnackBar("Semua field harus diisi!", Colors.redAccent);
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar("Password dan konfirmasi tidak cocok", Colors.redAccent);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _registerController.register(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (mounted) {
        _showSnackBar(
          "Akun berhasil dibuat! Silakan login.",
          const Color(0xFF1DC981),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // 🔹 Menangani error spesifik dari Firebase
      String errorMsg;
      switch (e.code) {
        case 'email-already-in-use':
          errorMsg = 'Email sudah digunakan akun lain.';
          break;
        case 'invalid-email':
          errorMsg = 'Format email tidak valid.';
          break;
        case 'weak-password':
          errorMsg = 'Password terlalu lemah.';
          break;
        default:
          errorMsg = e.message ?? 'Terjadi kesalahan.';
      }
      _showSnackBar(errorMsg, Colors.redAccent);
    } catch (e) {
      _showSnackBar("Terjadi kesalahan: $e", Colors.redAccent);
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCFDEB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 Logo
            Image.asset('assets/images/Logo.png', width: 100, height: 100),
            const SizedBox(height: 16),

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

            _buildTextField(_fullNameController, "Username", Icons.person),
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

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DC981),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
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
        hintStyle: const TextStyle(color: Color(0xFF1DC981)),
        filled: true,
        fillColor: const Color(0xFFABEFCA),
        prefixIcon: Icon(icon, color: const Color(0xFF1DC981)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String hint,
    bool isMain,
  ) {
    return TextField(
      controller: controller,
      obscureText: isMain ? _obscurePassword : _obscureConfirmPassword,
      style: const TextStyle(color: Color(0xFF0B5A3D)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF1DC981)),
        filled: true,
        fillColor: const Color(0xFFABEFCA),
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF1DC981)),
        suffixIcon: IconButton(
          icon: Icon(
            (isMain ? _obscurePassword : _obscureConfirmPassword)
                ? Icons.visibility_off
                : Icons.visibility,
            color: const Color(0xFF0B5A3D),
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
      ),
    );
  }
}
