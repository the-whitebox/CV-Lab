import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/app_functions.dart';
import '../../utils/consts/api_consts.dart';

Future<String> uploadDataAndImage(
    XFile imageToUpload,
    String token,
    String template,
    String userId,
    ) async {
  try {
    List<int> imageBytes = await imageToUpload.readAsBytes();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/save/picture/'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['user'] = userId;
    request.fields['template'] = template;

    request.files.add(http.MultipartFile(
      'picture',
      http.ByteStream.fromBytes(imageBytes),
      imageBytes.length,
      filename: 'cv_image.jpg',
      contentType: MediaType('image', 'jpeg'),
    ));
    var response = await request.send();

    if (response.statusCode == 201) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> responseData = jsonDecode(responseBody);

      if (responseData.containsKey('picture_path')) {
        String picturePath = responseData['picture_path'];
        customLog('Picture path: $picturePath');
        return picturePath;
      } else {
        customLog('Failed to get "picture_path" from the response.');
        return "null";
      }
    } else {
      customLog('Failed to upload image. Status code: ${response.statusCode}');
      customLog('Response: ${await response.stream.bytesToString()}');
      return "null";
    }
  } catch (e) {
    customLog('Error uploading data and image: $e');
    return "null";
  }
}