import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/controllers/export_pdf_controller.dart';

class ExportPdfScreen extends StatelessWidget {
  const ExportPdfScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ExportPdfController();

    return Scaffold(
      backgroundColor: const Color(0xFFDCFDEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B5A3D),
        title: const Text(
          'Export PDF',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
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
              color: const Color(0xFF1DC981),
              bgColor: const Color(0xFFABEFCA),
              onTap: () => controller.handleAction('preview'),
            ),
            _buildExportOption(
              icon: Icons.print,
              title: 'Cetak PDF',
              color: const Color(0xFF0B5A3D),
              bgColor: const Color(0xFFABEFCA),
              onTap: () => controller.handleAction('print'),
            ),
            _buildExportOption(
              icon: Icons.share,
              title: 'Bagikan PDF',
              color: const Color(0xFF1DC981),
              bgColor: const Color(0xFFABEFCA),
              onTap: () => controller.handleAction('share'),
            ),
            _buildExportOption(
              icon: Icons.download,
              title: 'Unduh PDF',
              color: const Color(0xFF0B5A3D),
              bgColor: const Color(0xFFABEFCA),
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
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Card(
      color: bgColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: const Color(0xFF1DC981).withValues(alpha: 0.2),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF0B5A3D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
