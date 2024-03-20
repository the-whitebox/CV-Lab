import 'package:crewdog_cv_lab/pdf_custom_widgets/pw_assets.dart';
import 'package:pdf/widgets.dart' as pw;


class PdfProjectWidget extends pw.StatelessWidget {
  final String title;
  final String description;

  PdfProjectWidget({
    required this.title,
    required this.description,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.SizedBox(
        width: 360,
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Text(
                title,
                textAlign: pw.TextAlign.start,
                style: TextStylesPdf.bodyText12w600,
              ),
              pw.SizedBox(height: 3),
              pw.Text(description,
                  textAlign: pw.TextAlign.start, style: TextStylesPdf.bodyText12Simple),
              pw.SizedBox(height: 10)
            ])
    );
  }
}
