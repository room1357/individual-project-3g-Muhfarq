import '../models/expense.dart';

class ExpenseManager {
  // 🔹 Hitung total pengeluaran per kategori
  static Map<String, double> getTotalByCategory(List<Expense> expenses) {
    final Map<String, double> result = {};
    for (var expense in expenses) {
      result[expense.category] =
          (result[expense.category] ?? 0) + expense.amount;
    }
    return result;
  }

  // 🔹 Pengeluaran tertinggi
  static Expense? getHighestExpense(List<Expense> expenses) {
    if (expenses.isEmpty) return null;
    return expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  // 🔹 Filter pengeluaran berdasarkan bulan
  static List<Expense> getExpensesByMonth(
    List<Expense> expenses,
    int month,
    int year,
  ) {
    return expenses
        .where((e) => e.date.month == month && e.date.year == year)
        .toList();
  }

  // 🔹 Cari berdasarkan keyword
  static List<Expense> searchExpenses(List<Expense> expenses, String keyword) {
    final lower = keyword.toLowerCase();
    return expenses.where((e) {
      return e.title.toLowerCase().contains(lower) ||
          (e.description ?? '').toLowerCase().contains(lower) ||
          e.category.toLowerCase().contains(lower);
    }).toList();
  }

  // 🔹 Rata-rata pengeluaran harian
  static double getAverageDaily(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;
    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final uniqueDays =
        expenses
            .map((e) => '${e.date.year}-${e.date.month}-${e.date.day}')
            .toSet();
    return total / uniqueDays.length;
  }
}
