import 'package:crewdog_cv_lab/screens/home/components/const.dart';
import 'package:crewdog_cv_lab/screens/home/services/chat_api.dart';
import 'package:crewdog_cv_lab/utils/consts/const_images.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../custom_widgets/rotating_image.dart';
import '../../../cv_templates/controllers/templates_controller.dart';
import '../../../utils/app_functions.dart';
import '../../../utils/app_snackbar.dart';
import '../../../utils/consts/constants.dart';
import '../home_controller.dart';
import '../services/upload_cv_api.dart';

Widget uploadCvDialog({required BuildContext context, required VoidCallback updateState}) {
  final HomeController controller = Get.find();
  return StatefulBuilder(builder: (context, state) {
    return AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: const BorderSide(color: Colors.transparent, width: 1.0)),
        contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 4),
        backgroundColor: kBackgroundColor,
        titlePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Please upload CV', style: kFont14black600),
          IgnorePointer(
              ignoring: controller.isSubmitPressed,
              child: InkWell(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close_rounded, size: 16)))
        ]),
        content: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            DottedBorder(
                color: kPurple,
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                        width: double.infinity,
                        decoration:
                            BoxDecoration(shape: BoxShape.rectangle, color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
                        child: Column(children: [
                          const SizedBox(height: 15.0),
                          Image.asset(AppImages.uploadFile, height: 35, width: 42),
                          const SizedBox(height: 5.0),
                          const Text('Upload your files here', style: kFont12Black),
                          GestureDetector(
                              onTap: () async {
                                bool checkFileUploaded = await controller.openGallery(onStateUpdate: () {
                                  state(() {});
                                });
                                state(() {
                                  controller.fileUploaded = checkFileUploaded;
                                  controller.cvNotUploaded = !checkFileUploaded;
                                  controller.isSubmitPressed = false;
                                });
                                void updateProgress() async {
                                  for (int i = 0; i <= 100; i += 10) {
                                    await Future.delayed(const Duration(milliseconds: 100));
                                    state(() {
                                      controller.progress = i / 100;
                                      controller.timeRemaining = '${(10 - i ~/ 10)} sec';
                                    });
                                  }
                                }

                                updateProgress();
                              },
                              child: Text('Browse', style: purpleUnderlineButton)),
                          const SizedBox(height: 15.0)
                        ])))),
            const SizedBox(height: 2.0),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Visibility(
                  visible: controller.cvNotUploaded, child: const Text('  Upload CV', style: TextStyle(fontSize: 10, color: kErrorColor))),
              const Text('DOC, DOCX, PDF', style: kFont8Black)
            ])
          ]),
          Visibility(
              visible: controller.fileUploaded,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Transform.translate(
                    offset: const Offset(0.0, 15.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(controller.fileName, style: kFont10Black), Text(controller.fileSize, style: kFont8Black)])),
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Expanded(
                      flex: 100,
                      child: LinearProgressIndicator(
                          minHeight: 1.5,
                          value: controller.progress,
                          backgroundColor: kPurple,
                          valueColor: controller.progress == 1.0
                              ? const AlwaysStoppedAnimation<Color>(Colors.green)
                              : const AlwaysStoppedAnimation<Color>(kHighlightedColor))),
                  Expanded(
                      flex: 13,
                      child: IgnorePointer(
                          ignoring: controller.isSubmitPressed,
                          child: IconButton(
                              highlightColor: Colors.transparent,
                              iconSize: 20,
                              onPressed: () {
                                state(() {
                                  controller.result = null;
                                  controller.fileUploaded = false;
                                  controller.cvNotUploaded = false;
                                  controller.isSubmitPressed = false;
                                });
                              },
                              icon: const Icon(Icons.cancel_outlined))))
                ]),
                Transform.translate(
                    offset: const Offset(0.0, -15.0), child: Text('Time remaining: ${controller.timeRemaining}', style: kFont8Black)),
                const SizedBox(height: 5)
              ])),
          const SizedBox(height: 5.0),
          const Text('Job description', style: kFont14black600),
          const SizedBox(height: 5.0),
          TextFormField(
              controller: controller.jobDescriptionControllerForUploadCV,
              minLines: 2,
              enabled: true,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: descriptionFieldDecoration(controller.isJobDescriptionEmpty),
              onChanged: (value) {
                state(() {
                  controller.isJobDescriptionEmpty = false;
                });
              }),
          const SizedBox(height: 10.0),
          Align(
              alignment: Alignment.centerRight,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                const SizedBox(width: 40),
                IgnorePointer(
                    ignoring: controller.isSubmitPressed,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: kElevatedButtonWhiteOpacityBG,
                        child: const Align(alignment: Alignment.center, child: Text('Cancel', style: kFont12Black)))),
                const SizedBox(width: 4),
                IgnorePointer(
                    ignoring: controller.isSubmitPressed,
                    child: ElevatedButton(
                        onPressed: () async {
                          controller.isSubmitPressed = true;
                          controller.isJobDescriptionEmpty = controller.jobDescriptionControllerForUploadCV.text.isEmpty;
                          if (!controller.isJobDescriptionEmpty) {
                            state(() {
                              controller.isJobDescriptionEmpty = false;
                              controller.isLoading = true;
                            });
                          } else {
                            state(() {
                              controller.isJobDescriptionEmpty = true;
                              controller.isSubmitPressed = false;
                            });
                          }
                          if (controller.fileUploaded && !controller.isJobDescriptionEmpty) {
                            state(() {
                              controller.fileUploaded = true;
                            });
                            if (await isInternetConnected()) {
                              await callUploadCVApi(onStateUpdate: () =>state(() {}),context: context);
                              state(() {
                                controller.isSubmitPressed = false;
                              });
                              if (controller.chatCvObj.isNotEmpty && controller.chatCvObj['result'] == null){
                                  controller.firstApiCalled = true;
                                  updateState();
                                  Get.back();
                                  chatApi(
                                      cvObj: controller.chatCvObj,
                                      jobDescription: controller.jobDescriptionControllerForUploadCV.text,
                                      userQuery: '',
                                      token: token,
                                      onStateUpdate: () =>updateState());
                                }
                            } else {
                              appSnackBar("Error", "No internet connectivity");
                            }
                          } else if (!controller.fileUploaded) {
                            state(() {
                              controller.fileUploaded = false;
                              controller.cvNotUploaded = true;
                            });
                          }
                          state(() {
                            controller.isLoading = false;
                          });
                        },
                        style: kElevatedButtonPrimaryBG,
                        child: Align(
                            alignment: Alignment.center,
                            child: controller.isLoading
                                ? const RotatingImage(height: 30, width: 30)
                                : const Align(alignment: Alignment.center, child: Text('Submit', style: kFont12)))))
              ])),
          const SizedBox(height: 10.0)
        ])));
  });
}
