import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> requestPermissions() async {
  var status = await Permission.storage.status;
  print('###Status$status');
  final permissionStatus = await Permission.storage.request();
  print('###PermissionStatus$permissionStatus');
}

Future<void> makePdf(List<pw.Widget> widget, String templateName) async {
  const double marginTop = 2.0 * 72.0 / 2.54;
  const double marginBottom = 2.0 *30.0 / 2.54;
  const double marginLeft = 2.0 * 72.0 / 2.54;
  const double marginRight = 2.0 * 72.0 / 2.54;
  final pdf = pw.Document();
  pdf.addPage(
    pw.MultiPage(
      margin:  const pw.EdgeInsets.fromLTRB(marginLeft, marginTop, marginRight, marginBottom),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => widget),
  );

  Directory? directoryPath;
  if (Platform.isAndroid) {
    directoryPath = Directory('/storage/emulated/0/Download');

    // Put file in global download folder, if it didn't exist, fallback to getExternalStorageDirectory
    if (!await directoryPath.exists()) {
      directoryPath = await getExternalStorageDirectory();
    }
  } else {
    directoryPath = await getApplicationDocumentsDirectory();
  }

  final downloadsDirectory = Directory(directoryPath!.path);
  final file = File('${downloadsDirectory.path}/$templateName.pdf');
  await file.writeAsBytes(await pdf.save());

  // final Directory? directoryPath;
  // if (Platform.isAndroid) {
  //   directoryPath = await getExternalStorageDirectory();
  // } else {
  //   directoryPath = await getApplicationDocumentsDirectory();
  // }
  // final file = File('${directoryPath!.path}/$templateName.pdf');
  // await file.writeAsBytes(await pdf.save());
}

final emailRegex = RegExp(
  r'^[\w-]+(\.[\w-]+)*@[A-Za-z0-9]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})$',
);

bool isValidEmail(String email) {
  return emailRegex.hasMatch(email);
}

final RegExp passwordContainsAlphabeticAndSpecial = RegExp(
  r'^(?=.*[a-zA-Z])(?=.*[!@#$%^&*(),.?":{}|<>])[a-zA-Z0-9!@#$%^&*(),.?":{}|<>]+$',
);

bool isPasswordValid(String password) {
  return passwordContainsAlphabeticAndSpecial.hasMatch(password);
}

bool isNameValid(String name) {
  RegExp regex = RegExp(r'^[a-zA-Z ]+$');
  return regex.hasMatch(name);
}

Future<bool> isInternetConnected() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}
