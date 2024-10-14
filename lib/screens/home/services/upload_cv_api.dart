import 'dart:convert';
import 'dart:io';
import 'package:crewdog_cv_lab/utils/app_functions.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../cv_templates/controllers/templates_controller.dart';
import '../../../utils/consts/api_consts.dart';
import 'package:http/http.dart' as http;
import '../components/change_description_dialog.dart';
import '../home_controller.dart';

Future callUploadCVApi({required VoidCallback onStateUpdate, required BuildContext context}) async {
  final HomeController controller = Get.find();
  try {
    final url = Uri.parse('$baseUrl/api/process_data/');
    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    var file = File(controller.filePath);
    request.files.add(await http.MultipartFile.fromPath('file_upload', file.path));
    request.fields['job_description'] = controller.jobDescriptionControllerForUploadCV.text;
    var response = await request.send();
    if (response.statusCode == 200) {
      String apiResponse = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = json.decode(apiResponse);
      if ( jsonResponse['result'] != null) {
        String resultMessage = jsonResponse['result'];
        if (resultMessage.contains("not relevent to job description")) {
          changeDescriptionDialog(context);
          controller.firstApiCalled = false;
          return null;
        }
        controller.firstApiCalled = false;
        return null;
      }
      else{
        controller.firstApiCalled = true;
        onStateUpdate();
        controller.cvObj = jsonResponse['cv_obj'];
        print("This is CV Obj ${controller.cvObj}");
        return controller.cvObj;}
    } else {
      customLog('Upload Cv API failed with status code ${response.statusCode}');
      return null;
    }
  } catch (e) {
    customLog('Error in Upload CV API : $e');
    return null;
  }
}
