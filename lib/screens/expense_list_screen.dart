import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/screens/advenced_expense_list_screen.dart';
import 'package:pemrograman_mobile/screens/category_screen.dart';
import 'package:pemrograman_mobile/screens/export_pdf_screen.dart';
import 'dashboard_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // 🔹 Daftar halaman untuk setiap tab di bawah
  final List<Widget> _pages = [
    DashboardPage(),
    AdvancedExpenseListScreen(),
    CategoryScreen(),
    ExportPdfScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          (_selectedIndex < _pages.length) ? _pages[_selectedIndex] : _pages[0],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFFFFFF), // putih lembut
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF1DC981), // hijau toska utama
        unselectedItemColor: const Color(0xFFABEFCA), // hijau muda
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Advance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Kategori',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf),
            label: 'Export',
          ),
        ],
      ),
    );
  }
}
