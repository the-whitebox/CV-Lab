import 'dart:convert';
import 'dart:io';
import 'package:crewdog_cv_lab/screens/saved_cv.dart';
import 'package:crewdog_cv_lab/utils/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../custom_widgets/bubble_message.dart';
import '../custom_widgets/rotating_image.dart';
import '../routes/app_routes.dart';
import '../utils/app_snackbar.dart';
import '../utils/constants.dart';
import 'bottom_bar/bottom_nav_bar.dart';
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
String responseFromUploadCVAPI = '';
String jobDescription = '';
List<String> _messagesFromAPI = [];
List<String> _messages = [];
List<Map<String, dynamic>> _allMessages = [];
bool _newMessage = false;
bool _errorInChatApi = false;
String _errorApiMessage =
    'Oops! Something went wrong on our end. Please give us a moment to fix it. Feel free to try again.';
Map<String, dynamic> cvObj = {};
Map<String, dynamic> chatCvObj = {};
bool _firstApiCalled = false;
bool _secondApiCalled = true;
String _selectButton = 'Select';
bool _isCVSelected = false;
bool _cvNotSelected = false;
bool _isJobDescriptionForSavedCVEmpty = false;
final TextEditingController _jobDescriptionControllerForSavedCV =
    TextEditingController();
final TextEditingController _jobDescriptionControllerForUploadCV =
    TextEditingController();
