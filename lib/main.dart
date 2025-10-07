import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'controllers/register_controller.dart';

void main() {
  final registerController = RegisterController();
  runApp(MyApp(registerController: registerController));
}

class MyApp extends StatefulWidget {
  final RegisterController registerController;
  const MyApp({super.key, required this.registerController});

  @override
  State<MyApp> createState() => _MyAppState();

  // 🔹 akses global supaya bisa dipanggil dari halaman lain
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  // ✅ controller global
  final RegisterController _registerController = RegisterController();

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      // Tema terang
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // Tema gelap
      darkTheme: ThemeData.dark(),

      // 🔹 themeMode bisa berubah lewat PengaturanScreen
      themeMode: _themeMode,

      // ✅ Pass controller ke LoginScreen
      home: LoginScreen(registerController: _registerController),
      routes: {
        '/home': (context) => const HomeScreen(),

        // ✅ Pass controller ke RegisterScreen
        '/register':
            (context) =>
                RegisterScreen(registerController: _registerController),
      },
    );
  }
}
