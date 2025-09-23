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

  // Format jumlah uang
  String get formattedAmount => "Rp ${amount.toStringAsFixed(0)}";

  // Format tanggal dd/mm/yyyy
  String get formattedDate => "${date.day}/${date.month}/${date.year}";
}
