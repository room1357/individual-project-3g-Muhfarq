import 'package:flutter/material.dart';
import 'add_expense_screen.dart';
import 'edit_expense_screen.dart';
import '../models/expense.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final List<Expense> _expenses = [];
  String? _selectedCategory; // filter kategori
  String _sortBy = "date"; // sorting (default: tanggal)

  void _addExpense(Expense expense) {
    setState(() {
      _expenses.add(expense);
    });
  }

  void _openAddExpenseScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(onSave: _addExpense),
      ),
    );
  }

  void _openEditExpenseScreen(Expense expense, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => EditExpenseScreen(
              expense: expense,
              onUpdate: (updatedExpense) {
                setState(() {
                  _expenses[index] = updatedExpense;
                });
              },
            ),
      ),
    );
  }

  //Filter dan sorting pengeluaran
  List<Expense> get _filteredExpenses {
    List<Expense> filtered =
        _selectedCategory == null
            ? _expenses
            : _expenses.where((e) => e.category == _selectedCategory).toList();

    if (_sortBy == "date") {
      filtered.sort((a, b) => b.date.compareTo(a.date)); // terbaru dulu
    } else if (_sortBy == "amount") {
      filtered.sort(
        (a, b) => b.amount.compareTo(a.amount),
      ); // nominal besar dulu
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pengeluaran"),
        backgroundColor: Colors.blue,
        actions: [
          // 🔹 Dropdown filter kategori
          DropdownButton<String>(
            value: _selectedCategory,
            hint: const Text("Kategori", style: TextStyle(color: Colors.white)),
            dropdownColor: Colors.white,
            underline: const SizedBox(),
            items:
                [
                      "Semua", // 🔹 Tambahkan opsi "Semua"
                      "Makan",
                      "Transport",
                      "Hiburan",
                      "Lainnya",
                    ]
                    .map(
                      (cat) => DropdownMenuItem(
                        value:
                            cat == "Semua"
                                ? null
                                : cat, // 🔹 null artinya tampilkan semua
                        child: Text(cat),
                      ),
                    )
                    .toList(),
            onChanged: (val) {
              setState(() => _selectedCategory = val);
            },
          ),

          // 🔹 PopupMenu sorting
          PopupMenuButton<String>(
            onSelected: (val) {
              setState(() => _sortBy = val);
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: "date",
                    child: Text("Urutkan: Tanggal"),
                  ),
                  const PopupMenuItem(
                    value: "amount",
                    child: Text("Urutkan: Nominal"),
                  ),
                ],
            icon: const Icon(Icons.sort, color: Colors.white),
          ),
        ],
      ),

      body:
          _filteredExpenses.isEmpty
              ? const Center(child: Text("Belum ada pengeluaran"))
              : ListView.builder(
                itemCount: _filteredExpenses.length,
                itemBuilder: (context, index) {
                  final exp = _filteredExpenses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.attach_money,
                        color: Colors.green,
                      ),
                      title: Text(exp.title),
                      subtitle: Text(
                        "${exp.category} - ${exp.date.day}/${exp.date.month}/${exp.date.year}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Rp ${exp.amount.toStringAsFixed(0)}"),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _openEditExpenseScreen(exp, index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpenseScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
