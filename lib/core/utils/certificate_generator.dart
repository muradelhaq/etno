import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../shared/models/user_progress_model.dart';

class CertificateGenerator {
  static Future<Uint8List> generatePdf(UserProgressModel progress) async {
    final pdf = pw.Document();
    final fontHeading = await PdfGoogleFonts.plusJakartaSansBold();
    final fontBody = await PdfGoogleFonts.nunitoRegular();
    final fontBold = await PdfGoogleFonts.nunitoBold();

    final dateStr = DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(24),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              border: pw.Border.all(color: PdfColor.fromHex('#2D6A4F'), width: 4),
              borderRadius: pw.BorderRadius.circular(16),
            ),
            child: pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColor.fromHex('#DDA15E'), width: 1.5),
                borderRadius: pw.BorderRadius.circular(10),
              ),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Header
                  pw.Column(
                    children: [
                      pw.Text(
                        'SERTIFIKAT KELULUSAN E-MODUL',
                        style: pw.TextStyle(
                          font: fontHeading,
                          fontSize: 22,
                          color: PdfColor.fromHex('#1B4332'),
                          letterSpacing: 1.5,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'ETNOSAINS: MAKANAN TRADISIONAL BERBASIS FERMENTASI',
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 12,
                          color: PdfColor.fromHex('#BC6C25'),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),

                  // Recipient
                  pw.Column(
                    children: [
                      pw.Text(
                        'Diberikan dengan bangga kepada:',
                        style: pw.TextStyle(
                          font: fontBody,
                          fontSize: 12,
                          color: PdfColors.grey700,
                          fontStyle: pw.FontStyle.italic,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        progress.studentName.toUpperCase(),
                        style: pw.TextStyle(
                          font: fontHeading,
                          fontSize: 24,
                          color: PdfColor.fromHex('#1B4332'),
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        '${progress.studentClass}  •  ${progress.studentSchool}',
                        style: pw.TextStyle(
                          font: fontBold,
                          fontSize: 11,
                          color: PdfColor.fromHex('#2D6A4F'),
                        ),
                      ),
                      pw.Container(
                        width: 250,
                        height: 1.5,
                        color: PdfColor.fromHex('#2D6A4F'),
                        margin: const pw.EdgeInsets.symmetric(vertical: 4),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 40),
                        child: pw.Text(
                          'Telah berhasil menyelesaikan seluruh rangkaian modul pembelajaran rekonstruksi sains kearifan lokal (Tempe, Tape Singkong, Tauco, Kecap, dan Oncom) serta evaluasi literasi sains berstandar PISA.',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                            font: fontBody,
                            fontSize: 11,
                            color: PdfColors.grey800,
                            lineSpacing: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Achievement Badges Row
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMetricBox(
                        'Skor Literasi Sains (PISA)',
                        '${progress.quizScore}/100',
                        fontBold,
                        fontBody,
                      ),
                      _buildMetricBox(
                        'Indeks Kesadaran Budaya',
                        '${progress.culturalAwarenessScore.toStringAsFixed(0)}%',
                        fontBold,
                        fontBody,
                      ),
                      _buildMetricBox(
                        'Total XP Gamifikasi',
                        '${progress.earnedXP} XP',
                        fontBold,
                        fontBody,
                      ),
                    ],
                  ),

                  // Footer & Signatures
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Tanggal Penerbitan: $dateStr',
                              style: pw.TextStyle(font: fontBody, fontSize: 10, color: PdfColors.grey700)),
                          pw.Text('Kode Verifikasi: ETNO-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                              style: pw.TextStyle(font: fontBody, fontSize: 9, color: PdfColors.grey600)),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.Text(
                            'Tim Pengembang E-Modul Etnosains',
                            style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColor.fromHex('#1B4332')),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            'Media Pembelajaran Biologi Berbasis Kearifan Lokal',
                            style: pw.TextStyle(font: fontBody, fontSize: 9, color: PdfColors.grey600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildMetricBox(
    String label,
    String value,
    pw.Font fontBold,
    pw.Font fontBody,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#FEFAE0'),
        border: pw.Border.all(color: PdfColor.fromHex('#DDA15E'), width: 1),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 16,
              color: PdfColor.fromHex('#2D6A4F'),
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            label,
            style: pw.TextStyle(
              font: fontBody,
              fontSize: 9,
              color: PdfColors.grey700,
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> printCertificate(UserProgressModel progress) async {
    final pdfBytes = await generatePdf(progress);
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: 'Sertifikat_Etnosains_${progress.studentName.replaceAll(' ', '_')}.pdf',
    );
  }
}
