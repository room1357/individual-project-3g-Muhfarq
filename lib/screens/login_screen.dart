import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/screens/home_screen.dart';
import 'package:pemrograman_mobile/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selamat Datang',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        //agar tidak overflow karena bisa discroll
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 64.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            SizedBox(height: 32),

            // Username Field
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16),

            // Password Field
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 24),

            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle login
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Register Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? "),
                TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  onPressed: () {
                    // Navigate to register
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
