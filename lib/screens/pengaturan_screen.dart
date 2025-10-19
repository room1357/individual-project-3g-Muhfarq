import 'package:flutter/material.dart';
import '../main.dart'; // supaya bisa akses MyApp.of(context)

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCFDEB),
      appBar: AppBar(
        title: const Text("Pengaturan", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0B5A3D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tema",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B5A3D),
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 Switch untuk Dark Mode
            ListTile(
              tileColor: const Color(0xFFABEFCA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                "Dark Mode",
                style: TextStyle(
                  color: Color(0xFF0B5A3D),
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Switch(
                activeColor: const Color(0xFF1DC981),
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (bool value) {
                  if (value) {
                    MyApp.of(context)?.changeTheme(ThemeMode.dark);
                  } else {
                    MyApp.of(context)?.changeTheme(ThemeMode.light);
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Tombol Ikuti Sistem
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  MyApp.of(context)?.changeTheme(ThemeMode.system);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DC981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  "Ikuti Sistem",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
