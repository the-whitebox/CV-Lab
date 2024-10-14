import 'package:crewdog_cv_lab/cv_templates/functions/upload_data_and_image.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../utils/app_functions.dart';
import '../../utils/consts/api_consts.dart';


Future<String> fetchAndUploadImage(
    {
      required String token,
      required String templateId,
      required String userId,
      required String cvImagePath,
    }
    ) async {
  http.Response res = await http.get(Uri.parse(ssoUrl+cvImagePath));
  if (res.statusCode == 200) {
    Uint8List bytes = res.bodyBytes;
    XFile imageFile = XFile.fromData(bytes);
    String cvImagePathAfterUpload = await uploadDataAndImage(
      imageFile,
      token,
      templateId,
      userId,
    );
    cvImagePathAfterUpload='/media/$cvImagePathAfterUpload';
    return cvImagePathAfterUpload;
  } else {
    customLog('Failed to fetch image');
    return '';
  }
}