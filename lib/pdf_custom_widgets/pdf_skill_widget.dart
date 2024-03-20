import 'package:crewdog_cv_lab/pdf_custom_widgets/pw_assets.dart';
import 'package:pdf/widgets.dart' as pw;



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
