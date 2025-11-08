import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class LoopingExamples {
  // 🔥 Akses ke koleksi Firestore
  static final _db = FirebaseFirestore.instance.collection('expenses');

  /// 🔹 Ambil semua data dari Firestore dan hitung total
  static Future<double> calculateTotalFromFirestore() async {
    final snapshot = await _db.get();

    // Konversi dokumen jadi list of Expense
    final List<Expense> expenses =
        snapshot.docs.map((doc) => Expense.fromDoc(doc)).toList();

    // Hitung total amount
    double total = expenses.fold(0.0, (sum, e) => sum + e.amount);
    return total;
  }

  // =============================================================
  // 🔹 Fungsi versi lokal (pakai List<Expense>)
  // =============================================================

  static double calculateTotalTraditional(List<Expense> expenses) {
    double total = 0;
    for (int i = 0; i < expenses.length; i++) {
      total += expenses[i].amount;
    }
    return total;
  }

  static double calculateTotalForIn(List<Expense> expenses) {
    double total = 0;
    for (Expense expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  static double calculateTotalForEach(List<Expense> expenses) {
    double total = 0;
    expenses.forEach((e) => total += e.amount);
    return total;
  }

  static double calculateTotalFold(List<Expense> expenses) {
    return expenses.fold(0, (sum, e) => sum + e.amount);
  }

  static double calculateTotalReduce(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;
    return expenses.map((e) => e.amount).reduce((a, b) => a + b);
  }

  // 🔹 2. Cari item berdasarkan ID
  static Expense? findExpenseTraditional(List<Expense> expenses, String id) {
    for (var e in expenses) {
      if (e.id == id) return e;
    }
    return null;
  }

  static Expense? findExpenseWhere(List<Expense> expenses, String id) {
    try {
      return expenses.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  // 🔹 3. Filter berdasarkan kategori
  static List<Expense> filterByCategoryManual(
    List<Expense> expenses,
    String category,
  ) {
    List<Expense> result = [];
    for (var e in expenses) {
      if (e.category.toLowerCase() == category.toLowerCase()) {
        result.add(e);
      }
    }
    return result;
  }

  static List<Expense> filterByCategoryWhere(
    List<Expense> expenses,
    String category,
  ) {
    return expenses
        .where((e) => e.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
}
