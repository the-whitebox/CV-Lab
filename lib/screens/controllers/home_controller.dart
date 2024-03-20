// import 'dart:convert';
// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../../utils/constants.dart';
// import '../cv_templates/controllers/temp_controller.dart';
// import '../home_screen.dart';
//
// class   HomeController extends GetxController{
//
//
//   bool firstApiCalled=false;
//
//
//   Future<Map<String, dynamic>?> callUploadCVApi( String filePath, String jobDescriptionControllerForUploadCV) async {
//     try {
//       final url = Uri.parse('$baseUrl/api/process_data/');
//       var request = http.MultipartRequest('POST', url);
//
//       request.headers['Authorization'] = 'Bearer $token';
//
//       var file = File(filePath);
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'file_upload',
//           file.path,
//         ),
//       );
//       request.fields['job_description'] =
//           jobDescriptionControllerForUploadCV;
//
//       var response = await request.send();
//
//       if (response.statusCode == 200) {
//         firstApiCalled = true;
//         String apiResponse = await response.stream.bytesToString();
//
//         Map<String, dynamic> jsonResponse = json.decode(apiResponse);
//         cvObj = jsonResponse['cv_obj'];
//         print("Adnan this is CV Obj $cvObj");
//         return cvObj;
//       } else {
//         print(
//             'API call failed with status code ${response.statusCode} and response $response');
//
//         String apiResponse = await response.stream.bytesToString();
//         print(apiResponse);
//         return null;
//       }
//     } catch (e) {
//       print('Error in API call: $e');
//       return null;
//     }
//   }
// }