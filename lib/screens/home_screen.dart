import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/screens/advenced_expense_list_screen.dart';
import 'package:pemrograman_mobile/screens/category_screen.dart';
// import 'package:pemrograman_mobile/screens/profile_screen.dart';
import 'package:pemrograman_mobile/screens/export_pdf_screen.dart';
// import 'package:pemrograman_mobile/screens/pengaturan_screen.dart';
import 'dashboard_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // 🔹 Daftar halaman untuk setiap tab di bawah
  final List<Widget> _pages = const [
    DashboardPage(),
    AdvancedExpenseListScreen(),
    CategoryScreen(),
    ExportPdfScreen(),
    // ProfileScreen(),
    // PengaturanScreen(),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
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
            // 🔹 Menu Dashboard
//             Expanded(
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 children: [
//                   _buildDashboardCard(
//                     title: 'Pengeluaran Advance',
//                     icon: Icons.attach_money_outlined,
//                     color: Colors.green,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (context) => const AdvancedExpenseListScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildDashboardCard(
//                     title: 'Pengeluaran',
//                     icon: Icons.money_outlined,
//                     color: const Color.fromARGB(255, 0, 142, 87),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ExpenseListScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildDashboardCard(
//                     title: 'Kategori',
//                     icon: Icons.category_outlined,
//                     color: Colors.teal,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const CategoryScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildDashboardCard(
//                     title: 'Profil',
//                     icon: Icons.person_outlined,
//                     color: Colors.blue,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ProfileScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildDashboardCard(
//                     title: 'Export PDF',
//                     icon: Icons.picture_as_pdf_outlined,
//                     color: Colors.red,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ExportPdfScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                   _buildDashboardCard(
//                     title: 'Pengaturan',
//                     icon: Icons.settings_outlined,
//                     color: Colors.purple,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const PengaturanScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
  

//   Widget _buildDashboardCard({
//     required String title,
//     required IconData icon,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 48, color: color),
//               const SizedBox(height: 16),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
