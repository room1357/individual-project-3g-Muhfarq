import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil user dari Firebase
    final User? user = FirebaseAuth.instance.currentUser;

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
            // 🔹 Foto profil (placeholder)
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

            // 🔹 Nama pengguna (ambil dari Firebase)
            Text(
              user?.displayName ?? "Nama Pengguna",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B5A3D),
              ),
              textAlign: TextAlign.center,
            ),

            // 🔹 Email pengguna
            Text(
              user?.email ?? "Email tidak tersedia",
              style: const TextStyle(fontSize: 16, color: Color(0xFF1DC981)),
            ),

            const SizedBox(height: 30),

            // 🔹 Tombol Edit Profil (belum aktif)
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
                        Icon(Icons.info, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          "Fitur Edit Profil belum tersedia",
                          style: TextStyle(color: Colors.white),
                        ),
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
