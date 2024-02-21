import 'dart:convert';
import 'dart:io';
import 'package:crewdog_cv_lab/screens/saved_cv.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../custom_widgets/rotating_image.dart';
import '../routes/app_routes.dart';
import '../utils/constants.dart';
import 'cv_templates/controllers/temp_controller.dart';

List<String> pdfImages = [
  'assets/images/template/v101.png',
  'assets/images/template/v102.png',
  'assets/images/template/v103.png',
  'assets/images/template/v104.png',
  'assets/images/template/v105.png',
  'assets/images/template/v106.png',
];
List<String> pdfFiles = [
  AppRoutes.v101,
  AppRoutes.v102,
  AppRoutes.v103,
  AppRoutes.v104,
  AppRoutes.v105,
  AppRoutes.v106,
];

FilePickerResult? result;
int? tappedMyCVIndex;

final OutlineInputBorder _customBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: const BorderSide(
    color: kPurple,
    width: 1,
  ),
);

String responseFromUploadCVAPI = '';
String jobDescription = '';
List<String> messagesFromAPI = [];
List<String> messages = [];
List<Map<String, dynamic>> allMessages = [];

bool newMessage = false;

void updateMessages() {
  allMessages.clear();

  int apiIndex = 0;
  int userIndex = 0;

  while (apiIndex < messagesFromAPI.length || userIndex < messages.length) {
    if (apiIndex < messagesFromAPI.length) {
      allMessages.add({
        'message': messagesFromAPI[apiIndex],
        'isUser': false,
        //'timestamp': DateTime.now(),
      });
      apiIndex++;
    }

    if (userIndex < messages.length) {
      allMessages.add({
        'message': messages[userIndex],
        'isUser': true,
        // 'timestamp': DateTime.now(),
      });
      userIndex++;
    }
  }
  print('Updated Messages: $allMessages');
}

