import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pemrograman_mobile/screens/expense_list_screen.dart';
import 'package:pemrograman_mobile/screens/advenced_expense_list_screen.dart';
import 'package:pemrograman_mobile/screens/category_screen.dart';
import 'package:pemrograman_mobile/screens/profile_screen.dart';
import 'package:pemrograman_mobile/screens/export_pdf_screen.dart';
import 'package:pemrograman_mobile/screens/pengaturan_screen.dart';
import 'package:pemrograman_mobile/controllers/register_controller.dart';
import 'package:pemrograman_mobile/screens/login_screen.dart';
import '../managers/expense_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  double _calculateTotal() {
    return ExpenseManager.expenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenses = ExpenseManager.expenses;

    // 🔹 Kelompokkan pengeluaran berdasarkan tanggal
    final Map<DateTime, double> dailyTotals = {};
    for (var e in expenses) {
      final date = DateTime(e.date.year, e.date.month, e.date.day);
      dailyTotals[date] = (dailyTotals[date] ?? 0) + e.amount;
    }

    // 🔹 Urutkan tanggal
    final sortedDates = dailyTotals.keys.toList()..sort();

    // 🔹 Ubah jadi titik grafik
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];
      spots.add(FlSpot(i.toDouble(), dailyTotals[date]!));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Beranda', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          LoginScreen(registerController: RegisterController()),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang👋',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Text(
              'Kelola pengeluaranmu dengan mudah',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),

            // 🔹 Total Pengeluaran
            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: const Text(
                  'Total Pengeluaran',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Semua kategori & bulan'),
                trailing: Text(
                  'Rp ${_calculateTotal().toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 Grafik Garis
            if (spots.isNotEmpty) ...[
              const Text(
                "Pengeluaranmu saat ini:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 45,
                          getTitlesWidget: (value, meta) {
                            // 🔹 Format nilai di sumbu Y
                            return Text(
                              'Rp ${value.toInt()}',
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            // 🔹 Format tanggal di sumbu X
                            if (value.toInt() < sortedDates.length) {
                              final date = sortedDates[value.toInt()];
                              return Text(
                                "${date.day}/${date.month}",
                                style: const TextStyle(fontSize: 10),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        spots: spots,
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                        ),
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.withOpacity(0.3),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // 🔹 Menu Dashboard
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
                    title: 'Pengeluaran Advance',
                    icon: Icons.attach_money_outlined,
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const AdvancedExpenseListScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    title: 'Pengeluaran',
                    icon: Icons.money_outlined,
                    color: const Color.fromARGB(255, 0, 142, 87),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExpenseListScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    title: 'Kategori',
                    icon: Icons.category_outlined,
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CategoryScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    title: 'Profil',
                    icon: Icons.person_outlined,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    title: 'Export PDF',
                    icon: Icons.picture_as_pdf_outlined,
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExportPdfScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDashboardCard(
                    title: 'Pengaturan',
                    icon: Icons.settings_outlined,
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PengaturanScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
