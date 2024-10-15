import 'package:crewdog_cv_lab/screens/home/components/choose_options_tile.dart';
import 'package:crewdog_cv_lab/screens/home/components/cv_options_button.dart';
import 'package:crewdog_cv_lab/screens/home/components/feature_header.dart';
import 'package:crewdog_cv_lab/screens/home/components/fine_tune_tile.dart';
import 'package:crewdog_cv_lab/screens/home/components/upload_cv_dialog.dart';
import 'package:crewdog_cv_lab/screens/home/components/use_saved_cv_dialog.dart';
import 'package:crewdog_cv_lab/screens/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../custom_widgets/bubble_message.dart';
import '../../utils/app_functions.dart';
import '../../utils/consts/const_images.dart';
import '../../utils/consts/constants.dart';
import '../bottom_bar/bottom_nav_bar.dart';
import '../../cv_templates/controllers/templates_controller.dart';
import 'services/chat_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.find();
  final tempController = Get.put(TempController());

  @override
  void initState() {
    super.initState();
    controller.initSpeech();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    controller.updateMessages();
    return Scaffold(
        backgroundColor: kBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage(AppImages.bgPaws), fit: BoxFit.cover)),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      if (controller.messages.isEmpty && controller.messagesFromAPI.isEmpty && !controller.firstApiCalled)
                        Expanded(
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          SizedBox(height: screenHeight * 0.02),
                          Expanded(flex: 20, child: featureHeader(screenWidth)),
                          const Expanded(child: SizedBox()),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            fineTuneTile(screenWidth),
                            cvOptionButton(
                                title: "Upload CV",
                                onTap: () {
                                  controller.jobDescriptionControllerForUploadCV.clear();
                                  controller.isJobDescriptionEmpty = false;
                                  controller.result = null;
                                  controller.fileUploaded = false;
                                  controller.cvNotUploaded = false;
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return uploadCvDialog(context: context, updateState: () => setState(() {}));
                                      });
                                }),
                            cvOptionButton(
                                title: 'Use My Saved CV\'s',
                                onTap: () async {
                                  controller.isLoading = false;
                                  controller.isJobDescriptionForSavedCVEmpty = false;
                                  controller.isCVSelected = false;
                                  controller.cvNotSelected = false;
                                  controller.selectButton = 'Select';
                                  controller.jobDescriptionControllerForSavedCV.clear();
                                  controller.tappedIndex = null;
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return UseSavedCvDialog(context: context, onStateUpdate: () => setState(() {}));
                                      });
                                })
                          ])
                        ]))
                      else if (controller.firstApiCalled)
                        Expanded(
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(children: [
                                  const SizedBox(height: 5.0),
                                  Row(children: [
                                    const SizedBox(width: 5.0),
                                    Image.asset(AppImages.dogDp, height: 50, width: 50),
                                    const SizedBox(width: 10.0),
                                    const SizedBox(height: 20.0, width: 20.0, child: CircularProgressIndicator()),
                                    const SizedBox(width: 5.0),
                                    const Text('Generating response...')
                                  ])
                                ])))
                      else
                        Expanded(
                            child: ListView.builder(
                                controller: controller.scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: controller.allMessages.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == controller.allMessages.length) {
                                    customLog('Error in API: ${controller.errorInChatApi}');
                                    if (!controller.newMessage && !controller.errorInChatApi) {
                                      if (!controller.newMessage) {
                                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          chooseOptionTile(),
                                          cvOptionButton(
                                              title: 'No',
                                              onTap: () {
                                                controller.refreshResponse();
                                                tempController.refreshController();
                                                setState(() {});
                                              }),
                                          cvOptionButton(
                                              title: 'Yes',
                                              onTap: () {
                                                final BottomBarController bottomBarController = Get.find();
                                                bottomBarController.changePage(bottomBarController.currentIndex.value + 1);
                                              })
                                        ]);
                                      } else {
                                        return const SizedBox();
                                      }
                                    } else if (!controller.errorInChatApi) {
                                      return Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Column(children: [
                                            const SizedBox(height: 5.0),
                                            Row(children: [
                                              const SizedBox(width: 5.0),
                                              Image.asset(AppImages.dogDp, height: 50, width: 50),
                                              const SizedBox(width: 10.0),
                                              const SizedBox(height: 20.0, width: 20.0, child: CircularProgressIndicator()),
                                              const SizedBox(width: 5.0),
                                              const Text('Generating response...'),
                                            ])
                                          ]));
                                    }
                                  } else {
                                    return MessageBubble(
                                        userImage: controller.imageFromApi,
                                        message: controller.allMessages[index]['message'],
                                        isUser: controller.allMessages[index]['isUser']);
                                  }
                                })),
                      IgnorePointer(
                          ignoring: controller.secondApiCalled,
                          child: SizedBox(
                              child: Row(children: [
                            const SizedBox(width: 5),
                            Material(
                                color: kPurple,
                                borderRadius: BorderRadius.circular(5.0),
                                elevation: 5.0,
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(5.0),
                                    onTap: () {
                                      setState(() {
                                        controller.refreshResponse();
                                        tempController.refreshController();
                                      });
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 11),
                                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                                          Image.asset(AppImages.newTopic, height: 12, width: 12),
                                          const SizedBox(width: 2),
                                          const Text('New Topic', style: kFont8)
                                        ])))),
                            const SizedBox(width: 5),
                            Expanded(
                                child: SizedBox(
                                    height: 35,
                                    child: TextField(
                                        controller: controller.messageController,
                                        focusNode: controller.focusNode,
                                        style: kFont12Black,
                                        readOnly: false,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: kBackgroundColor,
                                            hintStyle: kFont12Grey,
                                            hintText: 'Hello, how can I help you...',
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                            enabledBorder: const OutlineInputBorder(
                                                borderSide: BorderSide(color: kWhiteF1, width: 1.0), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                            focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(color: kWhiteF1, width: 1.0),
                                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            ),
                                            suffixIcon: GestureDetector(
                                                onTap: () {
                                                  controller.newMessage = true;
                                                  if (controller.chatCvObj.isNotEmpty) {
                                                    String message = controller.messageController.text;
                                                    controller.secondApiCalled = true;
                                                    controller.messageController.text.isNotEmpty
                                                        ? chatApi(
                                                            cvObj: controller.chatCvObj,
                                                            jobDescription: controller.jobDescription,
                                                            userQuery: message,
                                                            token: token,
                                                            onStateUpdate: () => setState(() {}))
                                                        : '';
                                                    if (message.isNotEmpty) {
                                                      setState(() {
                                                        controller.messages.add(message);
                                                        controller.messageController.clear();
                                                      });
                                                      controller.scrollController.animateTo(controller.scrollController.position.maxScrollExtent,
                                                          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                                                      controller.focusNode.unfocus();
                                                    }
                                                  }
                                                },
                                                child: Image.asset(scale: 3.0, AppImages.send))),
                                        onChanged: (value) {}))),
                            Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Material(
                                    color: kBackgroundColor,
                                    shape: const CircleBorder(),
                                    elevation: 2.0,
                                    child: InkWell(
                                        borderRadius: BorderRadius.circular(50),
                                        onTap: controller.speechToText.isListening
                                            ? () {
                                                controller.stopListening(stateUpdate: () {
                                                  setState(() {});
                                                });
                                              }
                                            : () {
                                                controller.startListening(stateUpdate: () {
                                                  setState(() {});
                                                });
                                              },
                                        child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                boxShadow: controller.speechToText.isListening ? [const BoxShadow(color: kPurple, spreadRadius: 5, blurRadius: 10)] : []),
                                            child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: controller.speechToText.isListening
                                                    ? Image.asset(AppImages.micGif, width: 20, height: 20)
                                                    : Image.asset(AppImages.mic, width: 20, height: 20))))))
                          ])))
                    ])))));
  }
}