late Map<String, dynamic> cvObj;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String words = '';

  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  void startListening() async {
    await speechToText.listen(
      onResult: (result) {
        return onSpeechResult(result);
      },
    );
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _messageController.text = result.recognizedWords;
    });
  }

  void stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    updateMessages();

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_paws.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (messages.isEmpty && messagesFromAPI.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Expanded(
                            flex: 20,
                            child: Center(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.47,
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/home-upload.png',
                                                      width: 25,
                                                      height: 25,
                                                    ),
                                                    Text(
                                                      'Upload',
                                                      style: kFont14black600
                                                          .copyWith(
                                                              color: kPurple),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  'Upload your current CV\nor used a saved one.',
                                                  style: kFont12.copyWith(
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.47,
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/job.png',
                                                      width: 25,
                                                      height: 25,
                                                    ),
                                                    const Text(
                                                        'Job description',
                                                        style: kFont14black600)
                                                  ],
                                                ),
                                                Text(
                                                  'Copy and paste the job\ndescription',
                                                  style: kFont12.copyWith(
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.47,
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/template.png',
                                                      width: 25,
                                                      height: 25,
                                                    ),
                                                    Text(
                                                      'Choose template',
                                                      style: kFont14black600
                                                          .copyWith(
                                                              color:
                                                                  kHighlightedColor),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  'Review your new CV and\nchoose a template',
                                                  style: kFont12.copyWith(
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.47,
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(7.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/download-home.png',
                                                      width: 25,
                                                      height: 25,
                                                    ),
                                                    Text('Download',
                                                        style: kFont14black600
                                                            .copyWith(
                                                                color: kBlue))
                                                  ],
                                                ),
                                                Text(
                                                  'Now you can save or\ndownload it!',
                                                  style: kFont12.copyWith(
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 13),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 13),
                                        decoration: BoxDecoration(
                                          color: kLightPurple,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          'Do you want to upload a CV to customise it for a new role?',
                                          style: kFont10.copyWith(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4, top: 4),
                                        child: Image.asset(
                                          'assets/images/avatars/dogDP.png',
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showChangeUploadCVDialog(context);
                                  },
                                  style: kInitialChatButton,
                                  child: Text(
                                    'Upload CV',
                                    style:
                                        kFont10.copyWith(color: Colors.black),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    ///Todo:
                                    ///Todo:
                                    ///Todo:
                                    ///Todo:
                                    ///Todo:
                                    ///Todo:
                                    cvList = await fetchMyCVsData(token);

                                    // int cvId = cvList[index - 1]['cv']['id'];
                                    // String templateName = cvList[index - 1]['template']['name'];
                                    //buildMyCVsTab();
                                    _showUseMyCVDialog(context);
                                  },
                                  style: kInitialChatButton,
                                  child: Text(
                                    'Use My Saved CV\'s',
                                    style:
                                        kFont10.copyWith(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: allMessages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == allMessages.length) {
                          return buildAdditionalColumn();
                        } else {
                          return MessageBubble(
                            message: allMessages[index]['message'],
                            isUser: allMessages[index]['isUser'],
                          );
                        }
                      },
                    ),
                  ),
                SizedBox(
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Material(
                        color: kPurple,
                        borderRadius: BorderRadius.circular(5.0),
                        elevation: 5.0,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5.0),
                          onTap: () {
                            print('Messages: $messages');
                            print('API Messages: $messagesFromAPI');
                            setState(() {
                              messages.clear();
                              messagesFromAPI.clear();
                              allMessages.clear();
                            });
                            //messages = [];
                            print('Messages: $messages');
                            print('API Messages: $messagesFromAPI');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 11),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/add_icon_new_topic.png',
                                  height: 12,
                                  width: 12,
                                ),
                                const SizedBox(width: 2),
                                const Text(
                                  'New Topic',
                                  style: TextStyle(
                                      fontSize: 8, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: SizedBox(
                          height: 35,
                          child: TextField(
                            controller: _messageController,
                            style: kTextFieldTextStyle,
                            readOnly: false,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: const TextStyle(
                                  color: Color(0xFF95969D), fontSize: 12),
                              hintText: 'Hello, how can I help you...',
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 10,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFF1F1F1), width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFEBEBEB), width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  String message = _messageController.text;

                                  ///todo:chatAPI
                                  _messageController.text.isNotEmpty
                                      ? _chatApi(
                                          cvObj, jobDescription, message, token)
                                      : '';
                                  if (message.isNotEmpty) {
                                    // _chatApi(cvObj, jobDescription, message, token);
                                    setState(() {
                                      newMessage = true;
                                      messages.add(message);
                                      _messageController.clear();
                                    });
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeOut,
                                    );
                                  }
                                },
                                child: Image.asset(
                                  scale: 3.0,
                                  'assets/images/send.png',
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 2.0,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: speechToText.isListening
                                ? stopListening
                                : startListening,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: speechToText.isListening
                                    ? Colors.redAccent
                                    : Colors
                                        .transparent, // Change color when recording
                                boxShadow: speechToText.isListening
                                    ? [
                                        BoxShadow(
                                          color:
                                              Colors.redAccent.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 10,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/images/mic.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                          // child: InkWell(
                          //   borderRadius: BorderRadius.circular(50),
                          //   onTap: speechToText.isListening?stopListening:startListening,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child:  Image.asset(
                          //       'assets/images/mic.png',
                          //       width: 20,
                          //       height: 20,
                          //     ),
                          //   ),
                          // ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _chatApi(Map<String, dynamic> cvObj, String jobDescription,
      String userQuery, String token) async {
    final chatApiUrl = Uri.parse('https://api-cvlab.crewdog.ai/api/chat/');
    final client = http.Client();

    try {
      final response = await client.post(
        chatApiUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'cv': cvObj,
          'job_description': jobDescription,
          'user_query': userQuery,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        setState(() {
          messagesFromAPI.add(_formatMessage(responseBody));
          updateMessages();
          newMessage = false;
        });
      } else {
        print('Second API call failed with status code ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error in second API call: $e');
    } finally {
      client.close();
    }
  }

  String _formatMessage(Map<String, dynamic> response) {
    final StringBuffer formattedMessage = StringBuffer();

    // Add summary
    formattedMessage.writeln('Summary:');
    formattedMessage.writeln(response['personal_information']['summary']);
    formattedMessage.writeln();

    // Add personal info
    formattedMessage.writeln('Personal Info:');
    formattedMessage
        .writeln('Name: ${response['personal_information']['name']}');
    formattedMessage
        .writeln('Email: ${response['personal_information']['email']}');
    formattedMessage
        .writeln('Phone: ${response['personal_information']['phone']}');
    formattedMessage
        .writeln('Address: ${response['personal_information']['address']}');
    formattedMessage.writeln();

    // Add skills
    formattedMessage.writeln('Skills:');
    for (Map<String, dynamic> skill in response['skills']) {
      formattedMessage.writeln('• ${skill['name']}');
    }
    formattedMessage.writeln();

    // Add education
    formattedMessage.writeln('Education:');
    for (Map<String, dynamic> education in response['education']) {
      formattedMessage.writeln('Degree: ${education['degree']}');
      formattedMessage.writeln('Institute: ${education['institute']}');
      formattedMessage.writeln('City: ${education['city']}');
      formattedMessage.writeln('Country: ${education['country']}');
      formattedMessage.writeln('Start date: ${education['start_date']}');
      formattedMessage.writeln('End date: ${education['end_date']}');
      formattedMessage.writeln('Description: ${education['description']}');
      formattedMessage.writeln();
    }

    // Add employment history
    formattedMessage.writeln('Employment History:');
    for (Map<String, dynamic> employment in response['employment_history']) {
      formattedMessage.writeln('Position: ${employment['position']}');
      formattedMessage.writeln('Company: ${employment['company']}');
      formattedMessage.writeln('City: ${employment['city']}');
      formattedMessage.writeln('Country: ${employment['country']}');
      formattedMessage.writeln('Start date: ${employment['start_date']}');
      formattedMessage.writeln('End date: ${employment['end_date']}');
      formattedMessage.writeln('Description: ${employment['description']}');
      formattedMessage.writeln();
    }

    return formattedMessage.toString();
  }

  Future<void> _showChangeUploadCVDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const UploadCVDialog();
      },
    );
  }

  Future<void> _showUseMyCVDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const UseSaveCVDialog();
      },
    );
  }
}

