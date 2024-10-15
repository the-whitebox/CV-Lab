import 'package:crewdog_cv_lab/screens/home/components/const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../custom_widgets/rotating_image.dart';
import '../../../cv_templates/controllers/templates_controller.dart';
import '../../../utils/app_functions.dart';
import '../../../utils/app_snackbar.dart';
import '../../../utils/consts/const_images.dart';
import '../../../utils/consts/constants.dart';
import '../../templates/saved_cv.dart';
import '../home_controller.dart';
import '../services/chat_api.dart';

class UseSavedCvDialog extends StatefulWidget {
  final BuildContext context;
  final VoidCallback onStateUpdate;

  const UseSavedCvDialog({required this.context, required this.onStateUpdate, Key? key}) : super(key: key);

  @override
  _UseSavedCvDialogState createState() => _UseSavedCvDialogState();
}

class _UseSavedCvDialogState extends State<UseSavedCvDialog> {
  final HomeController controller = Get.find();
  final TempController tempController = Get.put(TempController());
  bool isLoading = false;
  List cvList = [];
  int? selectedCv;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    cvList = await fetchMyCVsData(token);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // int? cvId;

    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: const BorderSide(color: Colors.transparent, width: 1.0)),
        contentPadding: EdgeInsets.zero,
        backgroundColor: kBackgroundColor,
        titlePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Select a CV', style: kFont14black600),
          IgnorePointer(ignoring: controller.isSubmitPressed, child: InkWell(onTap: () => Get.back(), child: const Icon(Icons.close_rounded, size: 16)))
        ]),
        content: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600.0, maxHeight: screenHeight * 0.8),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                      height: screenHeight * 0.3,
                      width: screenWidth * 0.8,
                      child: isLoading
                          ? const RotatingImage()
                          : Container(
                              padding: EdgeInsets.only(top: screenHeight * 0.01, left: screenWidth * 0.04, right: screenWidth * 0.04),
                              child: cvList.isEmpty
                                  ? const Center(child: Text('You have not saved any CV yet', style: kFont14Black))
                                  : GridView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 1.8, crossAxisCount: 1, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0),
                                      itemCount: cvList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        final title = cvList[index]['username'];
                                        final templateName = cvList[index]['template']['name'];
                                        int cvId = cvList[index]['cv']['id'];
                                        final lastDigit = int.tryParse(templateName.substring(templateName.length - 1)) ?? 1;
                                        final templateIndex = lastDigit - 1;
                                        if (templateIndex >= 0 && templateIndex < pdfImages.length) {
                                          return Column(children: [
                                            GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    controller.selectButton = 'Select';
                                                    controller.tappedIndex = index;
                                                    selectedCv = cvId;
                                                  });
                                                },
                                                child: Stack(children: [
                                                  Container(
                                                      margin: const EdgeInsets.only(left: 3, right: 3, bottom: 3),
                                                      decoration: BoxDecoration(boxShadow: [
                                                        BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: const Offset(-1, 1))
                                                      ], borderRadius: BorderRadius.circular(8.0)),
                                                      child: Image.asset(pdfImages[templateIndex])),
                                                  if (controller.tappedIndex == index)
                                                    Center(
                                                        child: Column(children: [
                                                      SizedBox(height: screenHeight * 0.1),
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            setState(() {
                                                              controller.selectButton = 'Selected';
                                                              controller.isCVSelected = true;
                                                              controller.cvNotSelected = false;
                                                            });
                                                          },
                                                          style: kElevatedButtonPrimaryBG,
                                                          child: Text(controller.selectButton, style: const TextStyle(color: kBackgroundColor)))
                                                    ]))
                                                ])),
                                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              const Text('Title: '),
                                              Expanded(
                                                  child: Text(title, maxLines: 2, style: const TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w500)))
                                            ])
                                          ]);
                                        } else {
                                          return Container(
                                              padding: const EdgeInsets.all(8.0),
                                              color: kHighlightedColor,
                                              child: const Center(child: Text('Invalid template version', style: TextStyle(color: kBackgroundColor))));
                                        }
                                      }))),
                  Row(children: [
                    const SizedBox(width: 25.0),
                    Visibility(visible: controller.cvNotSelected, child: const Text('CV must be selected', style: TextStyle(color: kErrorColor, fontSize: 10.0)))
                  ]),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5), child: Text('Job description', style: kFont14black600)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                        controller: controller.jobDescriptionControllerForSavedCV,
                        minLines: 2,
                        enabled: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: descriptionFieldDecoration(controller.isJobDescriptionForSavedCVEmpty),
                        onChanged: (value) {
                          setState(() {
                            controller.isJobDescriptionForSavedCVEmpty = false;
                          });
                        }),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                      child: Align(
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
                                      controller.isJobDescriptionForSavedCVEmpty = controller.jobDescriptionControllerForSavedCV.text.isEmpty;
                                      if (!controller.isCVSelected) {
                                        setState(() {
                                          controller.cvNotSelected = true;
                                        });
                                      } else {
                                        setState(() {
                                          controller.cvNotSelected = false;
                                        });
                                      }
                                      if (controller.jobDescriptionControllerForSavedCV.text.isNotEmpty && controller.isCVSelected) {
                                        controller.isSubmitPressed = true;
                                        controller.isLoading = true;
                                        if (await isInternetConnected()) {
                                         await tempController.fetchCvObjectFromBackend(
                                              selectedCv.toString(), controller.jobDescriptionControllerForSavedCV.text, context);
                                          if (controller.chatCvObj.isNotEmpty && controller.chatCvObj['result'] == null) {
                                            controller.firstApiCalled = true;
                                            widget.onStateUpdate();
                                            Get.back();
                                            await chatApi(
                                                cvObj: controller.chatCvObj,
                                                jobDescription: controller.jobDescriptionControllerForSavedCV.text,
                                                userQuery: '',
                                                token: token,
                                                onStateUpdate: () => widget.onStateUpdate());
                                          } else  if(controller.chatCvObj['result'] != null){
                                            controller.chatCvObj.clear();
                                            setState(() {
                                              controller.isLoading = false;
                                              controller.isSubmitPressed = false;
                                            });
                                          }else{
                                            setState(() {
                                              controller.isLoading = false;
                                              controller.isSubmitPressed = false;
                                            });
                                          }
                                        } else {
                                          appSnackBar("Error", "No internet connectivity");
                                        }
                                      } else {
                                        setState(() {
                                          if (controller.jobDescriptionControllerForSavedCV.text.isEmpty) {
                                            controller.isJobDescriptionForSavedCVEmpty = true;
                                          }
                                        });
                                      }
                                      // setState(() {
                                      //   controller.isLoading = false;
                                      // });
                                    },
                                    style: kElevatedButtonPrimaryBG,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: controller.isLoading
                                            ? const RotatingImage(height: 30, width: 30)
                                            : const Align(alignment: Alignment.center, child: Text('Submit', style: kFont12)))))
                          ])))
                ]))));
  }
}
