import 'dart:convert';
import 'package:crewdog_cv_lab/utils/app_functions.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import '../../../utils/consts/api_consts.dart';
import '../home_controller.dart';
import 'package:http/http.dart' as http;
import 'format_message.dart';

Future chatApi(
    {required Map cvObj,
    required String jobDescription,
    required String userQuery,
    required String token,
    required VoidCallback onStateUpdate}) async {
  final HomeController controller = Get.find();
  final chatApiUrl = Uri.parse('$baseUrl/api/chat/');
  final client = http.Client();
  try {
    controller.secondApiCalled = true;
    final chatResponse = await client.post(chatApiUrl,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({'cv': cvObj, 'job_description': jobDescription, 'user_query': userQuery}));
    if (chatResponse.statusCode == 200) {
      onStateUpdate();
      controller.firstApiCalled = false;
      controller.secondApiCalled = false;
      customLog('Chat API successful');
      String responseBody = chatResponse.body;
      Map<String, dynamic>? jsonResponse = json.decode(responseBody);
      if (jsonResponse != null) {
        controller.chatCvObj = jsonResponse;
        onStateUpdate();
        String summary = jsonResponse['personal_information']?['summary'] ?? 'Summary not found';
        controller.imageFromApi = jsonResponse['personal_information']?['profile_pic'] ?? "";

        List skillsList = [];
        if (jsonResponse['skills'] != null) {
          skillsList = (jsonResponse['skills'] as List).map((skill) => Map<String, dynamic>.from(skill)).toList();
        }
        List educationList = [];
        if (jsonResponse['education'] != null) {
          educationList = (jsonResponse['education'] as List).map((education) => Map<String, dynamic>.from(education)).toList();
        }

        List employmentHistoryList = [];
        if (jsonResponse['employment_history'] != null) {
          employmentHistoryList =
              (jsonResponse['employment_history'] as List).map((employment) => Map<String, dynamic>.from(employment)).toList();
        }

        List projectsList = [];
        if (jsonResponse['projects'] != null) {
          projectsList = (jsonResponse['projects'] as List).map((project) => Map<String, dynamic>.from(project)).toList();
        }

        jobDescription = jsonResponse['job_description'] ?? '';
        String formattedMessage =
            formatMessageDetails(summary, jsonResponse, skillsList, educationList, employmentHistoryList, projectsList);
        controller.messagesFromAPI.add(formattedMessage);
        controller.updateMessages();
        controller.newMessage = false;
        controller.errorInChatApi = false;
        onStateUpdate();
      } else {
        customLog('No valid response received in Chat Api');
      }
    } else {
      controller.secondApiCalled = false;
      controller.firstApiCalled = false;
      controller.errorInChatApi = true;
      controller.messagesFromAPI.add(controller.errorApiMessage);
      controller.updateMessages();
      onStateUpdate();
      customLog('Chat API failed with status code ${chatResponse.statusCode}');
    }
  } catch (e) {
    controller.secondApiCalled = false;
    controller.firstApiCalled = false;
    controller.errorInChatApi = true;
    controller.messagesFromAPI.add(controller.errorApiMessage);
    controller.updateMessages();
    onStateUpdate();
    customLog('Error in chat API call: $e');
  } finally {
    controller.secondApiCalled = false;
    controller.firstApiCalled = false;
    onStateUpdate();
    client.close();
  }
}
