import 'package:flutter/material.dart';
import '../main.dart'; // supaya bisa akses MyApp.of(context)

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tema",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 🔹 Switch untuk Dark Mode
            ListTile(
              title: const Text("Dark Mode"),
              trailing: Switch(
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
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Ikuti System",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