int? _tappedIndex;
double _progress = 0.0;
String _fileName = '';
String _fileSize = '';
String _filePath = '';
String _timeRemaining = '';
bool _fileUploaded = false;
bool _isJobDescriptionEmpty = false;
bool _isLoading = false;
bool _isSubmitPressed = false;
SpeechToText speechToText = SpeechToText();
bool speechEnabled = false;
String words = '';
final TextEditingController _messageController = TextEditingController();
final FocusNode _focusNode = FocusNode();
final ScrollController _scrollController = ScrollController();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  final tempController = Get.put(TempController());



  @override
  void initState() {
    super.initState();
    initSpeech();
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
                if (_messages.isEmpty &&
                    _messagesFromAPI.isEmpty &&
                    !_firstApiCalled)
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.47,
                                        child: Card(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2, vertical: 4),
                                          color: Colors.white,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
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
                                                      style: kFont13black500
                                                          .copyWith(
                                                              color: kPurple),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  'Upload your current CV\nor used a saved one.',
                                                  style: kFont11.copyWith(
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
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2, vertical: 4),
                                          color: Colors.white,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
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
                                                        style: kFont13black500)
                                                  ],
                                                ),
                                                Text(
                                                  'Copy and paste the job description',
                                                  style: kFont11.copyWith(
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
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2, vertical: 4),
                                          color: Colors.white,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
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
                                                      style: kFont13black500
                                                          .copyWith(
                                                              color:
                                                                  kHighlightedColor),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  'Review your new CV and\nchoose a template',
                                                  style: kFont11.copyWith(
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
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2, vertical: 4),
                                          color: Colors.white,
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
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
                                                        style: kFont13black500
                                                            .copyWith(
                                                                color: kBlue))
                                                  ],
                                                ),
                                                Text(
                                                  'Now you can save or\ndownload it!',
                                                  style: kFont11.copyWith(
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
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2),
                                          child: Text(
                                            'Let\'s fine-tune your CV for a new role.\nPlease choose:',
                                            style: kFont10.copyWith(
                                                color: Colors.black),
                                          ),
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
                                    _jobDescriptionControllerForUploadCV
                                        .clear();
                                    _isJobDescriptionEmpty = false;
                                    result = null;
                                    _fileUploaded = false;
                                    showDialog<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (context, state) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                side: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                ),
                                              ),
                                              backgroundColor: Colors.white,
                                              titlePadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Please upload CV',
                                                    style:
                                                        kFont14Black.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: const Icon(
                                                        Icons.close_rounded,
                                                        size: 16),
                                                  )

                                                ],
                                              ),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        DottedBorder(
                                                          color: kPurple,
                                                          borderType:
                                                              BorderType.RRect,
                                                          radius: const Radius
                                                              .circular(10),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10),
                                                            ),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  1,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                color: Colors
                                                                    .transparent,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height:
                                                                        15.0,
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
                                                                    style: kFont12
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.black),
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      bool
                                                                          checkFileUploaded =
                                                                          await _openGallery();
                                                                      state(() {
                                                                        _fileUploaded =
                                                                            checkFileUploaded;
                                                                      });
                                                                      void
                                                                          updateProgress() async {
                                                                        for (int i =
                                                                                0;
                                                                            i <=
                                                                                100;
                                                                            i +=
                                                                                10) {
                                                                          await Future.delayed(
                                                                              const Duration(milliseconds: 100));
                                                                          state(
                                                                              () {
                                                                            _progress =
                                                                                i / 100;
                                                                            _timeRemaining =
                                                                                '${(10 - i ~/ 10)} sec';
                                                                          });
                                                                        }
                                                                      }

                                                                      updateProgress();
                                                                    },
                                                                    child: Text(
                                                                      'Browse',
                                                                      style: kFont12
                                                                          .copyWith(
                                                                        color:
                                                                            kPurple,
                                                                        decoration:
                                                                            TextDecoration.underline,
                                                                        decorationColor:
                                                                            kPurple,
                                                                        decorationThickness:
                                                                            2.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height:
                                                                        15.0,
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
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Visibility(
                                                              visible:
                                                                  !_fileUploaded,
                                                              child: const Text(
                                                                '  Upload CV',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                            const Text(
                                                              'DOC, DOCX, PDF',
                                                              style:
                                                                  kFont8Black,
                                                            ),
                                                          ],
                                                        ),
                                                        // const Divider(),
                                                      ],
                                                    ),
                                                    Visibility(
                                                      visible: _fileUploaded,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Transform.translate(
                                                            offset:
                                                                const Offset(
                                                                    0.0, 15.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  _fileName,
                                                                  style: kFont10
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                                Text(
                                                                  _fileSize,
                                                                  style: kFont8
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                flex: 100,
                                                                child:
                                                                    LinearProgressIndicator(
                                                                  minHeight:
                                                                      1.5,
                                                                  value:
                                                                      _progress,
                                                                  backgroundColor:
                                                                      kPurple,
                                                                  valueColor: _progress ==
                                                                          1.0
                                                                      ? const AlwaysStoppedAnimation<
                                                                              Color>(
                                                                          Colors
                                                                              .green)
                                                                      : const AlwaysStoppedAnimation<
                                                                              Color>(
                                                                          kHighlightedColor),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 13,
                                                                child:
                                                                    IconButton(
                                                                  highlightColor:
                                                                      Colors
                                                                          .transparent,
                                                                  iconSize: 20,
                                                                  onPressed:
                                                                      () {
                                                                    state(() {
                                                                      result =
                                                                          null;
                                                                      _fileUploaded =
                                                                          false;
                                                                    });
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .cancel_outlined),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Transform.translate(
                                                            offset:
                                                                const Offset(
                                                                    0.0, -15.0),
                                                            child: Text(
                                                              'Time remaining: $_timeRemaining',
                                                              style: kFont7
                                                                  .copyWith(
                                                                color: const Color(
                                                                    0xFF4E4949),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Text(
                                                      'Job description',
                                                      style:
                                                          kFont14Black.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    TextFormField(
                                                      controller:
                                                          _jobDescriptionControllerForUploadCV,
                                                      minLines: 2,
                                                      enabled: true,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      maxLines: null,
                                                      decoration:
                                                          InputDecoration(
                                                        enabledBorder:
                                                            customBorderHome,
                                                        focusedBorder:
                                                            customBorderHome,
                                                        errorBorder:
                                                            customBorderHome,
                                                        focusedErrorBorder:
                                                            customBorderHome,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10.0,
                                                        ),
                                                        hintText:
                                                            'Enter job description',
                                                        hintStyle:
                                                            kFadedText.copyWith(
                                                                fontSize: 14),
                                                        errorStyle:
                                                            const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.red,
                                                        ),
                                                        errorText:
                                                            _isJobDescriptionEmpty
                                                                ? 'Job description can\'t be empty'
                                                                : null,
                                                      ),
                                                      onChanged: (value) {
                                                        state(() {
                                                          _isJobDescriptionEmpty =
                                                              false;
                                                        });
                                                      },
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          const SizedBox(
                                                            width: 40,
                                                          ),
                                                          IgnorePointer(
                                                            ignoring:
                                                                _isSubmitPressed,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              style:
                                                                  kElevatedButtonWhiteOpacityBG,
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: kFont12
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 4,
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              _isSubmitPressed =
                                                                  true;
                                                              _isJobDescriptionEmpty =
                                                                  _jobDescriptionControllerForUploadCV
                                                                      .text
                                                                      .isEmpty;
                                                              if (!_isJobDescriptionEmpty) {
                                                                state(() {
                                                                  _isJobDescriptionEmpty =
                                                                      false;
                                                                  _isLoading =
                                                                      true;
                                                                });
                                                              } else {
                                                                state(() {
                                                                  _isJobDescriptionEmpty =
                                                                      true;
                                                                  _isSubmitPressed =
                                                                      false;
                                                                });
                                                              }
                                                              if (_fileUploaded &&
                                                                  !_isJobDescriptionEmpty) {
                                                                state(() {
                                                                  _fileUploaded =
                                                                      true;
                                                                });

                                                                if (await isInternetConnected()) {
                                                                  await _callUploadCVApi();
                                                                  state(() {
                                                                    _firstApiCalled =
                                                                        true;
                                                                    _isSubmitPressed =
                                                                        false;
                                                                  });
                                                                  if (cvObj
                                                                      .isNotEmpty) {
                                                                    state(() {
                                                                      _firstApiCalled =
                                                                          true;
                                                                    });
                                                                    Get.back();
                                                                    _chatApi(
                                                                        cvObj,
                                                                        jobDescription,
                                                                        '',
                                                                        token);
                                                                  }
                                                                } else {
                                                                  appSnackBar(
                                                                      "Error",
                                                                      "No internet connectivity");
                                                                }
                                                              } else if (!_fileUploaded) {
                                                                state(() {
                                                                  _fileUploaded =
                                                                      false;
                                                                });
                                                              }
                                                              state(() {
                                                                _isLoading =
                                                                    false;
                                                              });
                                                            },
                                                            style:
                                                                kElevatedButtonPrimaryBG,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: _isLoading
                                                                  ? const RotatingImage(
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                    )
                                                                  : const Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Text(
                                                                        'Submit',
                                                                        style:
                                                                            kFont12,
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
                                          },
                                        );
                                      },
                                    );
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
                                    _isLoading = false;
                                    _isJobDescriptionForSavedCVEmpty = false;
                                    _isCVSelected = false;
                                    _cvNotSelected = true;
                                    _selectButton = 'Select';
                                    _jobDescriptionControllerForSavedCV.clear();
                                    _tappedIndex = null;
                                    cvList = await fetchMyCVsData(token);

                                    showDialog(
                                      builder: (BuildContext context) {
                                        final screenHeight =
                                            MediaQuery.of(context).size.height;
                                        final screenWidth =
                                            MediaQuery.of(context).size.width;
                                        return StatefulBuilder(
                                            builder: (context, state) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                side: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 1.0,
                                                )),
                                            contentPadding: EdgeInsets.zero,
                                            backgroundColor: Colors.white,
                                            content: SingleChildScrollView(
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 600.0,
                                                  maxHeight: screenHeight * 0.8,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const SizedBox(
                                                        height: 10.0),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    16.0),
                                                        child: Text(
                                                            'Select a CV',
                                                            style: kFont14Black
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ))),
                                                    SizedBox(
                                                        height:
                                                            screenHeight * 0.3,
                                                        width:
                                                            screenWidth * 0.8,
                                                        child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                              top:
                                                                  screenHeight *
                                                                      0.01,
                                                              left:
                                                                  screenWidth *
                                                                      0.04,
                                                              right:
                                                                  screenWidth *
                                                                      0.04,
                                                            ),
                                                            child: cvList
                                                                    .isEmpty
                                                                ? const Center(
                                                                    child: Text(
                                                                      'You have not saved any CV yet',
                                                                      style:
                                                                          kFont14Black,
                                                                    ),
                                                                  )
                                                                : GridView
                                                                    .builder(
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        shrinkWrap:
                                                                            true,
                                                                        gridDelegate:
                                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                                          childAspectRatio:
                                                                              1.8,
                                                                          crossAxisCount:
                                                                              1,
                                                                          crossAxisSpacing:
                                                                              8.0,
                                                                          mainAxisSpacing:
                                                                              8.0,
                                                                        ),
                                                                        itemCount:
                                                                            cvList
                                                                                .length,
                                                                        itemBuilder:
                                                                            (BuildContext context,
                                                                                int index) {
                                                                          final title =
                                                                              cvList[index]['username'];
                                                                          final templateName =
                                                                              cvList[index]['template']['name'];
                                                                          int cvId =
                                                                              cvList[index]['cv']['id'];
                                                                          final lastDigit =
                                                                              int.tryParse(templateName.substring(templateName.length - 1)) ?? 1;
                                                                          final templateIndex =
                                                                              lastDigit - 1;

                                                                          if (templateIndex >= 0 &&
                                                                              templateIndex < pdfImages.length) {
                                                                            return Column(children: [
                                                                              GestureDetector(
                                                                                  onTap: () {
                                                                                    state(() {
                                                                                      _selectButton = 'Select';
                                                                                      _tappedIndex = index;
                                                                                    });
                                                                                  },
                                                                                  child: Stack(children: [
                                                                                    Container(
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                                                                                      child: Image.asset(pdfImages[templateIndex]),
                                                                                    ),
                                                                                    if (_tappedIndex == index)
                                                                                      Center(
                                                                                          child: Column(children: [
                                                                                        SizedBox(
                                                                                          height: screenHeight * 0.1,
                                                                                        ),
                                                                                        ElevatedButton(
                                                                                            onPressed: () async {
                                                                                              state(() {
                                                                                                _selectButton = 'Selected';
                                                                                                _isCVSelected = true;
                                                                                                _cvNotSelected = false;
                                                                                              });
                                                                                              chatCvObj = (await tempController.fetchCvObjectFromBackend(cvId, templateName))!;
                                                                                            },
                                                                                            style: kElevatedButtonPrimaryBG,
                                                                                            child: Text(_selectButton, style: const TextStyle(color: Colors.white)))
                                                                                      ]))
                                                                                  ])),
                                                                              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                                                                const Text(
                                                                                  'Title: ',
                                                                                ),
                                                                                Expanded(child: Text(title, maxLines: 2, style: const TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w500)))
                                                                              ])
                                                                            ]);
                                                                          } else {
                                                                            return Container(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                color: kHighlightedColor,
                                                                                child: const Center(child: Text('Invalid template version', style: TextStyle(color: Colors.white))));
                                                                          }
                                                                        }))),
                                                    Row(children: [
                                                      const SizedBox(
                                                        width: 25.0,
                                                      ),
                                                      Visibility(
                                                        visible: _cvNotSelected,
                                                        child: const Text(
                                                          'CV must be selected',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 10.0),
                                                        ),
                                                      ),
                                                    ]),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16,
                                                          vertical: 5),
                                                      child: Text(
                                                        'Job description',
                                                        style: kFont14Black
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.0),
                                                      child: TextFormField(
                                                          controller:
                                                              _jobDescriptionControllerForSavedCV,
                                                          minLines: 2,
                                                          enabled: true,
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          maxLines: null,
                                                          decoration:
                                                              InputDecoration(
                                                            enabledBorder:
                                                                customBorderHome,
                                                            focusedBorder:
                                                                customBorderHome,
                                                            errorBorder:
                                                                customBorderHome,
                                                            focusedErrorBorder:
                                                                customBorderHome,
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 10.0,
                                                              horizontal: 10.0,
                                                            ),
                                                            hintText:
                                                                'Enter job description',
                                                            hintStyle: kFadedText
                                                                .copyWith(
                                                                    fontSize:
                                                                        14),
                                                            errorStyle:
                                                                const TextStyle(
                                                              fontSize: 10,
                                                              color: Colors.red,
                                                            ),
                                                            errorText:
                                                                _isJobDescriptionForSavedCVEmpty
                                                                    ? 'Job description can\'t be empty'
                                                                    : null,
                                                          ),
                                                          onChanged: (value) {
                                                            state(() {
                                                              _isJobDescriptionForSavedCVEmpty =
                                                                  false;
                                                            });
                                                          }),
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            const SizedBox(
                                                              width: 40,
                                                            ),
                                                            IgnorePointer(
                                                              ignoring:
                                                                  _isSubmitPressed,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  Get.back();
                                                                },
                                                                style:
                                                                    kElevatedButtonWhiteOpacityBG,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style: kFont12
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 4,
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                _isJobDescriptionForSavedCVEmpty =
                                                                    _jobDescriptionControllerForSavedCV
                                                                        .text
                                                                        .isEmpty;
                                                                if (!_isCVSelected) {
                                                                  state(() {
                                                                    _cvNotSelected =
                                                                        true;
                                                                  });
                                                                } else {
                                                                  state(() {
                                                                    _cvNotSelected =
                                                                        false;
                                                                  });
                                                                }
                                                                if (!_jobDescriptionControllerForSavedCV
                                                                        .text
                                                                        .isEmpty &&
                                                                    _isCVSelected) {
                                                                  _isSubmitPressed =
                                                                      true;
                                                                  _isLoading =
                                                                      true;
                                                                  if (await isInternetConnected()) {
                                                                    await _chatApi(
                                                                        chatCvObj,
                                                                        _jobDescriptionControllerForSavedCV
                                                                            .text,
                                                                        '',
                                                                        token);
                                                                    _isSubmitPressed =
                                                                        false;
                                                                    Navigator.pop(
                                                                        context);
                                                                  } else {
                                                                    appSnackBar(
                                                                        "Error",
                                                                        "No internet connectivity");
                                                                  }
                                                                } else {
                                                                  state(() {
                                                                    if (_jobDescriptionControllerForSavedCV
                                                                        .text
                                                                        .isEmpty) {
                                                                      _isJobDescriptionForSavedCVEmpty =
                                                                          true;
                                                                    }
                                                                  });
                                                                }

                                                                state(() {
                                                                  _isLoading =
                                                                      false;
                                                                });
                                                              },
                                                              style:
                                                                  kElevatedButtonPrimaryBG,
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: _isLoading
                                                                    ? const RotatingImage(
                                                                        height:
                                                                            30,
                                                                        width:
                                                                            30,
                                                                      )
                                                                    : const Align(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          'Submit',
                                                                          style:
                                                                              kFont12,
                                                                        ),
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
                                        });
                                      },
                                      context: context,
                                    );
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
                else if (_firstApiCalled)
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 5.0,
                              ),
                              Image.asset(
                                'assets/images/avatars/dogDP.png',
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: CircularProgressIndicator()),
                              const SizedBox(
                                width: 5.0,
                              ),
                              const Text('Generating response...'),
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
                      itemCount: _allMessages.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _allMessages.length) {
                          print(
                              'New Message : $_newMessage and Error in API :: $_errorInChatApi');
                          if (!_newMessage && !_errorInChatApi) {
                            if (!_newMessage) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
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
                                              'Do you want to choose a template now?',
                                              style: kFont10.copyWith(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Image.asset(
                                            'assets/images/avatars/dogDP.png',
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        refreshResponse();
                                        tempController.refreshController();
                                      },
                                      style: kInitialChatButton,
                                      child: Text(
                                        'No',
                                        style: kFont10.copyWith(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        final BottomBarController controller =
                                            Get.find();
                                        controller.changePage(
                                            controller.currentIndex.value + 1);
                                        // refreshResponse();
                                      },
                                      style: kInitialChatButton,
                                      child: Text(
                                        'Yes',
                                        style: kFont10.copyWith(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          } else if (!_errorInChatApi) {
                            return Align(
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Image.asset(
                                        'assets/images/avatars/dogDP.png',
                                        height: 50,
                                        width: 50,
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      const SizedBox(
                                          height: 20.0,
                                          width: 20.0,
                                          child: CircularProgressIndicator()),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Text('Generating response...'),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          return MessageBubble(
                            message: _allMessages[index]['message'],
                            isUser: _allMessages[index]['isUser'],
                          );
                        }
                      },
                    ),
                  ),
                IgnorePointer(
                  ignoring: _secondApiCalled,
                  child: SizedBox(
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
                              refreshResponse();
                              tempController.refreshController();
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
                              focusNode: _focusNode,
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
                                    _newMessage = true;
                                    if (cvObj.isNotEmpty ||
                                        chatCvObj.isNotEmpty) {
                                      String message = _messageController.text;
                                      _secondApiCalled = true;
                                      _messageController.text.isNotEmpty
                                          ? _chatApi(chatCvObj, jobDescription,
                                              message, token)
                                          : '';
                                      if (message.isNotEmpty) {
                                        setState(() {
                                          _messages.add(message);
                                          _messageController.clear();
                                        });
                                        _scrollController.animateTo(
                                          _scrollController
                                              .position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeOut,
                                        );
                                        _focusNode.unfocus();
                                      }
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
                                  color: Colors.white,
                                  boxShadow: speechToText.isListening
                                      ? [
                                          const BoxShadow(
                                            color: kPurple,
                                            spreadRadius: 5,
                                            blurRadius: 10,
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: speechToText.isListening
                                      ? Image.asset(
                                          'assets/images/mic_gif.gif',
                                          width: 20,
                                          height: 20,
                                        )
                                      : Image.asset(
                                          'assets/images/mic.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


    void refreshResponse() {
      _messages.clear();
      _messagesFromAPI.clear();
      _allMessages.clear();
      cvObj.clear();
      chatCvObj.clear();
      _messageController.clear();
      _focusNode.unfocus();
      _jobDescriptionControllerForUploadCV.clear();
      result = null;
      _fileUploaded = false;
      print("Response Refreshed");
      setState(() {});
      // tempController.refreshController();
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

    void startListening() async {
      if (cvObj.isNotEmpty || chatCvObj.isNotEmpty) {
        await speechToText.listen(
          onResult: (result) {
            return onSpeechResult(result);
          },
        );
        setState(() {});
      }
    }

    String _formatMessageDetails(
        String summary,
        Map<String, dynamic> cvObj,
        List<Map<String, dynamic>> skillsList,
        List<Map<String, dynamic>> educationList,
        List<Map<String, dynamic>> employmentHistoryList,
        List<Map<String, dynamic>> projectsList) {
      final StringBuffer formattedMessage = StringBuffer();

      formattedMessage.writeln('𝗦𝘂𝗺𝗺𝗮𝗿𝘆:');
      formattedMessage.writeln(summary);
      formattedMessage.writeln();

      formattedMessage.writeln('𝗣𝗲𝗿𝘀𝗼𝗻𝗮𝗹 𝗜𝗻𝗳𝗼:');
      formattedMessage
          .writeln('Name: ${cvObj['personal_information']['name']}');
      formattedMessage
          .writeln('Email: ${cvObj['personal_information']['email']}');
      formattedMessage
          .writeln('Phone: ${cvObj['personal_information']['number']}');
      formattedMessage
          .writeln('Address: ${cvObj['personal_information']['address']}');
      formattedMessage.writeln();

      formattedMessage.writeln('𝗦𝗸𝗶𝗹𝗹𝘀:');
      for (Map<String, dynamic> skill in skillsList) {
        formattedMessage.writeln('• ${skill['name']}');
      }
      formattedMessage.writeln();

      formattedMessage.writeln('𝗘𝗱𝘂𝗰𝗮𝘁𝗶𝗼𝗻:');
      for (Map<String, dynamic> education in educationList) {
        formattedMessage.writeln('Degree: ${education['field_of_study']}');
        formattedMessage.writeln('Institute: ${education['institute_name']}');
        formattedMessage.writeln('City: ${education['city']}');
        formattedMessage.writeln('Country: ${education['country']}');
        formattedMessage.writeln('Start date: ${education['start_date']}');
        formattedMessage.writeln('End date: ${education['end_date']}');
        formattedMessage.writeln('Description: ${education['description']}');
        formattedMessage.writeln();
      }

      formattedMessage.writeln('𝗘𝗺𝗽𝗹𝗼𝘆𝗺𝗲𝗻𝘁 𝗛𝗶𝘀𝘁𝗼𝗿𝘆:');
      for (Map<String, dynamic> employment in employmentHistoryList) {
        formattedMessage.writeln('Position: ${employment['job_title']}');
        formattedMessage.writeln('Company: ${employment['company_name']}');
        formattedMessage.writeln('City: ${employment['city']}');
        formattedMessage.writeln('Country: ${employment['country']}');
        formattedMessage.writeln('Start date: ${employment['start_date']}');
        formattedMessage.writeln('End date: ${employment['end_date']}');
        formattedMessage.writeln('Description: ${employment['description']}');
        formattedMessage.writeln();
      }

      formattedMessage.writeln('𝗣𝗿𝗼𝗷𝗲𝗰𝘁𝘀:');
      for (Map<String, dynamic> project in projectsList) {
        formattedMessage.writeln('Project Name: ${project['project_name']}');
        formattedMessage.writeln('Description: ${project['description']}');
        formattedMessage.writeln();
      }

      formattedMessage.writeln();

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

    void updateMessages() {
      _allMessages.clear();

      int apiIndex = 0;
      int userIndex = 0;

      while (
          apiIndex < _messagesFromAPI.length || userIndex < _messages.length) {
        if (apiIndex < _messagesFromAPI.length) {
          _allMessages.add({
            'message': _messagesFromAPI[apiIndex],
            'isUser': false,
          });
          apiIndex++;
        }

        if (userIndex < _messages.length) {
          _allMessages.add({
            'message': _messages[userIndex],
            'isUser': true,
          });
          userIndex++;
        }
      }
    }

    Future<void> _chatApi(Map<String, dynamic> cvObj, String jobDescription,
        String userQuery, String token) async {
      final chatApiUrl = Uri.parse('$baseUrl/api/chat/');
      final client = http.Client();
      try {
        _secondApiCalled = true;

        final chatResponse = await client.post(
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

        if (chatResponse.statusCode == 200) {
          setState(() {
            _firstApiCalled = false;
            _secondApiCalled = false;
          });
          print('Chat API call successful');

          String responseBody = chatResponse.body;

          Map<String, dynamic>? jsonResponse = json.decode(responseBody);

          if (jsonResponse != null) {
            setState(() {
              chatCvObj = jsonResponse;
            });
            await tempController.fillControllerFromCvObject(chatCvObj);
            print("Adnan this is CHAT Obj $chatCvObj");

            print("Filling Controller");

            String summary = jsonResponse['personal_information']?['summary'] ??
                'Summary not found';

            List<Map<String, dynamic>> skillsList = [];
            if (jsonResponse['skills'] != null) {
              skillsList = (jsonResponse['skills'] as List)
                  .map((skill) => Map<String, dynamic>.from(skill))
                  .toList();
            }

            List<Map<String, dynamic>> educationList = [];
            if (jsonResponse['education'] != null) {
              educationList = (jsonResponse['education'] as List)
                  .map((education) => Map<String, dynamic>.from(education))
                  .toList();
            }

            List<Map<String, dynamic>> employmentHistoryList = [];
            if (jsonResponse['employment_history'] != null) {
              employmentHistoryList = (jsonResponse['employment_history']
                      as List)
                  .map((employment) => Map<String, dynamic>.from(employment))
                  .toList();
            }

            List<Map<String, dynamic>> projectsList = [];
            if (jsonResponse['projects'] != null) {
              projectsList = (jsonResponse['projects'] as List)
                  .map((project) => Map<String, dynamic>.from(project))
                  .toList();
            }

            setState(() {
              jobDescription = jsonResponse['job_description'] ?? '';
              String formattedMessage = _formatMessageDetails(
                  summary,
                  jsonResponse,
                  skillsList,
                  educationList,
                  employmentHistoryList,
                  projectsList);
              _messagesFromAPI.add(formattedMessage);
              updateMessages();
              _newMessage = false;
              _errorInChatApi = false;
            });
          } else {
            print('No valid response received');
          }
        } else {
          setState(() {
            _secondApiCalled = false;
            _firstApiCalled = false;
            _errorInChatApi = true;
            _messagesFromAPI.add(_errorApiMessage);
            updateMessages();
          });
          print(
              'Second API call failed with status code ${chatResponse.statusCode}');
          print(chatResponse.body);
        }
      } catch (e) {
        setState(() {
          _secondApiCalled = false;
          _firstApiCalled = false;
          print('I am in catch of chat api');
          _errorInChatApi = true;
          _messagesFromAPI.add(_errorApiMessage);
          updateMessages();
        });
        print('Error in chat API call: $e');
      } finally {
        setState(() {
          _secondApiCalled = false;
          _firstApiCalled = false;
        });
        client.close();
      }
    }

    Future<bool> _openGallery() async {
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

        // _updateProgress();

        _filePath = result!.files.single.path!;
        print('File Path: $_filePath');

        return true;
      } else {
        return false;
      }
    }

    Future<Map<String, dynamic>?> _callUploadCVApi() async {
      try {
        final url = Uri.parse('$baseUrl/api/process_data/');
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
          setState(() {
            _firstApiCalled = true;
          });
          String apiResponse = await response.stream.bytesToString();

          Map<String, dynamic> jsonResponse = json.decode(apiResponse);
          cvObj = jsonResponse['cv_obj'];
          print("Adnan this is CV Obj $cvObj");
          return cvObj;
        } else {
          print(
              'API call failed with status code ${response.statusCode} and response $response');

          String apiResponse = await response.stream.bytesToString();
          print(apiResponse);
          return null;
        }
      } catch (e) {
        print('Error in API call: $e');
        return null;
      }
    }
  }

