import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pemrograman_mobile/managers/expense_manager.dart';

class ExportPdfController {
  // 🔹 Singleton
  static final ExportPdfController _instance = ExportPdfController._internal();
  factory ExportPdfController() => _instance;
  ExportPdfController._internal();

  // 📦 Format Rupiah
  String formatCurrency(double amount) => amount
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  // 📅 Format tanggal
  String formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  // 🧾 Generate PDF
  Future<pw.Document> generatePdf() async {
    final pdf = pw.Document();
    final expenses = ExpenseManager.expenses;

    final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final categoryTotals = <String, double>{};

    for (var e in expenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build:
            (_) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'LAPORAN PENGELUARAN',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Dibuat pada: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
                ),
                pw.Divider(),
                pw.SizedBox(height: 16),

                // 🔹 Total ringkasan
                _sectionBox(
                  title: 'TOTAL PENGELUARAN',
                  content: 'Rp ${formatCurrency(total)}',
                  subtitle: 'Total ${expenses.length} transaksi',
                  color: PdfColors.blue50,
                ),
                pw.SizedBox(height: 20),

                // 🔹 Ringkasan kategori
                pw.Text(
                  'Ringkasan per Kategori',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                ...categoryTotals.entries.map(
                  (e) => pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(e.key),
                      pw.Text(
                        'Rp ${formatCurrency(e.value)}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      ),
    );

    return pdf;
  }

  // 🔹 Box komponen PDF
  pw.Widget _sectionBox({
    required String title,
    required String content,
    String? subtitle,
    PdfColor? color,
  }) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: color ?? PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            content,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.red700,
            ),
          ),
          if (subtitle != null)
            pw.Text(
              subtitle,
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
        ],
      ),
    );
  }

  // 🔹 Aksi export
  Future<void> handleAction(String type) async {
    final pdf = await generatePdf();
    final bytes = await pdf.save();
    final fileName =
        'laporan-pengeluaran-${DateFormat('yyyy-MM-dd').format(DateTime.now())}.pdf';

    switch (type) {
      case 'preview': // ✅ Preview PDF
        await Printing.layoutPdf(onLayout: (_) async => bytes);
        break;

      case 'print': // ✅ Cetak PDF
        await Printing.layoutPdf(onLayout: (_) async => bytes);
        break;

      case 'share': // ✅ Bagikan PDF
        await Printing.sharePdf(bytes: bytes, filename: fileName);
        break;

      case 'download': // ✅ Unduh PDF ke folder Downloads
        final directory = await getDownloadsDirectory();
        final path = '${directory!.path}/$fileName';
        final file = File(path);
        await file.writeAsBytes(bytes);
        print('✅ PDF disimpan di: $path');
        break;

      default:
        print("⚠️ Aksi '$type' tidak dikenali");
    }
  }
}
