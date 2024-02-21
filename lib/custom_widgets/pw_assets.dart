import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' as srv;

class PwAssets {
  static late Uint8List personImage;
  static late Uint8List bagImage;
  static late Uint8List hatImage;
  static late Uint8List speakerImage;
  static late Uint8List phoneImage;
  static late Uint8List locationImage;
  static late Uint8List cv1Image;
  static late Uint8List cv2Image;
  static late Uint8List cv4Image;
  static late Uint8List cv5Image;
  static late Uint8List cvDemoImage;

  static Future<void> initializeAssets() async {
    personImage = (await rootBundle.load('assets/images/person.png'))
        .buffer
        .asUint8List();
    bagImage =
        (await rootBundle.load('assets/images/bag.png')).buffer.asUint8List();
    hatImage =
        (await rootBundle.load('assets/images/hat.png')).buffer.asUint8List();
    speakerImage = (await rootBundle.load('assets/images/speaker.png'))
        .buffer
        .asUint8List();
    phoneImage =
        (await rootBundle.load('assets/images/phone.png')).buffer.asUint8List();
    locationImage = (await rootBundle.load('assets/images/location.png'))
        .buffer
        .asUint8List();
    cv1Image = (await rootBundle.load('assets/images/profiles/temp1.png'))
        .buffer
        .asUint8List();
    cv2Image = (await rootBundle.load('assets/images/profiles/temp2.png'))
        .buffer
        .asUint8List();
    cv4Image = (await rootBundle.load('assets/images/profiles/temp4.png'))
        .buffer
        .asUint8List();
    cv5Image = (await rootBundle.load('assets/images/profiles/temp5.png'))
        .buffer
        .asUint8List();
    cvDemoImage = (await rootBundle.load('assets/images/icon-profile.png'))
        .buffer
        .asUint8List();
  }
}

class PwFonts {
  static late pw.Font ttf;
  static late pw.Font ttf500;
  static late pw.Font ttf600;
  static late pw.Font ttf700;

  static Future<void> initializeFonts() async {
    final ByteData data400 =
        await srv.rootBundle.load('fonts/Inter-Regular.ttf');
    final ByteData data500 =
        await srv.rootBundle.load('fonts/Inter-Medium.ttf');
    final ByteData data600 =
        await srv.rootBundle.load('fonts/Inter-SemiBold.ttf');
    final ByteData data700 = await srv.rootBundle.load('fonts/Inter-Bold.ttf');
    final Uint8List fontData400 = data400.buffer.asUint8List();
    final Uint8List fontData500 = data500.buffer.asUint8List();
    final Uint8List fontData600 = data600.buffer.asUint8List();
    final Uint8List fontData700 = data700.buffer.asUint8List();

    ttf = pw.Font.ttf(fontData400.buffer.asByteData());
    ttf500 = pw.Font.ttf(fontData500.buffer.asByteData());
    ttf600 = pw.Font.ttf(fontData600.buffer.asByteData());
    ttf700 = pw.Font.ttf(fontData700.buffer.asByteData());
  }
}

class AppPdfColor{
  static PdfColor pdfGreyColorE49=const PdfColor.fromInt(0XFF4E4949);
  static PdfColor pdfGreyColor87=const PdfColor.fromInt(0XFF878787);
  static PdfColor pdfDividerColor=const PdfColor.fromInt(0XFFE1E1E1);
  static PdfColor pdfDividerColor2 =const PdfColor.fromInt(0XFFE1E1E1);
  static PdfColor textHeadingColor = const PdfColor.fromInt(0XFF033144);
  static PdfColor textRedColor = const PdfColor.fromInt(0XFFFD8023);

}

class TextStylesPdf {
  static pw.TextStyle bodyText10Simple = pw.TextStyle(
    fontSize: 10,
    font: PwFonts.ttf,
    color: AppPdfColor.pdfGreyColor87,
  );
  static pw.TextStyle bodyText10SimpleBlack = pw.TextStyle(
    fontSize: 10,
    font: PwFonts.ttf,
    color: AppPdfColor.pdfGreyColorE49,
  );



  static pw.TextStyle bodyText10w500 = pw.TextStyle(
    fontSize: 10,
    font: PwFonts.ttf500,
    color: AppPdfColor.pdfGreyColorE49,
  );
  static pw.TextStyle bodyText11Simple = pw.TextStyle(
    fontSize: 11,
    font: PwFonts.ttf,
    color: AppPdfColor.pdfGreyColorE49,
  );
  static pw.TextStyle bodyText11SimpleGrey = pw.TextStyle(
    fontSize: 11,
    font: PwFonts.ttf,
    color: AppPdfColor.pdfGreyColor87,
  );



  static pw.TextStyle bodyText12Simple =  pw.TextStyle(
    fontSize: 12,
    font: PwFonts.ttf,
    color: AppPdfColor.pdfGreyColorE49,
  );
  static pw.TextStyle bodyText12SimpleGrey =  pw.TextStyle(
    fontSize: 12,
    font: PwFonts.ttf,
    color: AppPdfColor.pdfGreyColor87,
  );

  static pw.TextStyle bodyText12w500 =  pw.TextStyle(
    fontSize: 12,
    font: PwFonts.ttf600,
    color: AppPdfColor.pdfGreyColorE49,
  );
  static pw.TextStyle bodyText12w600 =  pw.TextStyle(
    fontSize: 12,
    font: PwFonts.ttf600,
    color: AppPdfColor.pdfGreyColorE49,
  );

  static pw.TextStyle bodyText14w500 =  pw.TextStyle(
    fontSize: 14,
    font: PwFonts.ttf500,
    color: AppPdfColor.pdfGreyColorE49,
  );
  static pw.TextStyle headingText14w600 = pw.TextStyle(
    color: AppPdfColor.pdfGreyColorE49,
    fontSize: 14,
    font: PwFonts.ttf600,
  );
  static pw.TextStyle headingText14w700 = pw.TextStyle(
    color: AppPdfColor.pdfGreyColorE49,
    fontSize: 14,
    font: PwFonts.ttf600,
  );

  static pw.TextStyle headingText15w600 = pw.TextStyle(
    color: AppPdfColor.pdfGreyColorE49,
    fontSize: 15,
    font: PwFonts.ttf600,
  );
  static pw.TextStyle headingText16w700 = pw.TextStyle(
    color: AppPdfColor.pdfGreyColorE49,
    fontSize: 16,
    font: PwFonts.ttf700,
  );
  static pw.TextStyle headingText20w500 = pw.TextStyle(
    color: AppPdfColor.pdfGreyColorE49,
    fontSize: 20,
    font: PwFonts.ttf500,
  );
  static pw.TextStyle headingText20w600 = pw.TextStyle(
    color: AppPdfColor.pdfGreyColorE49,
    fontSize: 20,
    font: PwFonts.ttf600,
  );

  static pw.TextStyle headingText20w700 = pw.TextStyle(
    color: AppPdfColor.pdfGreyColorE49,
    fontSize: 20,
    font: PwFonts.ttf700,
  );

  static pw.TextStyle headingText22w700 = pw.TextStyle(
    color: AppPdfColor.pdfGreyColorE49,
    fontSize: 22,
    font: PwFonts.ttf700,
  );

}
