import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../custom_widgets/custom_widgets.dart';
import '../pdf_custom_widgets/pdf_custom_widgets.dart';
import 'package:pdf/widgets.dart' as pw;
import '../utils/consts/api_consts.dart';
import '../utils/consts/constants.dart';
import '../../utils/app_functions.dart';
import 'controllers/templates_controller.dart';
import 'functions/upload_data_and_image.dart';
import 'package:crewdog_cv_lab/models/models.dart';

class V103 extends StatefulWidget {
  const V103({super.key});

  @override
  State<V103> createState() => _V103State();
}

class _V103State extends State<V103> {
  final controller = Get.put(TempController());
  bool isCanPop = true;
  File? selectedImage;


  @override
  Widget build(BuildContext context) {
    void openGallery() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        String cvImagePath = await uploadDataAndImage(
          pickedFile,
          token,
          'v103',
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
        child: Scaffold(
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_paws.png'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                children: [
                  const Text(
                    "Customise your CV",
                    style: kHeadingTextStyle600,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0XFFF2F2F2),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.lightBlue.shade100,
                                spreadRadius: 0.1,
                                blurRadius: 20),
                          ]),
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        controller.profilePicState
                                            ? const SizedBox()
                                            : GestureDetector(
                                                onTap: () {
                                                  openGallery();
                                                  controller.profilePicState =
                                                      true;
                                                },
                                                child: const Text("Add Image",
                                                    style: TextStyle(
                                                      color: Color(0XFFC6A4FF),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                                  controller.profilePicState =
                                                      false;
                                                  controller.cvImagePath = '';
                                                  controller.cvImage = File('');
                                                  selectedImage == null;
                                                  controller.isSsoUrl=false;
                                                  setState(() {});
                                                },
                                                child: const Text(
                                                    "Remove Image",
                                                    style: TextStyle(
                                                      color: Color(0XFFC6A4FF),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                              )
                                            : const SizedBox(),
                                        const SizedBox(height: 15),
                                        CustomEditableText(
                                          controller:
                                              controller.designationController,
                                          backgroundColor:
                                              const Color(0XFFF2F2F2),
                                          style: const TextStyle(
                                            color: Color(0XFF4E4949),
                                            fontSize: 8,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        CustomEditableText(
                                          controller: controller.mailController,
                                          backgroundColor:
                                              const Color(0XFFF2F2F2),
                                          style: const TextStyle(
                                            color: Color(0XFF4E4949),
                                            fontSize: 6,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        CustomEditableText(
                                          controller:
                                              controller.contactController,
                                          backgroundColor:
                                              const Color(0XFFF2F2F2),
                                          style: const TextStyle(
                                            color: Color(0XFF4E4949),
                                            fontSize: 6,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        CustomEditableText(
                                          controller:
                                              controller.addressController,
                                          backgroundColor:
                                              const Color(0XFFF2F2F2),
                                          style: const TextStyle(
                                            color: Color(0XFF4E4949),
                                            fontSize: 6,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        CustomEditableText(
                                          controller: controller.nameController,
                                          backgroundColor:
                                              const Color(0XFFF2F2F2),
                                          style: const TextStyle(
                                            color: Color(0XFF4E4949),
                                            fontSize: 19,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 5),
                                          decoration: BoxDecoration(
                                              color: const Color(0XFFE1E1E1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Profile",
                                                  style: TextStyle(
                                                    color: Color(0XFF4E4949),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                                const SizedBox(height: 3),
                                                CustomEditableText(
                                                  controller: controller
                                                      .personalInformation,
                                                  backgroundColor:
                                                      const Color(0XFFE1E1E1),
                                                  style: const TextStyle(
                                                    color: Color(0XFF4E4949),
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                              ]),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const Divider(
                                height: 20,
                                color: Color(0XFFE1E1E1),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      // flex: 5,
                                      child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  'Employment History',
                                                  style: TextStyle(
                                                    color: Color(0XFF4E4949),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                                const Spacer(),
                                                CvAddButton(
                                                  onTap: () {
                                                    setState(() {
                                                      controller
                                                          .employmentHistory
                                                          .add(
                                                        EmploymentHistory(
                                                          keyController:
                                                              GlobalKey(),
                                                          jobTitle:
                                                              TextEditingController(
                                                                  text:
                                                                      'Lorem Ipsum'),
                                                          description:
                                                              TextEditingController(
                                                                  text:
                                                                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type'),
                                                          endDate:
                                                              TextEditingController(
                                                                  text:
                                                                      'November 2015'),
                                                          startDate:
                                                              TextEditingController(
                                                                  text:
                                                                      'September 2019'),
                                                          city:
                                                              TextEditingController(
                                                                  text:
                                                                      'London'),
                                                          country:
                                                              TextEditingController(
                                                                  text: 'UK'),
                                                          companyName:
                                                              TextEditingController(
                                                                  text:
                                                                      'WhiteBox'),
                                                        ),
                                                      );
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5.0),
                                            for (int i = 0;
                                                i <
                                                    controller.employmentHistory
                                                        .length;
                                                i++)
                                              Row(
                                                children: [
                                                  EmploymentHistoryWidget(
                                                    isRemovable: controller
                                                            .employmentHistory
                                                            .length >
                                                        1,
                                                    backgroundColor:
                                                        const Color(0XFFF2F2F2),
                                                    durationFontSize: 8,
                                                    description: controller
                                                        .employmentHistory[i]
                                                        .description,
                                                    title: controller
                                                        .employmentHistory[i]
                                                        .jobTitle,
                                                    from: controller
                                                        .employmentHistory[i]
                                                        .startDate,
                                                    till: controller
                                                        .employmentHistory[i]
                                                        .endDate,
                                                    country: controller
                                                        .employmentHistory[i]
                                                        .country,
                                                    city: controller
                                                        .employmentHistory[i]
                                                        .city,
                                                    companyName: controller
                                                        .employmentHistory[i]
                                                        .companyName,
                                                    onRemoveTap: () {
                                                      setState(() {
                                                        controller
                                                            .employmentHistory
                                                            .removeAt(i);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            // const SizedBox(height: 5),

                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Education',
                                                  style: TextStyle(
                                                    color: Color(0XFF4E4949),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                                const Spacer(),
                                                CvAddButton(
                                                  onTap: () {
                                                    setState(() {
                                                      controller.education.add(
                                                        EducationHistory(
                                                          fieldOfStudy:
                                                              TextEditingController(
                                                                  text:
                                                                      'Lorem Ipsum is simply dummy text of the printing and'),
                                                          description:
                                                              TextEditingController(
                                                                  text:
                                                                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type'),
                                                          endDate:
                                                              TextEditingController(
                                                                  text:
                                                                      'November 2015'),
                                                          startDate:
                                                              TextEditingController(
                                                                  text:
                                                                      'September 2019'),
                                                          city:
                                                              TextEditingController(
                                                                  text:
                                                                      'London'),
                                                          country:
                                                              TextEditingController(
                                                                  text: 'UK'),
                                                          instituteName:
                                                              TextEditingController(
                                                                  text:
                                                                      'WhiteBox'),
                                                          keyController:
                                                              GlobalKey(),
                                                        ),
                                                      );
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5.0),
                                            for (int i = 0;
                                                i < controller.education.length;
                                                i++)
                                              Row(
                                                children: [
                                                  EducationHistoryWidget(
                                                    isRemovable: controller
                                                            .education.length >
                                                        1,
                                                    durationFontSize: 8,
                                                    backgroundColor:
                                                        const Color(0XFFF2F2F2),
                                                    description: controller
                                                        .education[i]
                                                        .description,
                                                    title: controller
                                                        .education[i]
                                                        .fieldOfStudy,
                                                    from: controller
                                                        .education[i].startDate,
                                                    till: controller
                                                        .education[i].endDate,
                                                    city: controller
                                                        .education[i].city,
                                                    country: controller
                                                        .education[i].country,
                                                    instituteName: controller
                                                        .education[i]
                                                        .instituteName,
                                                    onRemoveTap: () {
                                                      setState(() {
                                                        controller.education
                                                            .removeAt(i);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            const SizedBox(height: 10),
                                            if(controller.projects.isNotEmpty)
                                              Row(
                                              children: [
                                                const Text(
                                                  'Projects',
                                                  style: TextStyle(
                                                    color: Color(0XFF4E4949),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Inter',
                                                  ),
                                                ),
                                                const Spacer(),
                                                CvAddButton(
                                                  onTap: () {
                                                    setState(() {
                                                      controller.projects.add(Projects(
                                                          title: TextEditingController(
                                                              text:
                                                                  "Your project title"),
                                                          description:
                                                              TextEditingController(
                                                                  text:
                                                                      "Write your project description here")));
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            for (int i = 0;
                                                i < controller.projects.length;
                                                i++)
                                              ProjectWidget(
                                                isRemovable: controller.projects.length > 1,
                                                title: controller
                                                    .projects[i].title,
                                                description: controller
                                                    .projects[i].description,
                                                onRemoveTap: () {
                                                  setState(() {
                                                    controller.projects
                                                        .removeAt(i);
                                                  });
                                                },
                                              ),

                                            if(controller.projects.isNotEmpty) const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                if (controller
                                                    .reference.isNotEmpty)
                                                  const Text(
                                                    'Reference',
                                                    style: TextStyle(
                                                      color: Color(0XFF4E4949),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: 'Inter',
                                                    ),
                                                  ),
                                                const Spacer(),
                                                CvAddButton(
                                                  buttonText: controller
                                                          .reference.isNotEmpty
                                                      ? "Add"
                                                      : "Add Reference",
                                                  onTap: () {
                                                    setState(() {
                                                      controller.reference.add(References(
                                                          personName:
                                                              TextEditingController(
                                                                  text:
                                                                      "Reference Name"),
                                                          contactNumber:
                                                              TextEditingController(
                                                                  text:
                                                                      "Contact Number"),
                                                          referenceText:
                                                              TextEditingController(
                                                                  text:
                                                                      "Reference Text")));
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        controller
                                                            .reference.length;
                                                    i++)
                                                  ReferenceWidget(
                                                    personName: controller
                                                        .reference[i]
                                                        .personName,
                                                    contactNumber: controller
                                                        .reference[i]
                                                        .contactNumber,
                                                    referenceText: controller
                                                        .reference[i]
                                                        .referenceText,
                                                    onRemoveTap: () {
                                                      setState(() {
                                                        controller.reference
                                                            .removeAt(i);
                                                      });
                                                    },
                                                  )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      // const SizedBox(width: 2),
                                      Flexible(
                                          flex: 2,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: const Color(0XFFE1E1E1),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Skills',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0XFF4E4949),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'Inter',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 5),
                                                for (int i = 0;
                                                    i <
                                                        controller
                                                            .skills.length;
                                                    i++)
                                                  SkillCircullarWidget(
                                                    isRemovable: controller
                                                            .skills.length >
                                                        1,
                                                    leftPadding: 0,
                                                    skill: controller
                                                        .skills[i].keys.first,
                                                    onButtonTap: () {
                                                      setState(() {
                                                        controller.skills
                                                            .removeAt(i);
                                                      });
                                                    },
                                                  ),
                                                CvAddButton(
                                                  onTap: () {
                                                    setState(() {
                                                      controller.skills.add({
                                                        TextEditingController(
                                                            text:
                                                                "Your Skill"): 0.7
                                                      });
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ))
                                    ],
                                  )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SaveDownloadButtonsRow(
                    isUpdateCV: controller.saveCvId != 0,
                    onSavePressed: () async {
                      if (controller.saveCvId != 0) {
                        await controller.updateCv(
                            ('v103'), controller.saveCvId);
                      } else {
                        await controller.saveCv('v103');
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
                          buildTemplate5Pdf(
                            controller,
                            netImage,
                          ),
                          controller.nameController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  List<pw.Widget> buildTemplate5Pdf(
    TempController controller,
    pw.ImageProvider netImage,
  ) {
    List<pw.Widget> widgets = [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Flexible(
            flex: 2,
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.ClipOval(
                      child: pw.SizedBox(
                        height: 70,
                        width: 70,
                        child: (!controller.profilePicState)
                            ? pw.SizedBox()
                            : controller.cvImagePath.isNotEmpty
                                ? pw.Image(netImage, fit: pw.BoxFit.cover)
                                : pw.Image(
                                    pw.MemoryImage(PwAssets.cvDemoImage)),
                      ),
                    )
                  ],
                ),
                pw.SizedBox(height: 15),
                pw.Text(
                  controller.designationController.text,
                  style: TextStylesPdf.bodyText12w600,
                ),
                pw.Text(controller.mailController.text,
                    style: TextStylesPdf.bodyText12Simple),
                pw.Text(controller.contactController.text,
                    style: TextStylesPdf.bodyText12Simple),
                pw.Text(controller.addressController.text,
                    style: TextStylesPdf.bodyText12Simple),
              ],
            ),
          ),
          pw.SizedBox(width: 15),
          pw.Flexible(
            flex: 6,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  controller.nameController.text,
                  textAlign: pw.TextAlign.start,
                  style: TextStylesPdf.headingText22w700,
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 10, top: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Profile',
                          style: TextStylesPdf.headingText20w600),
                      pw.SizedBox(height: 3),
                      pw.Text(controller.personalInformation.text,
                          style: TextStylesPdf.bodyText12w500),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      pw.Divider(
        height: 20,
        color: AppPdfColor.pdfDividerColor,
      ),
      pw.Partitions(
        children: [
          pw.Partition(
            flex: 6,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text('Employment History',
                    style: TextStylesPdf.headingText20w600),
                pw.SizedBox(height: 5),
                for (int i = 0; i < controller.employmentHistory.length; i++)
                  pw.Row(
                    children: [
                      PdfEmploymentHistoryWidget(
                        city: controller.employmentHistory[i].city.text,
                        country: controller.employmentHistory[i].country.text,
                        companyName:
                            controller.employmentHistory[i].companyName.text,
                        durationFontStyle: TextStylesPdf.bodyText10Simple,
                        title: controller.employmentHistory[i].jobTitle.text,
                        from: controller.employmentHistory[i].startDate.text,
                        till: controller.employmentHistory[i].endDate.text,
                        description:
                            controller.employmentHistory[i].description.text,
                      )
                    ],
                  ),
                pw.SizedBox(height: 5),
                pw.Text('Education', style: TextStylesPdf.headingText20w600),
                pw.SizedBox(height: 5),
                for (int i = 0; i < controller.education.length; i++)
                  pw.Row(
                    children: [
                      PdfEducationHistoryWidget(
                        instituteName:
                            controller.education[i].instituteName.text,
                        city: controller.education[i].city.text,
                        country: controller.education[i].country.text,
                        durationFontStyle: TextStylesPdf.bodyText10Simple,
                        title: controller.education[i].fieldOfStudy.text,
                        from: controller.education[i].startDate.text,
                        till: controller.education[i].endDate.text,
                        description: controller.education[i].description.text,
                      )
                    ],
                  ),
                pw.SizedBox(height: 5),
                if(controller.projects.isNotEmpty)
                  pw.Text(
                  'Projects',
                  style: TextStylesPdf.headingText20w600,
                ),
                if(controller.projects.isNotEmpty) pw.SizedBox(height: 5),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < controller.projects.length; i++)
                      PdfProjectWidget(
                        title: controller.projects[i].title.text,
                        description: controller.projects[i].description.text,
                      )
                  ],
                ),
                pw.SizedBox(height: 5),
                if (controller.reference.isNotEmpty)
                  pw.Text(
                    'Reference',
                    style: TextStylesPdf.headingText20w600,
                  ),
                pw.SizedBox(height: 5),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < controller.reference.length; i++)
                      PdfReferenceWidget(
                          personName: controller.reference[i].personName.text,
                          contactNumber:
                              controller.reference[i].contactNumber.text,
                          referenceText:
                              controller.reference[i].referenceText.text)
                  ],
                )
              ],
            ),
          ),
          pw.Partition(
            flex: 2,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Skills', style: TextStylesPdf.headingText20w600),
                pw.SizedBox(height: 5),
                for (int i = 0; i < controller.skills.length; i++)
                  PdfSkillCircullarWidget(
                    leftPadding: 0,
                    skill: controller.skills[i].keys.first.text,
                  ),
              ],
            ),
          )
        ],
      )
    ];

    return widgets;
  }
}
