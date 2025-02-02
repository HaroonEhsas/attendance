import 'package:pdf/widgets.dart' as pw; // Only import what's needed

class PdfService {
  Future<void> generatePdfReport(List<Map<String, dynamic>> attendance) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text('Attendance Report', style: pw.TextStyle(fontSize: 24)),
                pw.SizedBox(height: 20),
                pw.TableHelper.fromTextArray( // Use TableHelper instead of Table
                  data: attendance.map((entry) => [
                    entry['employee_id'],
                    entry['check_in'],
                    entry['check_out'],
                  ]).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
    // Save or share the PDF
  }
}