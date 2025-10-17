import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/controllers/export_pdf_controller.dart';

class ExportPdfScreen extends StatelessWidget {
  const ExportPdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ExportPdfController(); 

    return Scaffold(
      appBar: AppBar(title: const Text('Export PDF')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildExportOption(
              icon: Icons.picture_as_pdf,
              title: 'Tampilkan PDF',
              color: Colors.blue,
              onTap: () => controller.handleAction('preview'),
            ),
            _buildExportOption(
              icon: Icons.print,
              title: 'Cetak PDF',
              color: Colors.green,
              onTap: () => controller.handleAction('print'),
            ),
            _buildExportOption(
              icon: Icons.share,
              title: 'Bagikan PDF',
              color: Colors.orange,
              onTap: () => controller.handleAction('share'),
            ),
            _buildExportOption(
              icon: Icons.download,
              title: 'Unduh PDF',
              color: Colors.purple,
              onTap: () => controller.handleAction('download'),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget kartu opsi export
  Widget _buildExportOption({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
