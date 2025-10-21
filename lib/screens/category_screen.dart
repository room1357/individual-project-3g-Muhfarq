import 'package:flutter/material.dart';
import '../managers/category_manager.dart';
import '../models/category.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _controller = TextEditingController();

  // 🎨 Warna sesuai tema aplikasi
  final Color darkGreen = const Color(0xFF0B5A3D);
  final Color lightGreen = const Color(0xFFABEFCA);
  final Color paleGreen = const Color(0xFFDCFDEB);
  final Color brightGreen = const Color(0xFF1DC981);

  void _addCategory() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    // 🔹 Cegah duplikat kategori
    final exists = CategoryManager.categories.any(
      (cat) => cat.name.toLowerCase() == name.toLowerCase(),
    );
    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kategori sudah ada!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 🔹 Tambah kategori baru
    final newCategory = Category(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );

    setState(() {
      CategoryManager.addCategory(newCategory);
      _controller.clear();
    });

    // 🔹 Notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kategori "$name" berhasil ditambahkan!'),
        backgroundColor: brightGreen,
      ),
    );
  }

  void _removeCategory(String id) {
    setState(() {
      CategoryManager.removeCategory(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = CategoryManager.categories;

    return Scaffold(
      backgroundColor: paleGreen,
      appBar: AppBar(
        backgroundColor: darkGreen,
        title: const Text(
          'Daftar Kategori',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 Input tambah kategori
            Container(
              decoration: BoxDecoration(
                color: lightGreen.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.black87),
                      decoration: const InputDecoration(
                        hintText: 'Masukkan nama kategori baru...',
                        hintStyle: TextStyle(color: Colors.black54),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _addCategory(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: brightGreen,
                      size: 28,
                    ),
                    onPressed: _addCategory,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade300),

            // 🔹 List kategori
            Expanded(
              child:
                  categories.isEmpty
                      ? Center(
                        child: Text(
                          'Belum ada kategori',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                category.name,
                                style: TextStyle(
                                  color: darkGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                onPressed: () => _removeCategory(category.id),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),

      // 🔹 Tombol tambah cepat (opsional)
      floatingActionButton: FloatingActionButton(
        backgroundColor: brightGreen,
        onPressed: _addCategory,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
