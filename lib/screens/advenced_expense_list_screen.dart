import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../managers/expense_manager.dart';
import '../managers/category_manager.dart';
import 'add_expense_screen.dart';
import 'edit_expense_screen.dart';
import 'package:intl/intl.dart';

class AdvancedExpenseListScreen extends StatefulWidget {
  const AdvancedExpenseListScreen({super.key});

  @override
  _AdvancedExpenseListScreenState createState() =>
      _AdvancedExpenseListScreenState();
}

class _AdvancedExpenseListScreenState extends State<AdvancedExpenseListScreen> {
  List<Expense> expenses = ExpenseManager.expenses;
  List<Expense> filteredExpenses = [];
  String selectedCategory = 'Semua';
  TextEditingController searchController = TextEditingController();

  // 🎨 Tema warna seragam
  final Color darkGreen = const Color(0xFF0B5A3D);
  final Color lightGreen = const Color(0xFFABEFCA);
  final Color paleGreen = const Color(0xFFDCFDEB);
  final Color brightGreen = const Color(0xFF1DC981);
  final Color extraLightGreen = const Color(0xFFE6FFF3); // 🌿 lebih lembut

  @override
  void initState() {
    super.initState();
    filteredExpenses = expenses;
  }

  @override
  Widget build(BuildContext context) {
    final total = _calculateTotal(filteredExpenses);

    return Scaffold(
      backgroundColor: paleGreen,
      body: Column(
        children: [
          // 🔹 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            decoration: BoxDecoration(
              color: darkGreen,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang 👋',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total Pengeluaran Kamu',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Rp ${NumberFormat("#,###", "id_ID").format(total)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 SEARCH BAR
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: darkGreen.withValues(alpha: 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Cari pengeluaran...',
                  prefixIcon: Icon(Icons.search, color: darkGreen),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) => _filterExpenses(),
              ),
            ),
          ),

          // 🔹 CATEGORY FILTER
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip('Semua'),
                ...CategoryManager.categories.map(
                  (category) => _buildCategoryChip(category.name),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 STATISTICS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total', 'Rp ${total.toStringAsFixed(0)}'),
                _buildStatCard('Jumlah', '${filteredExpenses.length} item'),
                _buildStatCard(
                  'Rata-rata',
                  _calculateAverage(filteredExpenses),
                ),
              ],
            ),
          ),

          // 🔹 LIST
          Expanded(
            child:
                filteredExpenses.isEmpty
                    ? const Center(
                      child: Text(
                        'Tidak ada pengeluaran ditemukan',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 80,
                        top: 8,
                      ),
                      itemCount: filteredExpenses.length,
                      itemBuilder: (context, index) {
                        final expense = filteredExpenses[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: darkGreen.withValues(alpha: 0.08),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: brightGreen,
                              child: Icon(
                                _getCategoryIcon(expense.category),
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              expense.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: darkGreen,
                              ),
                            ),
                            subtitle: Text(
                              '${expense.category} • ${expense.formattedDate}',
                              style: TextStyle(
                                color: darkGreen.withValues(alpha: 0.7),
                              ),
                            ),
                            trailing: Text(
                              expense.formattedAmount,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: darkGreen,
                              ),
                            ),
                            onTap: () => _showExpenseDetails(context, expense),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),

      // 🔹 FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: brightGreen,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
          setState(() {
            filteredExpenses = ExpenseManager.expenses;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // 🔹 Category Chip
  Widget _buildCategoryChip(String category) {
    final bool selected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          category,
          style: TextStyle(
            color: selected ? Colors.white : darkGreen,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: selected,
        selectedColor: darkGreen,
        backgroundColor: lightGreen,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: selected ? darkGreen : brightGreen,
            width: 1.5,
          ),
        ),
        onSelected: (_) {
          setState(() {
            selectedCategory = category;
            _filterExpenses();
          });
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: darkGreen,
          ),
        ),
      ],
    );
  }

  void _filterExpenses() {
    setState(() {
      filteredExpenses =
          expenses.where((expense) {
            final matchesSearch =
                searchController.text.isEmpty ||
                expense.title.toLowerCase().contains(
                  searchController.text.toLowerCase(),
                ) ||
                (expense.description ?? '').toLowerCase().contains(
                  searchController.text.toLowerCase(),
                );

            final matchesCategory =
                selectedCategory == 'Semua' ||
                expense.category == selectedCategory;

            return matchesSearch && matchesCategory;
          }).toList();
    });
  }

  String _calculateAverage(List<Expense> expenses) {
    if (expenses.isEmpty) return 'Rp 0';
    double avg =
        expenses.fold(0.0, (sum, e) => sum + e.amount) / expenses.length;
    return 'Rp ${avg.toStringAsFixed(0)}';
  }

  double _calculateTotal(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return Icons.restaurant;
      case 'transportasi':
        return Icons.directions_car;
      case 'utilitas':
        return Icons.home;
      case 'hiburan':
        return Icons.movie;
      case 'pendidikan':
        return Icons.school;
      default:
        return Icons.attach_money;
    }
  }

  void _showExpenseDetails(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: paleGreen,
            title: Text(expense.title, style: TextStyle(color: darkGreen)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jumlah: ${expense.formattedAmount}',
                  style: TextStyle(color: darkGreen),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kategori: ${expense.category}',
                  style: TextStyle(color: darkGreen),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tanggal: ${expense.formattedDate}',
                  style: TextStyle(color: darkGreen),
                ),
                const SizedBox(height: 8),
                Text(
                  'Deskripsi: ${expense.description}',
                  style: TextStyle(color: darkGreen),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Tutup', style: TextStyle(color: darkGreen)),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditExpenseScreen(expense: expense),
                    ),
                  );
                  setState(() {
                    filteredExpenses = ExpenseManager.expenses;
                  });
                },
                child: Text('Edit', style: TextStyle(color: brightGreen)),
              ),
              TextButton(
                onPressed: () {
                  ExpenseManager.deleteExpense(expense.id);
                  Navigator.pop(context);
                  setState(() {
                    filteredExpenses = ExpenseManager.expenses;
                  });
                },
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
