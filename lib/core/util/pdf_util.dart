import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfUtility {
  static Future<void> generateAndDownloadPDF(
      String studentName, String courseName, double score) async {
    print("Generating PDF for $studentName with score: $score");

    final pdf = pw.Document();
    final fontData = await rootBundle.load('lib/assets/fonts/Tajawal-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(base: ttf),
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.purple800),
              borderRadius: pw.BorderRadius.circular(20),
            ),
            padding: const pw.EdgeInsets.all(30),
            child: pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Center(
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text('شهادة إتمام الدورة', style: const pw.TextStyle(fontSize: 18)),
                    pw.SizedBox(height: 20),
                    pw.Text(studentName, style: const pw.TextStyle(fontSize: 18)),
                    pw.SizedBox(height: 10),
                    pw.Text(courseName, style: pw.TextStyle(font: ttf, fontSize: 18)),
                    pw.SizedBox(height: 10),
                    pw.Text('تهانينا على إتمام الدورة!', style: const pw.TextStyle(fontSize: 18)),
                    pw.SizedBox(height: 10),
                    pw.Text('الدرجة: $score', style: const pw.TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    final bytes = await pdf.save();
    await Printing.sharePdf(bytes: bytes, filename: 'certificate-$studentName.pdf');
  }
}