class UploadCVDialog extends StatefulWidget {
  const UploadCVDialog({super.key});

  @override
  UploadCVDialogState createState() => UploadCVDialogState();
}

class UploadCVDialogState extends State<UploadCVDialog> {
  double _progress = 0.0;
  String _fileName = '';
  String _fileSize = '';
  String _filePath = '';
  String _timeRemaining = '';
  bool _fileUploaded = false;
  bool _isJobDescriptionEmpty = false;
  bool _isLoading = false;

  final TextEditingController _jobDescriptionControllerForUploadCV =
      TextEditingController();

  void _updateProgress() async {
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _progress = i / 100;
        _timeRemaining = '${(10 - i ~/ 10)} sec';
      });
    }
  }

  Future<void> _openGallery() async {
    // FilePickerResult?
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _fileName = result!.files.single.name;
        _fileSize = _formatFileSize(result!.files.single.size);
        _fileUploaded = true;
      });

      _updateProgress();

      _filePath = result!.files.single.path!;
      print('File Path: $_filePath');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(
          color: Colors.transparent,
          width: 1.0,
        ),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please upload CV',
                  style: kFont14Black.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                DottedBorder(
                  color: kPurple,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15.0,
                          ),
                          Image.asset(
                            'assets/images/upload.png',
                            height: 35,
                            width: 42,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'Upload your files here',
                            style: kFont12.copyWith(color: Colors.black),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await _openGallery();
                            },
                            child: Text(
                              'Browse',
                              style: kFont12.copyWith(
                                color: kPurple,
                                decoration: TextDecoration.underline,
                                decorationColor: kPurple,
                                decorationThickness: 2.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: !_fileUploaded,
                      child: const Text(
                        '  Upload CV',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const Text(
                      'DOC, DOCX, PDF',
                      style: kFont8Black,
                    ),
                  ],
                ),
                // const Divider(),
              ],
            ),
            Visibility(
              visible: _fileUploaded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _fileName,
                    style: kFont10.copyWith(color: Colors.black),
                  ),
                  Text(
                    _fileSize,
                    style: kFont8.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(
                        flex: 15,
                        child: LinearProgressIndicator(
                          minHeight: 1.5,
                          value: _progress,
                          backgroundColor: Colors.grey,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(kPurple),
                        ),
                      ),
                      Flexible(
                          flex: 1,
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            iconSize: 15,
                            onPressed: () {
                              setState(() {
                                result = null;
                                _fileUploaded = false;
                              });
                            },
                            icon: const Icon(Icons.cancel_outlined),
                          ))
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    'Time remaining: $_timeRemaining',
                    style: kFont7.copyWith(color: const Color(0xFF4E4949)),
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                ],
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Text(
              'Copy and paste job description',
              style: kFont14Black.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 5.0,
            ),
            TextFormField(
              controller: _jobDescriptionControllerForUploadCV,
              minLines: 2,
              enabled: true,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                enabledBorder: _customBorder,
                focusedBorder: _customBorder,
                errorBorder: _customBorder,
                focusedErrorBorder: _customBorder,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                hintText: 'Enter job description',
                hintStyle: kFadedText.copyWith(fontSize: 14),
                errorStyle: const TextStyle(
                  fontSize: 10,
                  color: Colors.red,
                ),
                errorText: _isJobDescriptionEmpty
                    ? 'Job description can\'t be empty'
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _isJobDescriptionEmpty = false;
                });
              },
            ),
            const SizedBox(height: 10.0),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 40,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      setState(() {});
                    },
                    style: kElevatedButtonWhiteOpacityBG,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Cancel',
                        style: kFont12.copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      _isJobDescriptionEmpty =
                          _jobDescriptionControllerForUploadCV.text.isEmpty;
                      if (!_isJobDescriptionEmpty) {
                        setState(() {
                          _isJobDescriptionEmpty = false;
                          _isLoading = true;
                        });
                      } else {
                        setState(() {
                          _isJobDescriptionEmpty = true;
                        });
                      }
                      if (_fileUploaded && !_isJobDescriptionEmpty) {
                        // Navigator.pop(context);
                        setState(() {
                          _fileUploaded = true;
                        });

                        // TODO: Call Upload CV API
                        await _callUploadCVApi();
                        // await MessageBubble(
                        //   message: responseFromUploadCVAPI,
                        //   isUser: false,
                        //   timestamp: DateTime.now(),
                        // );
                        Navigator.pop(context);
                      } else if (!_fileUploaded) {
                        setState(() {
                          _fileUploaded = false;
                        });
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    style: kElevatedButtonPrimaryBG,
                    child: Align(
                      alignment: Alignment.center,
                      child: _isLoading
                          ? const RotatingImage(
                              height: 30,
                              width: 30,
                            ) // Show loading indicator
                          : const Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Submit',
                                style: kFont12,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _callUploadCVApi() async {
    try {
      final url = Uri.parse('https://api-cvlab.crewdog.ai/api/process_data/');
      var request = http.MultipartRequest('POST', url);

      request.headers['Authorization'] = 'Bearer $token';

      var file = File(_filePath);
      request.files.add(
        await http.MultipartFile.fromPath(
          'file_upload',
          file.path,
        ),
      );
      request.fields['job_description'] =
          _jobDescriptionControllerForUploadCV.text;

      var response = await request.send();

      if (response.statusCode == 200) {
        print('API call successful');
        String apiResponse = await response.stream.bytesToString();
        print(apiResponse);

        Map<String, dynamic> jsonResponse = json.decode(apiResponse);

        cvObj = jsonResponse['cv_obj'];
        String summary = cvObj['personal_information']['summary'];

        List<Map<String, dynamic>> skillsList = (cvObj['skills'] as List)
            .map((skill) => Map<String, dynamic>.from(skill))
            .toList();

        List<Map<String, dynamic>> educationList = (cvObj['education'] as List)
            .map((education) => Map<String, dynamic>.from(education))
            .toList();

        List<Map<String, dynamic>> employmentHistoryList =
            (cvObj['employment_history'] as List)
                .map((employment) => Map<String, dynamic>.from(employment))
                .toList();

        List<Map<String, dynamic>> projectsList = (cvObj['projects'] as List)
            .map((project) => Map<String, dynamic>.from(project))
            .toList();

        setState(() {
          jobDescription = jsonResponse['job_description'];
        });

        String formattedMessage = _formatMessage(summary, cvObj, skillsList,
            educationList, employmentHistoryList, projectsList);
        print(formattedMessage);

        setState(() {
          messagesFromAPI.add(formattedMessage);
          updateMessages();
        });
      } else {
        print(
            'API call failed with status code ${response.statusCode} and response $response');
        print(await response.stream.bytesToString());
      }
    } catch (e) {
      print('Error in API call: $e');
    }
  }

  String _formatMessage(
      String summary,
      Map<String, dynamic> cvObj,
      List<Map<String, dynamic>> skillsList,
      List<Map<String, dynamic>> educationList,
      List<Map<String, dynamic>> employmentHistoryList,
      List<Map<String, dynamic>> projectsList) {
    final StringBuffer formattedMessage = StringBuffer();

    formattedMessage.writeln('Summary:');
    formattedMessage.writeln(summary);
    formattedMessage.writeln();

    formattedMessage.writeln('Personal Info:');
    formattedMessage.writeln('Name: ${cvObj['personal_information']['name']}');
    formattedMessage
        .writeln('Email: ${cvObj['personal_information']['email']}');
    formattedMessage
        .writeln('Phone: ${cvObj['personal_information']['phone']}');
    formattedMessage
        .writeln('Address: ${cvObj['personal_information']['address']}');
    formattedMessage.writeln();

    formattedMessage.writeln('Skills:');
    for (Map<String, dynamic> skill in skillsList) {
      formattedMessage.writeln('• ${skill['name']}');
    }
    formattedMessage.writeln();

    formattedMessage.writeln('Education:');
    for (Map<String, dynamic> education in educationList) {
      formattedMessage.writeln('Degree: ${education['degree']}');
      formattedMessage.writeln('Institute: ${education['institute']}');
      formattedMessage.writeln('City: ${education['city']}');
      formattedMessage.writeln('Country: ${education['country']}');
      formattedMessage.writeln('Start date: ${education['start_date']}');
      formattedMessage.writeln('End date: ${education['end_date']}');
      formattedMessage.writeln('Description: ${education['description']}');
      formattedMessage.writeln();
    }

    formattedMessage.writeln('Employment History:');
    for (Map<String, dynamic> employment in employmentHistoryList) {
      formattedMessage.writeln('Position: ${employment['position']}');
      formattedMessage.writeln('Company: ${employment['company']}');
      formattedMessage.writeln('City: ${employment['city']}');
      formattedMessage.writeln('Country: ${employment['country']}');
      formattedMessage.writeln('Start date: ${employment['start_date']}');
      formattedMessage.writeln('End date: ${employment['end_date']}');
      formattedMessage.writeln('Description: ${employment['description']}');
      formattedMessage.writeln();
    }

    formattedMessage.writeln('Projects:');
    for (Map<String, dynamic> project in projectsList) {
      formattedMessage.writeln('Project Name: ${project['project_name']}');
      formattedMessage.writeln('Description: ${project['description']}');
    }

    formattedMessage.writeln();

    formattedMessage.writeln('Job Description:');
    formattedMessage.writeln(jobDescription);

    return formattedMessage.toString();
  }

  String _formatFileSize(int bytes) {
    const sizes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int i = 0;
    double fileSize = bytes.toDouble();

    while (fileSize > 1024) {
      fileSize /= 1024;
      i++;
    }

    return '${fileSize.toStringAsFixed(2)} ${sizes[i]}';
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    // required this.timestamp
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                  decoration: BoxDecoration(
                    color: isUser ? kLightOrange : kLightPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message,
                    style: kFont10.copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: Align(
                alignment: isUser ? Alignment.topRight : Alignment.topLeft,
                child: Image.asset(
                  isUser
                      ? 'assets/images/avatar.png'
                      : 'assets/images/avatars/dogDP.png',
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class UseSaveCVDialog extends StatefulWidget {
  const UseSaveCVDialog({super.key});

  @override
  UseSaveCVDialogState createState() => UseSaveCVDialogState();
}

class UseSaveCVDialogState extends State<UseSaveCVDialog> {
  final TextEditingController _jobDescriptionControllerForSavedCV =
      TextEditingController();
  bool _isJobDescriptionForSavedCVEmpty = false;

  int? tappedIndex;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(
          color: Colors.transparent,
          width: 1.0,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600.0,
            maxHeight: screenHeight * 0.8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Select a CV',
                  style: kFont14Black.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              ///todo: show a gridview builder to show saved cvs
              SizedBox(
                height: screenHeight * 0.22,
                width: screenWidth * 0.8,
                child: Container(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.01,
                    left: screenWidth * 0.04,
                    right: screenWidth * 0.04,
                  ),
                  child: cvList.isEmpty
                      ? const Center(
                          child: Text(
                            'You have not saved any CV yet',
                            style: kFont14Black,
                          ),
                        )
                      : GridView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.4,
                            crossAxisCount: 1,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: cvList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final templateName =
                                cvList[index]['template']['name'];
                            final lastDigit = int.tryParse(templateName
                                    .substring(templateName.length - 1)) ??
                                1;
                            final templateIndex = lastDigit - 1;

                            if (templateIndex >= 0 &&
                                templateIndex < pdfImages.length) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tappedIndex = index; // Set the tapped index
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              pdfImages[templateIndex]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    if (tappedIndex == index)
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Handle update button press
                                          },
                                          style: kElevatedButtonPrimaryBG,
                                          child: const Text(
                                            'Select',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            } else {
                              return Container(
                                padding: const EdgeInsets.all(8.0),
                                color: kHighlightedColor,
                                child: const Center(
                                  child: Text(
                                    'Invalid template version',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Copy and paste job description',
                  style: kFont14Black.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: _jobDescriptionControllerForSavedCV,
                  minLines: 2,
                  enabled: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    enabledBorder: _customBorder,
                    focusedBorder: _customBorder,
                    errorBorder: _customBorder,
                    focusedErrorBorder: _customBorder,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    hintText: 'Enter job description',
                    hintStyle: kFadedText.copyWith(fontSize: 14),
                    errorStyle: const TextStyle(
                      fontSize: 10,
                      color: Colors.red,
                    ),
                    errorText: _isJobDescriptionForSavedCVEmpty
                        ? 'Job description can\'t be empty'
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isJobDescriptionForSavedCVEmpty = false;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 40,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _isJobDescriptionForSavedCVEmpty =
                              _jobDescriptionControllerForSavedCV.text.isEmpty;
                          if (!_isJobDescriptionForSavedCVEmpty) {
                            setState(() {
                              _isJobDescriptionForSavedCVEmpty = false;
                            });
                          } else {
                            setState(() {
                              _isJobDescriptionForSavedCVEmpty = true;
                            });
                          }
                          if (!_isJobDescriptionForSavedCVEmpty) {
                            // Navigator.pop(context);
                            setState(() {
                              ///Todo: cv selected
                            });

                            // TODO: Call Saved CV API

                            Navigator.pop(context);
                          }
                          // else if (!_fileUploaded) {
                          //   setState(() {
                          //     _fileUploaded = false;
                          //   });
                          // }

                          // Navigator.pop(context);
                          // setState(() {});
                        },
                        style: kElevatedButtonWhiteOpacityBG,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: kFont12.copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_jobDescriptionControllerForSavedCV
                              .text.isEmpty) {
                            return;
                          }
                          Navigator.pop(context);
                          setState(() {});
                        },
                        style: kElevatedButtonPrimaryBG,
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Submit',
                            style: kFont12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildAdditionalColumn() {
  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) state) {
      return !newMessage
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 13),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 13),
                          decoration: BoxDecoration(
                            color: kLightPurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Do you want to choose a template now?',
                            style: kFont10.copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          'assets/images/avatars/dogDP.png',
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      //_showChangeUploadCVDialog(context);

                      state(() {
                        messages.clear();
                        messagesFromAPI.clear();
                        allMessages.clear();
                      });

                      print('Messages: $messages');
                      print('API Messages: $messagesFromAPI');
                    },
                    style: kInitialChatButton,
                    child: Text(
                      'No',
                      style: kFont10.copyWith(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      ///todo: move to saved_cv bottom tab
                    },
                    style: kInitialChatButton,
                    child: Text(
                      'Yes',
                      style: kFont10.copyWith(color: Colors.black),
                    ),
                  ),
                ),
              ],
            )
          : Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/gifs/dogAfterBone.gif',
                    height: 100.0,
                    width: 150.0,
                  ),
                  const Text('fetching data...'),
                ],
              ),
            );
    },
  );
}
