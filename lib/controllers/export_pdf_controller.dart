import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense.dart';

class ExportPdfController {
  static final ExportPdfController _instance = ExportPdfController._internal();
  factory ExportPdfController() => _instance;
  ExportPdfController._internal();

  final _db = FirebaseFirestore.instance.collection('expenses');

  String formatCurrency(double amount) => amount
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );

  String formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  // 🧾 Generate PDF dari Firestore
  Future<pw.Document> generatePdf() async {
    final pdf = pw.Document();

    // 🔹 Ambil data dari Firestore
    final snapshot = await _db.orderBy('date', descending: true).get();
    final expenses = snapshot.docs.map((doc) => Expense.fromDoc(doc)).toList();

    if (expenses.isEmpty) {
      pdf.addPage(
        pw.Page(
          build: (_) => pw.Center(child: pw.Text('Tidak ada data pengeluaran')),
        ),
      );
      return pdf;
    }

    final total = expenses.fold(0.0, (s, e) => s + e.amount);
    final categoryTotals = <String, double>{};
    for (var e in expenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build:
            (_) => [
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
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey600,
                ),
              ),
              pw.Divider(),
              pw.SizedBox(height: 16),

              _sectionBox(
                title: 'TOTAL PENGELUARAN',
                content: 'Rp ${formatCurrency(total)}',
                subtitle: 'Total ${expenses.length} transaksi',
                color: PdfColors.blue50,
              ),
              pw.SizedBox(height: 20),

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
              pw.SizedBox(height: 20),
              pw.Text(
                'Detail Transaksi',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Table.fromTextArray(
                headers: ['Tanggal', 'Judul', 'Kategori', 'Jumlah'],
                data:
                    expenses
                        .map(
                          (e) => [
                            formatDate(e.date),
                            e.title,
                            e.category,
                            'Rp ${formatCurrency(e.amount)}',
                          ],
                        )
                        .toList(),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blue800,
                ),
                cellAlignment: pw.Alignment.centerLeft,
                cellStyle: const pw.TextStyle(fontSize: 10),
                columnWidths: {
                  0: const pw.FixedColumnWidth(70),
                  1: const pw.FixedColumnWidth(100),
                  2: const pw.FixedColumnWidth(80),
                  3: const pw.FixedColumnWidth(70),
                },
              ),
            ],
      ),
    );

    return pdf;
  }

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
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
        ],
      ),
    );
  }

  // 🔹 Handle export & snackbar
  Future<void> handleAction(String type, BuildContext context) async {
    final pdf = await generatePdf();
    final bytes = await pdf.save();
    final fileName =
        'laporan-pengeluaran-${DateFormat('yyyy-MM-dd').format(DateTime.now())}.pdf';

    try {
      switch (type) {
        case 'preview':
          await Printing.layoutPdf(onLayout: (_) async => bytes);
          break;
        case 'print':
          await Printing.layoutPdf(onLayout: (_) async => bytes);
          break;
        case 'share':
          await Printing.sharePdf(bytes: bytes, filename: fileName);
          break;
        case 'download':
          final directory = await getDownloadsDirectory();
          final path = '${directory!.path}/$fileName';
          final file = File(path);
          await file.writeAsBytes(bytes);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('PDF berhasil disimpan di: $path'),
                backgroundColor: Colors.green,
              ),
            );
          }
          break;
        default:
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Aksi tidak dikenali')),
            );
          }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
