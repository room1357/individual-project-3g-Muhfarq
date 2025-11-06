import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/controllers/login_controller.dart';
import 'package:pemrograman_mobile/screens/home_screen.dart';
import 'package:pemrograman_mobile/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum LoginState { initial, loading, success, error }

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(); // ✅ ubah ke email
  final _passwordController = TextEditingController();
  final _loginController = LoginController();

  bool _obscurePassword = true;
  LoginState _loginState = LoginState.initial;
  String _errorMessage = '';

  void _handleLogin() async {
    if (_loginState == LoginState.loading) return;

    setState(() {
      _loginState = LoginState.loading;
      _errorMessage = '';
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final user = await _loginController.login(email, password);

      if (user != null) {
        setState(() => _loginState = LoginState.success);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        });
      } else {
        setState(() {
          _loginState = LoginState.error;
          _errorMessage = "Email atau password salah";
        });
      }
    } catch (e) {
      setState(() {
        _loginState = LoginState.error;
        _errorMessage = "Terjadi kesalahan: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_loginState == LoginState.error && _errorMessage.isNotEmpty) {
        _showErrorSnackBar();
      }
    });
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.redAccent,
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _errorMessage = '';
          _loginState = LoginState.initial;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loginState == LoginState.error && _errorMessage.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorSnackBar();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFDCFDEB),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Logo.png', width: 100, height: 100),
              const SizedBox(height: 24),
              const Text(
                '“Kelola keuanganmu dengan tenang,\nbersama SakuKu.”',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF0B5A3D),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 32),

              // 🔹 Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Color(0xFF0B5A3D)),
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(color: Color(0xFF1DC981)),
                  filled: true,
                  fillColor: const Color(0xFFABEFCA),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 🔹 Password
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Color(0xFF0B5A3D)),
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Color(0xFF1DC981)),
                  filled: true,
                  fillColor: const Color(0xFFABEFCA),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF0B5A3D),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 🔹 Tombol Login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _loginState == LoginState.loading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DC981),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      _loginState == LoginState.loading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 16),

              // 🔹 Teks bawah
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum memiliki akun? Mari buat ',
                    style: TextStyle(color: Color(0xFF0B5A3D)),
                  ),
                  GestureDetector(
                    onTap:
                        _loginState == LoginState.loading
                            ? null
                            : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                    child: const Text(
                      'Akun Barumu',
                      style: TextStyle(
                        color: Color(0xFF1DC981),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
