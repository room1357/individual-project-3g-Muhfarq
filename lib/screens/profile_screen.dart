import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import '../models/user.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  // Ambil singleton LoginController
  final LoginController _loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    // Ambil user yang sedang login
    final User? user = _loginController.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFDCFDEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B5A3D),
        title: const Text(
          "Profil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Foto profil
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1DC981).withValues(alpha: .3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/IMG_0752.JPG'),
              ),
            ),
            const SizedBox(height: 20),

            // Nama (ambil dari user login)
            Text(
              user?.fullName ?? "Nama Pengguna",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B5A3D),
              ),
              textAlign: TextAlign.center,
            ),

            // Email (ambil dari user login)
            Text(
              user?.email ?? "Email tidak tersedia",
              style: const TextStyle(fontSize: 16, color: Color(0xFF1DC981)),
            ),

            const SizedBox(height: 30),

            // Tombol Edit Profil (dummy)
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.green,
                    content: const Row(
                      children: [
                        Icon(Icons.error, color: Colors.greenAccent),
                        SizedBox(width: 12),
                        Text("Fitur Edit Profil belum tersedia"),
                      ],
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1DC981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              icon: const Icon(Icons.edit),
              label: const Text(
                "Edit Profil",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
