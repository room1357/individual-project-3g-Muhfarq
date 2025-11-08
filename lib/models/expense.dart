import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? description;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });

  // 🔹 Format jumlah uang
  String get formattedAmount => "Rp ${amount.toStringAsFixed(0)}";

  // 🔹 Format tanggal dd/mm/yyyy
  String get formattedDate => "${date.day}/${date.month}/${date.year}";

  // 🔹 Convert ke Map untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': Timestamp.fromDate(date),
      'description': description ?? '',
    };
  }

  // 🔹 Convert dari DocumentSnapshot (ambil dari Firestore)
  factory Expense.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Expense(
      id: doc.id,
      title: data['title'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      description: data['description'] ?? '',
    );
  }
}
