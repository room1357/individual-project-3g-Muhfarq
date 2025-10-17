import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pemrograman_mobile/screens/login_screen.dart';
import 'package:pemrograman_mobile/screens/pengaturan_screen.dart';
import 'package:pemrograman_mobile/screens/profile_screen.dart';
import '../managers/expense_manager.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  double _calculateTotal() {
    return ExpenseManager.expenses.fold(
      0.0,
      (sum, expense) => sum + expense.amount,
    );
  }

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            accountName: Text("Nama Pengguna"),
            accountEmail: Text("email@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profil"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Pengaturan"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PengaturanScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenses = ExpenseManager.expenses;

    final Map<DateTime, double> dailyTotals = {};
    for (var e in expenses) {
      final date = DateTime(e.date.year, e.date.month, e.date.day);
      dailyTotals[date] = (dailyTotals[date] ?? 0) + e.amount;
    }

    final sortedDates = dailyTotals.keys.toList()..sort();

    final spots = <FlSpot>[];
    for (int i = 0; i < sortedDates.length; i++) {
      final date = sortedDates[i];
      spots.add(FlSpot(i.toDouble(), dailyTotals[date]!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: _buildDrawer(context),
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

            Card(
              //elevation: 2,
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

            if (spots.isNotEmpty) ...[
              const Text(
                "Pengeluaranmu saat ini:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                height: 280,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.indigo.shade50,
                      Colors.blue.shade50,
                      Colors.white,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: LineChart(
                  LineChartData(
                    backgroundColor: Colors.transparent,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 50000,
                      getDrawingHorizontalLine:
                          (value) => FlLine(
                            color: Colors.indigo.withValues(alpha: 0.1),
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          interval: 50000,
                          getTitlesWidget: (value, meta) {
                            if (value % 50000 == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(
                                  'Rp ${(value / 1000).toInt()}K',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.indigo.shade700,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < sortedDates.length) {
                              final date = sortedDates[value.toInt()];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  "${date.day}/${date.month}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.indigo.shade700,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        curveSmoothness: 0.3,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade400,
                            Colors.indigo.shade400,
                          ],
                        ),
                        color: Colors.blue,
                        barWidth: 3,

                        dotData: FlDotData(
                          show: true,
                          getDotPainter:
                              (spot, percent, barData, index) =>
                                  FlDotCirclePainter(
                                    radius: 4,
                                    color: Colors.white,
                                    strokeWidth: 2,
                                    strokeColor: Colors.blue.shade700,
                                  ),
                          checkToShowDot: (spot, barData) {
                            return true;
                          },
                        ),

                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.withValues(alpha: 0.3),
                              Colors.blue.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 0.5, 1.0],
                          ),
                        ),
                        shadow: Shadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((touchedSpot) {
                            return LineTooltipItem(
                              'Rp ${_formatCurrency(touchedSpot.y)}',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      ),
                      handleBuiltInTouches: true,
                    ),
                    minY: 0,
                    maxY:
                        spots.isNotEmpty
                            ? (spots
                                    .map((spot) => spot.y)
                                    .reduce((a, b) => a > b ? a : b) *
                                1.2)
                            : 100000,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ] else ...[
              const Expanded(
                child: Center(
                  child: Text(
                    'Tidak ada data pengeluaran',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),
            ],

            if (spots.isNotEmpty) const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
