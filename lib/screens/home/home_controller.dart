import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../utils/app_functions.dart';

class HomeController extends GetxController {
  FilePickerResult? result;
  int? tappedMyCVIndex;
  String responseFromUploadCVAPI = '';
  String jobDescription = '';
  List<String> messagesFromAPI = [];
  List<String> messages = [];
  List<Map<String, dynamic>> allMessages = [];
  bool newMessage = false;
  bool errorInChatApi = false;
  String errorApiMessage = 'Oops! Something went wrong on our end. Please give us a moment to fix it. Feel free to try again.';
  Map<String, dynamic> cvObj = {};
  Map<String, dynamic> chatCvObj = {};
  bool firstApiCalled = false;
  bool secondApiCalled = true;
  String selectButton = 'Select';
  bool isCVSelected = false;
  bool cvNotSelected = false;
  bool isJobDescriptionForSavedCVEmpty = false;
  final TextEditingController jobDescriptionControllerForSavedCV = TextEditingController();
  final TextEditingController jobDescriptionControllerForUploadCV = TextEditingController();
  int? tappedIndex;
  double progress = 0.0;
  String fileName = '';
  String fileSize = '';
  String filePath = '';
  String timeRemaining = '';
  bool fileUploaded = false;
  bool cvNotUploaded = false;
  bool isJobDescriptionEmpty = false;
  bool isLoading = false;
  bool isSubmitPressed = false;
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String words = '';
  final TextEditingController messageController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  String imageFromApi = "";

  void updateMessages() {
    allMessages.clear();
    int apiIndex = 0;
    int userIndex = 0;
    while (apiIndex < messagesFromAPI.length || userIndex < messages.length) {
      if (apiIndex < messagesFromAPI.length) {
        allMessages.add({'message': messagesFromAPI[apiIndex], 'isUser': false});
        apiIndex++;
      }
      if (userIndex < messages.length) {
        allMessages.add({'message': messages[userIndex], 'isUser': true});
        userIndex++;
      }
    }
  }

  Future openGallery({required VoidCallback onStateUpdate}) async {
    result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);

    if (result != null) {
      fileName = result!.files.single.name;
      fileSize = formatFileSize(result!.files.single.size);
      fileUploaded = true;
      onStateUpdate();
      filePath = result!.files.single.path!;
      customLog('File Path: $filePath');
      return true;
    } else {
      return false;
    }
  }

  void refreshResponse() {
    customLog("Refresh Response");
    messages.clear();
    messagesFromAPI.clear();
    allMessages.clear();
    cvObj.clear();
    chatCvObj.clear();
    messageController.clear();
    focusNode.unfocus();
    jobDescriptionControllerForUploadCV.clear();
    result = null;
    fileUploaded = false;
    imageFromApi = "";
  }

  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
  }

  void stopListening({required VoidCallback stateUpdate}) async {
    await speechToText.stop();
    stateUpdate();
  }

  void startListening({required VoidCallback stateUpdate}) async {
    if (cvObj.isNotEmpty || chatCvObj.isNotEmpty) {
      await speechToText.listen(onResult: (result) {
        messageController.text = result.recognizedWords;
        stateUpdate();
      });
      stateUpdate();
    }
  }
}
