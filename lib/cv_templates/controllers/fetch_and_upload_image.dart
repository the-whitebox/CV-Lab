import 'package:crewdog_cv_lab/cv_templates/controllers/upload_data_and_image.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../utils/constants.dart';


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
    print('Failed to fetch image');
    return '';
  }
}