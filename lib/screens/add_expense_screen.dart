import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';
import '../managers/category_manager.dart';
import '../models/category.dart';
// import 'package:uuid/uuid.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Category? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  // 🔹 Firestore reference
  final _firestore = FirebaseFirestore.instance.collection('expenses');

  // 🎨 Tema warna
  final Color darkGreen = const Color(0xFF0B5A3D);
  final Color paleGreen = const Color(0xFFDCFDEB);
  final Color lightBox = const Color(0xFFE9FFF3);
  final Color brightGreen = const Color(0xFF1DC981);

  @override
  void initState() {
    super.initState();
    if (CategoryManager.categories.isNotEmpty) {
      _selectedCategory = CategoryManager.categories.first;
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      final newExpense = Expense(
        id: '',
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        category: _selectedCategory!.name,
        date: _selectedDate,
        description: _descriptionController.text,
      );

      await _firestore.add(newExpense.toMap());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: paleGreen,
      appBar: AppBar(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tambah Pengeluaran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildInputField(
                controller: _titleController,
                label: 'Judul',
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Masukkan judul'
                            : null,
              ),
              const SizedBox(height: 12),
              _buildInputField(
                controller: _amountController,
                label: 'Jumlah',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan jumlah';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildDropdownField(),
              const SizedBox(height: 12),
              _buildDatePickerField(context),
              const SizedBox(height: 12),
              _buildInputField(
                controller: _descriptionController,
                label: 'Deskripsi',
                maxLines: 3,
              ),
              const SizedBox(height: 28),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: TextStyle(color: darkGreen, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: darkGreen.withValues(alpha: 0.6)),
        filled: true,
        fillColor: lightBox,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<Category>(
      value: _selectedCategory,
      items:
          CategoryManager.categories
              .map(
                (cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(
                    cat.name,
                    style: TextStyle(
                      color: darkGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
      onChanged: (cat) => setState(() => _selectedCategory = cat),
      decoration: InputDecoration(
        hintText: 'Pilih kategori',
        hintStyle: TextStyle(color: darkGreen.withValues(alpha: 0.6)),
        filled: true,
        fillColor: lightBox,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
      validator: (value) => value == null ? 'Pilih kategori' : null,
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: lightBox,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: TextStyle(color: darkGreen, fontWeight: FontWeight.w500),
            ),
            Icon(Icons.calendar_today, color: darkGreen),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveExpense,
      style: ElevatedButton.styleFrom(
        backgroundColor: brightGreen,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 3,
      ),
      child: const Text(
        'Simpan',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
