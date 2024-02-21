import 'package:crewdog_cv_lab/custom_widgets/pw_assets.dart';
import 'package:pdf/widgets.dart' as pw;


class PdfEmploymentHistoryWidget extends pw.StatelessWidget {
  final String title;
  final String companyName;
  final String country;
  final String city;
  final String from;
  final String till;
  final pw.TextStyle durationFontStyle;
  final String description;

  PdfEmploymentHistoryWidget({
    required this.companyName,
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
      width: 370,
      child: pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Wrap(
              children: [
                pw.Text("$title at ", style: TextStylesPdf.bodyText12w600),
                pw.Text("$companyName, ", style: TextStylesPdf.bodyText12w600),
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
      width: 370,
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
    return pw.Column(
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
        ]);
  }
}

class PdfProjectWidget extends pw.StatelessWidget {
  final String title;
  final String description;

  PdfProjectWidget({
    required this.title,
    required this.description,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
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
        ]);
  }
}



class PdfSkillCircullarWidget extends pw.StatelessWidget {
  final String skill;
  final double leftPadding;

  PdfSkillCircullarWidget({
    this.skill = "Lorem Ipsum is simply",
    this.leftPadding=15,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.SizedBox(
        width: 150,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.SizedBox(width: leftPadding),
            pw.Container(
              width: 4,
              height: 4,
              decoration: pw.BoxDecoration(
                shape: pw.BoxShape.circle,
                color: AppPdfColor.pdfGreyColorE49,
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: pw.Text(
                skill,
                style: TextStylesPdf.bodyText12Simple,
              ),
            )
          ],
        ));
  }
}
