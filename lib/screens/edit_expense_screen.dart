import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../managers/expense_manager.dart';
import '../managers/category_manager.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();

  // 🎨 Palet warna
  final Color darkGreen = const Color(0xFF0B5A3D);
  final Color paleGreen = const Color(0xFFDCFDEB);
  final Color lightBox = const Color(0xFFE9FFF3); // lebih terang dari paleGreen
  final Color brightGreen = const Color(0xFF1DC981);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.expense.title);
    _amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.expense.description,
    );
    _selectedCategory = widget.expense.category;
    _selectedDate = widget.expense.date;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final index = ExpenseManager.expenses.indexWhere(
        (e) => e.id == widget.expense.id,
      );
      if (index != -1) {
        ExpenseManager.expenses[index] = Expense(
          id: widget.expense.id,
          title: _titleController.text,
          amount: double.parse(_amountController.text),
          category: _selectedCategory!,
          date: _selectedDate,
          description: _descriptionController.text,
        );
      }
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
          'Edit Pengeluaran',
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
                            ? 'Judul tidak boleh kosong'
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
                    return 'Jumlah tidak boleh kosong';
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

  // 🔹 Input Field tanpa border
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

  // 🔹 Dropdown tanpa border
  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory,
      items:
          CategoryManager.categories
              .map(
                (category) => DropdownMenuItem(
                  value: category.name,
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: darkGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
      onChanged: (value) => setState(() => _selectedCategory = value),
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
      validator:
          (value) => value == null || value.isEmpty ? 'Pilih kategori' : null,
    );
  }

  // 🔹 Date Picker tanpa border dan tanpa text dummy
  Widget _buildDatePickerField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
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

  // 🔹 Tombol Simpan
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
