import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import '../models/expense.dart';
import 'charts_screen.dart';
import 'package:flutter/material.dart';

class PdfExporter {
  static Future<void> generateAndExportPDF(List<Expense> expenses, GlobalKey chartKey) async {
    final pdf = pw.Document();

    // Calculate total expenditure
    double totalExpenditure = expenses.fold(0, (sum, expense) => sum + expense.amount);

    // Capture chart as image
    Uint8List? chartImage = await _captureChart(chartKey);

    // Create PDF content
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Budget Tracker Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Total Expenditure: \$${totalExpenditure.toStringAsFixed(2)}',
                style: pw.TextStyle(fontSize: 18, color: PdfColors.red)),
            pw.SizedBox(height: 10),
            pw.Text('Expense Details:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Divider(),

            // Expense list table
            pw.Table.fromTextArray(
              headers: ['Date', 'Title', 'Category', 'Amount'],
              data: expenses.map((e) => [e.date.toLocal().toString().split(' ')[0], e.title, e.category, '\$${e.amount.toStringAsFixed(2)}']).toList(),
            ),

            pw.SizedBox(height: 20),
            pw.Text('Expense Charts:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            if (chartImage != null)
              pw.Image(pw.MemoryImage(chartImage), height: 300, width: double.infinity, fit: pw.BoxFit.contain),
          ],
        ),
      ),
    );

    // Get directory to save file
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory?.path}/Budget_Tracker_Report.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Share the PDF
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'Budget_Tracker_Report.pdf');
  }

  static Future<Uint8List?> _captureChart(GlobalKey chartKey) async {
    RenderRepaintBoundary? boundary = chartKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;

    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}
