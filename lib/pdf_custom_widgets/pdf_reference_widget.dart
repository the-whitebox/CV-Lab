import 'package:crewdog_cv_lab/pdf_custom_widgets/pw_assets.dart';
import 'package:pdf/widgets.dart' as pw;


class PdfReferenceWidget extends pw.StatelessWidget {
  final String personName;
  final String contactNumber;
  final String referenceText;

  PdfReferenceWidget({
    required this.personName,
    required this.contactNumber,
    required this.referenceText,
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
                personName,
                textAlign: pw.TextAlign.start,
                style: TextStylesPdf.bodyText12w600,
              ),
              pw.SizedBox(height: 3),
              pw.Text(contactNumber,
                  textAlign: pw.TextAlign.start, style: TextStylesPdf.bodyText11Simple),
              pw.SizedBox(height: 2),
              pw.Text(referenceText,
                  textAlign: pw.TextAlign.start, style: TextStylesPdf.bodyText12Simple),
              pw.SizedBox(height: 10)
            ])
    );
  }
}
