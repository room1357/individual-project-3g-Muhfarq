import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _expenses = FirebaseFirestore
      .instance
      .collection('expenses');

  /// 🟢 CREATE - tambah data baru
  Future<void> addExpense(Expense expense) async {
    try {
      // Gunakan doc() agar kita bisa tahu ID-nya kalau butuh
      final docRef = _expenses.doc();
      await docRef.set(expense.toMap()..['id'] = docRef.id);
    } catch (e) {
      rethrow; // biar bisa ditangkap di UI
    }
  }

  /// 🟡 READ - ambil semua data real-time
  Stream<List<Expense>> getExpenses() {
    return _expenses
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Expense.fromDoc(doc)).toList(),
        );
  }

  /// 🟣 UPDATE - update data berdasarkan ID
  Future<void> updateExpense(Expense expense) async {
    try {
      await _expenses.doc(expense.id).update(expense.toMap());
    } catch (e) {
      rethrow;
    }
  }

  /// 🔴 DELETE - hapus data berdasarkan ID
  Future<void> deleteExpense(String id) async {
    try {
      await _expenses.doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  /// 🔍 GET ONE - ambil 1 data berdasarkan ID
  Future<Expense?> getExpenseById(String id) async {
    try {
      final doc = await _expenses.doc(id).get();
      if (doc.exists) {
        return Expense.fromDoc(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
