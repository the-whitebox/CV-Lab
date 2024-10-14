import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';
import '../custom_widgets/custom_widgets.dart';
import '../pdf_custom_widgets/pdf_custom_widgets.dart';
import '../utils/consts/api_consts.dart';
import '../utils/consts/constants.dart';
import '../../utils/app_functions.dart';
import 'package:pdf/widgets.dart' as pw;
import 'controllers/templates_controller.dart';
import 'functions/upload_data_and_image.dart';
import 'package:crewdog_cv_lab/models/models.dart';

class V102 extends StatefulWidget {
  const V102({Key? key}) : super(key: key);

  @override
  State<V102> createState() => _V102State();
}

class _V102State extends State<V102> {
  final controller = Get.put(TempController());
  bool isCanPop = true;
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: isCanPop,
        onPopInvoked: (didPop) {
          if (didPop && controller.isChatData == true) {
            print("Came from Home Screen");
            isCanPop = false;
            // Perform actions specific to coming from the Home Screen
          } else {
            controller.refreshController();
          }
        },
        child: SafeArea(
          child: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_paws.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Customise your CV",
                    style: kHeadingTextStyle600,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.lightBlue.shade100, spreadRadius: 0.1, blurRadius: 20),
                      ]),
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Curriculum vitae',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Inter',
                                    color: Color(0XFF8996A0),
                                  ),
                                ),
                                Column(
                                  children: [
                                    controller.profilePicState
                                        ? const SizedBox()
                                        : GestureDetector(
                                            onTap: () {
                                              openGallery();
                                              controller.profilePicState = true;
                                            },
                                            child: const Text("Add Image",
                                                style: TextStyle(
                                                  color: Color(0XFFC6A4FF),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          ),
                                    controller.profilePicState
                                        ? GestureDetector(
                                            onTap: () {
                                              openGallery();
                                            },
                                            child: ClipOval(
                                              child: SizedBox(
                                                height: 60,
                                                width: 60,
                                                child: Image(
                                                  image: controller.cvImagePath.isNotEmpty
                                                      ? controller.isSsoUrl? NetworkImage(
                                                      '$ssoUrl${controller.cvImagePath}'): NetworkImage(
                                                      '$baseUrl${controller.cvImagePath}')
                                                      : const AssetImage(
                                                      'assets/images/icon-profile.png')
                                                  as ImageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(height: 5),
                                    controller.profilePicState
                                        ? GestureDetector(
                                            onTap: () {
                                              controller.profilePicState = false;
                                              controller.cvImagePath = '';
                                              controller.cvImage = File('');
                                              controller.isSsoUrl=false;
                                              selectedImage == null;
                                              setState(() {});
                                            },
                                            child: const Text("Remove Image",
                                                style: TextStyle(
                                                  color: Color(0XFFC6A4FF),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                          )
                                        : const SizedBox(),
                                  ],
                                )
                              ],
                            ),
                            const Divider(
                              color: Color(0XFFE1E1E1),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Name',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'Inter',
                                          color: Color(0XFF033144),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: CustomEditableText(
                                        controller: controller.nameController,
                                        style: const TextStyle(
                                          color: Color(0XFF4E4949),
                                          fontSize: 8,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Job Title',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'Inter',
                                          color: Color(0XFF033144),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: CustomEditableText(
                                        controller: controller.designationController,
                                        style: const TextStyle(
                                          color: Color(0XFF4E4949),
                                          fontSize: 8,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Email',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'Inter',
                                          color: Color(0XFF033144),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: CustomEditableText(
                                        controller: controller.mailController,
                                        style: const TextStyle(
                                          color: Color(0XFF4E4949),
                                          fontSize: 8,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Contact Number',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'Inter',
                                          color: Color(0XFF033144),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: CustomEditableText(
                                        controller: controller.contactController,
                                        style: const TextStyle(
                                          color: Color(0XFF4E4949),
                                          fontSize: 8,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Address',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'Inter',
                                          color: Color(0XFF033144),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: CustomEditableText(
                                        controller: controller.addressController,
                                        style: const TextStyle(
                                          color: Color(0XFF4E4949),
                                          fontSize: 8,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 7.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Profile',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'Inter',
                                          color: Color(0XFF033144),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: CustomEditableText(
                                        controller: controller.personalInformation,
                                        style: const TextStyle(
                                          color: Color(0XFF4E4949),
                                          fontSize: 8,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 7.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Qualification\nand\nmembership',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'Inter',
                                              color: Color(0XFF033144),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              CvAddButton(
                                                onTap: () {
                                                  setState(() {
                                                    controller.education.add(
                                                      EducationHistory(
                                                        fieldOfStudy: TextEditingController(
                                                            text: 'Lorem Ipsum'),
                                                        description: TextEditingController(
                                                            text:
                                                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type'),
                                                        endDate: TextEditingController(
                                                            text: 'November 2015'),
                                                        startDate: TextEditingController(
                                                            text: 'September 2019'),
                                                        city: TextEditingController(
                                                            text: 'Lorem Ipsum'),
                                                        country: TextEditingController(
                                                            text: 'Lorem Ipsum'),
                                                        instituteName: TextEditingController(
                                                            text: 'Lorem Ipsum'),
                                                        keyController: GlobalKey(),
                                                      ),
                                                    );
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        children: [
                                          for (int i = 0; i < controller.education.length; i++)
                                            Row(
                                              children: [
                                                EducationHistoryWidget(
                                                  isRemovable: controller.education.length > 1,
                                                  description: controller.education[i].description,
                                                  title: controller.education[i].fieldOfStudy,
                                                  from: controller.education[i].startDate,
                                                  till: controller.education[i].endDate,
                                                  city: controller.education[i].city,
                                                  country: controller.education[i].country,
                                                  instituteName:
                                                      controller.education[i].instituteName,
                                                  onRemoveTap: () {
                                                    setState(() {
                                                      controller.education.removeAt(i);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Experience',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        color: Color(0XFF033144),
                                      ),
                                    ),
                                    const Spacer(),
                                    CvAddButton(
                                      onTap: () {
                                        setState(() {
                                          controller.employmentHistory.add(
                                            EmploymentHistory(
                                              jobTitle: TextEditingController(
                                                  text:
                                                      'Lorem Ipsum is simply dummy text of the printing and'),
                                              description: TextEditingController(
                                                  text:
                                                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type'),
                                              endDate: TextEditingController(text: 'November 2015'),
                                              startDate:
                                                  TextEditingController(text: 'September 2019'),
                                              city: TextEditingController(text: 'London'),
                                              country: TextEditingController(text: 'UK'),
                                              companyName: TextEditingController(text: 'WhiteBox'),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                for (int i = 0; i < controller.employmentHistory.length; i++)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 7.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                controller.employmentHistory[i].startDate.text
                                                    .numericOnly(),
                                                style: const TextStyle(
                                                    fontSize: 8,
                                                    fontFamily: 'Inter',
                                                    color: Color(0XFFFD8023)),
                                              ),
                                              const Text(
                                                " - ",
                                                style: TextStyle(
                                                    fontSize: 8,
                                                    fontFamily: 'Inter',
                                                    color: Color(0XFFFD8023)),
                                              ),
                                              Text(
                                                controller.employmentHistory[i].endDate.text
                                                    .numericOnly(),
                                                style: const TextStyle(
                                                    fontSize: 8,
                                                    fontFamily: 'Inter',
                                                    color: Color(0XFFFD8023)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Row(
                                          children: [
                                            EmploymentHistoryWidget(
                                              isRemovable: controller.employmentHistory.length > 1,
                                              description:
                                                  controller.employmentHistory[i].description,
                                              title: controller.employmentHistory[i].jobTitle,
                                              from: controller.employmentHistory[i].startDate,
                                              till: controller.employmentHistory[i].endDate,
                                              country: controller.employmentHistory[i].country,
                                              city: controller.employmentHistory[i].city,
                                              companyName:
                                                  controller.employmentHistory[i].companyName,
                                              onRemoveTap: () {
                                                setState(() {
                                                  controller.employmentHistory.removeAt(i);
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8.0),
                                          const Text(
                                            'Skills',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'Inter',
                                              color: Color(0XFF033144),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          CvAddButton(
                                            onTap: () {
                                              setState(() {
                                                controller.skills.add({
                                                  TextEditingController(text: "Your Skill"): 0.7
                                                });
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: GridView.builder(
                                        itemCount: controller.skills.length,
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 2.5,
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 2,
                                        ),
                                        itemBuilder: (context, index) {
                                          return SkillCircullarWidget(
                                            leftPadding: 0,
                                            isRemovable: controller.skills.length > 1,
                                            skill: controller.skills[index].keys.first,
                                            onButtonTap: () {
                                              setState(() {
                                                controller.skills.removeAt(index);
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                if (controller.projects.isNotEmpty)
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Projects',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: 'Inter',
                                                color: Color(0XFF033144),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            CvAddButton(
                                              onTap: () {
                                                setState(() {
                                                  controller.projects.add(Projects(
                                                      title: TextEditingController(
                                                          text: "Your project title"),
                                                      description: TextEditingController(
                                                          text:
                                                              "Write your project description here")));
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            for (int i = 0; i < controller.projects.length; i++)
                                              ProjectWidget(
                                                isRemovable: controller.projects.length > 1,
                                                title: controller.projects[i].title,
                                                description: controller.projects[i].description,
                                                onRemoveTap: () {
                                                  setState(() {
                                                    controller.projects.removeAt(i);
                                                  });
                                                },
                                              )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (controller.reference.isNotEmpty)
                                            const Text(
                                              'Reference',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontFamily: 'Inter',
                                                color: Color(0XFF033144),
                                              ),
                                            ),
                                          const SizedBox(height: 5),
                                          CvAddButton(
                                            buttonText: controller.reference.isNotEmpty
                                                ? "Add"
                                                : "Add\nReference",
                                            onTap: () {
                                              setState(() {
                                                controller.reference.add(References(
                                                    personName: TextEditingController(
                                                        text: "Reference Name"),
                                                    contactNumber: TextEditingController(
                                                        text: "Contact Number"),
                                                    referenceText: TextEditingController(
                                                        text: "Reference Text")));
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          for (int i = 0; i < controller.reference.length; i++)
                                            ReferenceWidget(
                                              personName: controller.reference[i].personName,
                                              contactNumber: controller.reference[i].contactNumber,
                                              referenceText: controller.reference[i].referenceText,
                                              onRemoveTap: () {
                                                setState(() {
                                                  controller.reference.removeAt(i);
                                                });
                                              },
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SaveDownloadButtonsRow(
                    isUpdateCV: controller.saveCvId != 0,
                    onSavePressed: () async {
                      if (controller.saveCvId != 0) {
                        await controller.updateCv(('v102'), controller.saveCvId);
                      } else {
                        await controller.saveCv('v102');
                      }
                    },
                    onDownloadPressed: () async {
                      await PwAssets.initializeAssets();
                      await PwFonts.initializeFonts();
                      pw.ImageProvider netImage = await networkImage(
                          'https://cvlab.crewdog.ai/static/media/profilepic.1854a1d1129a7d85e324.png');
                      if (controller.cvImagePath.isNotEmpty) {
                        netImage =controller.isSsoUrl? await networkImage('$ssoUrl${controller.cvImagePath}'): await networkImage('$baseUrl${controller.cvImagePath}');
                      }
                      await makePdf(
                          buildTemplate3Pdf(controller, netImage), controller.nameController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String cvImagePath = await uploadDataAndImage(
        pickedFile,
        token,
        'v102',
        userId,
      );
      setState(() {
        selectedImage = File(pickedFile.path);
        controller.cvImage = File(pickedFile.path);
        controller.cvImagePath = '/media/$cvImagePath';
        controller.isSsoUrl=false;
        controller.isAuthImage=false;
      });
    }
  }

  List<pw.Widget> buildTemplate3Pdf(TempController controller, pw.ImageProvider netImage) {
    List<pw.Widget> widgets = [
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text('Curriculum vitae',
              style: pw.TextStyle(
                color: AppPdfColor.pdfDividerColor2,
                fontSize: 14,
                font: PwFonts.ttf600,
              )),
          controller.profilePicState
              ? pw.ClipOval(
                  child: pw.SizedBox(
                    height: 70,
                    width: 70,
                    child: controller.cvImagePath.isNotEmpty
                        ? pw.Image(netImage, fit: pw.BoxFit.cover)
                        : pw.Image(pw.MemoryImage(PwAssets.cvDemoImage)),
                  ),
                )
              : pw.SizedBox()
        ],
      ),
      pw.SizedBox(height: 10),
      pw.Divider(
        color: AppPdfColor.pdfDividerColor2,
      ),
      pw.Row(
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.Text(
              'Name',
              style: pw.TextStyle(
                fontSize: 14,
                font: PwFonts.ttf700,
                color: AppPdfColor.textHeadingColor,
              ),
            ),
          ),
          pw.Expanded(
              flex: 3,
              child: pw.Text(controller.nameController.text,
                  textAlign: pw.TextAlign.left, style: TextStylesPdf.bodyText12Simple)),
        ],
      ),
      pw.SizedBox(
        height: 10.0,
      ),
      pw.Row(
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.Text(
              'Job Title',
              style: pw.TextStyle(
                fontSize: 14,
                color: AppPdfColor.textHeadingColor,
                font: PwFonts.ttf700,
              ),
            ),
          ),
          pw.Expanded(
              flex: 3,
              child: pw.Text(controller.designationController.text,
                  textAlign: pw.TextAlign.left, style: TextStylesPdf.bodyText12Simple)),
        ],
      ),
      pw.SizedBox(
        height: 10.0,
      ),
      pw.Row(
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.Text(
              'Email',
              style: pw.TextStyle(
                fontSize: 14,
                color: AppPdfColor.textHeadingColor,
                font: PwFonts.ttf700,
              ),
            ),
          ),
          pw.Expanded(
              flex: 3,
              child: pw.Text(controller.mailController.text,
                  textAlign: pw.TextAlign.left, style: TextStylesPdf.bodyText12Simple)),
        ],
      ),
      pw.SizedBox(
        height: 10.0,
      ),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.Text(
              'Contact Number',
              style: pw.TextStyle(
                fontSize: 14,
                font: PwFonts.ttf700,
                color: AppPdfColor.textHeadingColor,
              ),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(controller.contactController.text,
                textAlign: pw.TextAlign.left, style: TextStylesPdf.bodyText12Simple),
          ),
        ],
      ),
      pw.SizedBox(
        height: 10.0,
      ),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.Text(
              'Address',
              style: pw.TextStyle(
                fontSize: 14,
                font: PwFonts.ttf700,
                color: AppPdfColor.textHeadingColor,
              ),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(controller.addressController.text,
                textAlign: pw.TextAlign.left, style: TextStylesPdf.bodyText12Simple),
          ),
        ],
      ),
      pw.SizedBox(
        height: 10.0,
      ),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.Text(
              'Profile',
              style: pw.TextStyle(
                fontSize: 14,
                font: PwFonts.ttf700,
                color: AppPdfColor.textHeadingColor,
              ),
            ),
          ),
          //pw.Expanded(flex: 3, child: pw.SizedBox()),
          pw.Expanded(
            flex: 3,
            child: pw.Text(controller.personalInformation.text,
                textAlign: pw.TextAlign.left, style: TextStylesPdf.bodyText12Simple),
          ),
        ],
      ),
      pw.SizedBox(
        height: 10.0,
      ),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.Text(
              'Qualification\nand\nmembership',
              style: pw.TextStyle(
                fontSize: 14,
                font: PwFonts.ttf700,
                color: AppPdfColor.textHeadingColor,
              ),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Column(
              children: [
                for (int i = 0; i < controller.education.length; i++)
                  pw.Row(
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 5),
                          child: PdfEducationHistoryWidget(
                            instituteName: controller.education[i].instituteName.text,
                            city: controller.education[i].city.text,
                            country: controller.education[i].country.text,
                            durationFontStyle: TextStylesPdf.bodyText10Simple,
                            title: controller.education[i].fieldOfStudy.text,
                            from: controller.education[i].startDate.text,
                            till: controller.education[i].endDate.text,
                            description: controller.education[i].description.text,
                          ))
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
        pw.Text(
          'Experience',
          style: pw.TextStyle(
            fontSize: 14,
            font: PwFonts.ttf700,
            color: AppPdfColor.textHeadingColor,
          ),
        ),
      ]),
      pw.SizedBox(height: 10),
      for (int i = 0; i < controller.employmentHistory.length; i++)
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 1,
              child: pw.Row(children: [
                pw.Text(
                  "${controller.employmentHistory[i].startDate.text.numericOnly()} - ",
                  style: pw.TextStyle(
                    fontSize: 12,
                    font: PwFonts.ttf600,
                    color: AppPdfColor.textRedColor,
                  ),
                ),
                pw.Text(
                  controller.employmentHistory[i].endDate.text.numericOnly(),
                  style: pw.TextStyle(
                    fontSize: 12,
                    font: PwFonts.ttf600,
                    color: AppPdfColor.textRedColor,
                  ),
                )
              ]),
            ),
            pw.Expanded(
              flex: 3,
              child: pw.Column(
                children: [
                  pw.Row(
                    children: [
                      PdfEmploymentHistoryWidget(
                        city: controller.employmentHistory[i].city.text,
                        country: controller.employmentHistory[i].country.text,
                        companyName: controller.employmentHistory[i].companyName.text,
                        durationFontStyle: TextStylesPdf.bodyText10Simple,
                        title: controller.employmentHistory[i].jobTitle.text,
                        from: controller.employmentHistory[i].startDate.text,
                        till: controller.employmentHistory[i].endDate.text,
                        description: controller.employmentHistory[i].description.text,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      pw.SizedBox(
        height: 10.0,
      ),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Skills',
                  style: pw.TextStyle(
                    fontSize: 14,
                    font: PwFonts.ttf700,
                    color: AppPdfColor.textHeadingColor,
                  ),
                ),
              ],
            ),
          ),
          pw.Flexible(
            flex: 3,
            child: pw.Wrap(
              runSpacing: 10,
              spacing: 20,
              alignment: pw.WrapAlignment.spaceBetween,
              verticalDirection: pw.VerticalDirection.down,
              direction: pw.Axis.horizontal,
              children: [
                for (int i = 0; i < controller.skills.length; i++)
                  PdfSkillCircullarWidget(
                    leftPadding: 0,
                    skill: controller.skills[i].keys.first.text,
                  ),
              ],
            ),
          ),
        ],
      ),
      pw.SizedBox(
        height: 10.0,
      ),
      if (controller.projects.isNotEmpty)
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Projects',
                    style: pw.TextStyle(
                      fontSize: 14,
                      font: PwFonts.ttf700,
                      color: AppPdfColor.textHeadingColor,
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
                flex: 3,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < controller.projects.length; i++)
                      PdfProjectWidget(
                        title: controller.projects[i].title.text,
                        description: controller.projects[i].description.text,
                      )
                  ],
                )),
          ],
        ),
      pw.SizedBox(
        height: 10.0,
      ),
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 1,
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (controller.reference.isNotEmpty)
                  pw.Text(
                    'Reference',
                    style: pw.TextStyle(
                      fontSize: 14,
                      font: PwFonts.ttf700,
                      color: AppPdfColor.textHeadingColor,
                    ),
                  ),
              ],
            ),
          ),
          pw.Expanded(
              flex: 3,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  for (int i = 0; i < controller.reference.length; i++)
                    PdfReferenceWidget(
                        personName: controller.reference[i].personName.text,
                        contactNumber: controller.reference[i].contactNumber.text,
                        referenceText: controller.reference[i].referenceText.text)
                ],
              )),
        ],
      ),
    ];

    return widgets;
  }
}
