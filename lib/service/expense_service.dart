import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExpenseService {
  final CollectionReference _db = FirebaseFirestore.instance.collection(
    'expenses',
  );

  /// 🟢 Tambah data baru
  Future<void> addExpense(Expense expense) async {
    try {
      await _db.add(expense.toMap());
    } catch (e) {
      rethrow; // lempar lagi biar bisa ditangkap di UI
    }
  }

  /// 🟡 Update data berdasarkan ID
  Future<void> updateExpense(Expense expense) async {
    try {
      await _db.doc(expense.id).update(expense.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// 🔴 Hapus data berdasarkan ID
  Future<void> deleteExpense(String id) async {
    try {
      await _db.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// 🔍 Ambil data berdasarkan kategori (real-time stream)
  Stream<List<Expense>> getExpensesByCategory(String category) {
    return _db
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Expense.fromDoc(doc)).toList(),
        );
  }

  /// 🔍 Ambil semua data (real-time stream)
  Stream<List<Expense>> getExpenses() {
    return _db
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Expense.fromDoc(doc)).toList(),
        );
  }

  /// 🔹 Ambil satu data berdasarkan ID (optional)
  Future<Expense?> getExpenseById(String id) async {
    try {
      final doc = await _db.doc(id).get();
      if (doc.exists) {
        return Expense.fromDoc(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
