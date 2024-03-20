import 'package:crewdog_cv_lab/pdf_custom_widgets/pw_assets.dart';
import 'package:pdf/widgets.dart' as pw;


class PdfEducationHistoryWidget extends pw.StatelessWidget {
  final String title;
  final String instituteName;
  final String country;
  final String city;
  final String from;
  final String till;
  final pw.TextStyle durationFontStyle;
  final String description;

  PdfEducationHistoryWidget({
    required this.instituteName,
    required this.country,
    required this.city,
    required this.description,
    required this.title,
    required this.from,
    required this.till,
    required this.durationFontStyle,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      width: 360,
      child: pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Wrap(
                children: [
                  pw.Text("$title from ", style: TextStylesPdf.bodyText12w600),
                  pw.Text("$instituteName, ", style: TextStylesPdf.bodyText12w600),
                  pw.Text("$city, ", style: TextStylesPdf.bodyText12w600),
                  pw.Text(country, style: TextStylesPdf.bodyText12w600),
                ]
            ),
            pw.SizedBox(height: 3.0),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(from, style: durationFontStyle),
                pw.Text(' - ', style: durationFontStyle),
                pw.Text(till, style: durationFontStyle),
                pw.Expanded(flex: 10, child: pw.SizedBox())
              ],
            ),
            pw.SizedBox(height: 3.0),
            pw.Text(description, style: TextStylesPdf.bodyText12Simple),
            pw.SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
