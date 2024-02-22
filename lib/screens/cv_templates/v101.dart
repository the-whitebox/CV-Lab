import 'package:crewdog_cv_lab/screens/cv_templates/controllers/temp_controller.dart';
import 'package:crewdog_cv_lab/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'dart:io';
import '../../custom_widgets/custom_widgets.dart';
import '../../custom_widgets/pdf_custom_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../custom_widgets/pw_assets.dart';
import '../../utils/constants.dart';
import '../../utils/functions.dart';
import '../controllers/profile_controller.dart';

class V101 extends StatefulWidget {
  const V101({super.key});


  @override
  State<V101> createState() => _V101State();
}

class _V101State extends State<V101> {

  final controller = Get.put(TempController());
  bool receivedValue = Get.arguments==null?false:true;
  File? selectedImage;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
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
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Colors.lightBlue.shade100, spreadRadius: 0.1, blurRadius: 20),
                  ], color: Colors.white),
                  padding: const EdgeInsets.all(8.0),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 4,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 10),
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
                                                    ? NetworkImage(
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
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomEditableText(
                                          backgroundColor: const Color(0XFFe5e5fb),
                                          controller: controller.addressController,
                                          style: const TextStyle(
                                            color: Color(0XFF878787),
                                            fontSize: 8,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Wrap(
                                          children: [
                                            CustomEditableText(
                                              horizontalPadding: 1,
                                              controller: controller.contactController,
                                              backgroundColor: const Color(0XFFe5e5fb),
                                              style: const TextStyle(
                                                color: Color(0XFF878787),
                                                fontSize: 8,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            CustomEditableText(
                                              horizontalPadding: 1,
                                              controller: controller.mailController,
                                              backgroundColor: const Color(0XFFe5e5fb),
                                              style: const TextStyle(
                                                color: Color(0XFF878787),
                                                fontSize: 8,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Wrap(
                                          children: [
                                            CustomEditableText(
                                              backgroundColor: const Color(0XFFe5e5fb),
                                              horizontalPadding: 0,
                                              rightMargin: 0,
                                              controller: controller.nameController,
                                              // textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                color: Color(0XFF4E4949),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                            const Text(
                                              ", ",
                                              style: TextStyle(
                                                color: Color(0XFF4E4949),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                            CustomEditableText(
                                              backgroundColor: const Color(0XFFe5e5fb),
                                              horizontalPadding: 0,
                                              rightMargin: 0,
                                              controller: controller.designationController,
                                              textAlign: TextAlign.start,
                                              style: const TextStyle(
                                                color: Color(0XFF4E4949),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                            // const Flexible(child: SizedBox())
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomEditableText(
                                                backgroundColor: const Color(0XFFe7e7fb),
                                                controller: controller.personalInformation,
                                                style: const TextStyle(
                                                  color: Color(0XFF4E4949),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Inter',
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 3),
                                  const Text(
                                    "Skills",
                                    style: TextStyle(
                                      color: Color(0XFF878787),
                                      fontSize: 7,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  CvAddButton(
                                    onTap: () {
                                      setState(() {
                                        controller.skills
                                            .add({TextEditingController(text: "Your Skill"): 0.7});
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
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 2.5,
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (context, index) {
                                  return SkillCircullarWidget(
                                    isRemovable: controller.skills.length>1,
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
                        // const SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 3),
                                  const Text(
                                    "Employment History",
                                    style: TextStyle(
                                      color: Color(0XFF878787),
                                      fontSize: 7,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  CvAddButton(
                                    onTap: () {
                                      setState(() {
                                        controller.employmentHistory.add(EmploymentHistory(
                                          jobTitle: TextEditingController(text: 'Lorem Ipsum'),
                                          description: TextEditingController(
                                              text:
                                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type'),
                                          endDate: TextEditingController(text: 'November 2015'),
                                          startDate: TextEditingController(text: 'September 2019'),
                                          city: TextEditingController(text: 'Lorem Ipsum'),
                                          country: TextEditingController(text: 'Lorem Ipsum'),
                                          companyName: TextEditingController(text: 'Lorem Ipsum'),
                                        ));
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  for (int i = 0; i < controller.employmentHistory.length; i++)
                                    Row(
                                      children: [
                                        EmploymentHistoryWidget(
                                          isRemovable: controller.employmentHistory.length>1,

                                          backgroundColor: const Color(0Xffececfc),
                                          titleFontSize: 10,
                                          durationFontSize: 7,
                                          description: controller.employmentHistory[i].description,
                                          title: controller.employmentHistory[i].jobTitle,
                                          from: controller.employmentHistory[i].startDate,
                                          till: controller.employmentHistory[i].endDate,
                                          country: controller.employmentHistory[i].country,
                                          city: controller.employmentHistory[i].city,
                                          companyName: controller.employmentHistory[i].companyName,
                                          onRemoveTap: () {
                                            setState(() {
                                              controller.employmentHistory.removeAt(i);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 10.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 3),
                                  const Text(
                                    "Education History",
                                    style: TextStyle(
                                      color: Color(0XFF878787),
                                      fontSize: 7,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  CvAddButton(
                                    onTap: () {
                                      setState(() {
                                        controller.education.add(
                                          EducationHistory(
                                            fieldOfStudy:
                                            TextEditingController(text: "Lorem Ipsum"),
                                            city: TextEditingController(text: "Lorem Ipsum"),
                                            country: TextEditingController(text: "Lorem Ipsum"),
                                            instituteName:
                                            TextEditingController(text: "Lorem Ipsum"),
                                            description: TextEditingController(
                                                text: "Your Education History Description"),
                                            endDate: TextEditingController(text: "End Date"),
                                            startDate: TextEditingController(text: "Start Date"),
                                          ),
                                        );
                                      });
                                    },
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
                                          isRemovable: controller.education.length>1,

                                          backgroundColor: const Color(0Xfff3f3fd),
                                          titleFontSize: 10,
                                          durationFontSize: 7,
                                          description: controller.education[i].description,
                                          title: controller.education[i].fieldOfStudy,
                                          from: controller.education[i].startDate,
                                          till: controller.education[i].endDate,
                                          city: controller.education[i].city,
                                          country: controller.education[i].country,
                                          instituteName: controller.education[i].instituteName,
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
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Projects",
                                    style: TextStyle(
                                      color: Color(0XFF878787),
                                      fontSize: 7,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  CvAddButton(
                                    onTap: () {
                                      setState(() {
                                        controller.projects.add(
                                            Projects(title: TextEditingController(text: "Your project title"), description: TextEditingController(text: "Write your project description here"))
                                        );
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
                                children: [
                                  for (int i = 0; i < controller.projects.length; i++)
                                    ProjectWidget(
                                      isRemovable: controller.projects.length>1,
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

                        const SizedBox(height: 2),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if(controller.reference.isNotEmpty)     const Text(
                                    "Reference",
                                    style: TextStyle(
                                      color: Color(0XFF878787),
                                      fontSize: 7,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  CvAddButton(
                                    buttonText: controller.reference.isNotEmpty ?"Add":"Add\nReference",
                                    onTap: () {
                                      setState(() {
                                        controller.reference.add(References(
                                            personName:
                                            TextEditingController(text: "Reference Name"),
                                            contactNumber:
                                            TextEditingController(text: "Contact Number"),
                                            referenceText:
                                            TextEditingController(text: "Reference Text")));
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
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              SaveDownloadButtonsRow(
                isUpdateCV: controller.saveCvId != 0,
                onSavePressed: () async {
                  if (controller.saveCvId != 0) {
                    await controller.updateCv(('v101'), controller.saveCvId);
                    controller.refreshController();
                  } else {
                    await controller.saveCv('v101');
                    controller.refreshController();
                  }
                },
                onDownloadPressed: () async {
                  await requestPermissions();
                  await PwAssets.initializeAssets();
                  await PwFonts.initializeFonts();
                  pw.ImageProvider netImage = await networkImage(
                      'https://cvlab.crewdog.ai/static/media/profilepic.1854a1d1129a7d85e324.png');
                  if (controller.cvImagePath.isNotEmpty) {
                    netImage = await networkImage('$baseUrl${controller.cvImagePath}');
                  }
                  await makePdf(
                      buildTemplate4Pdf(controller, netImage), controller.nameController.text);
                  controller.refreshController();
                  Get.back();
                  appSuccessSnackBar("Success", 'Your CV has been Downloaded');
                },
              ),
            ],
          ),
        ),
      ),
    ), onWillPop: () async {

      if(receivedValue==true){
        print("Came from Home Screen");
      }
      else{
        controller.refreshController();
      }
      return Future.value(true);
    },);
  }

  void openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String cvImagePath = await uploadDataAndImage(
        pickedFile,
        token,
        'v101',
        userId,
      );
      setState(() {
        selectedImage = File(pickedFile.path);
        controller.cvImage = File(pickedFile.path);
        controller.cvImagePath = '/media/$cvImagePath';
      });
    }
  }

  pw.Widget buildTemplate4Pdf(TempController controller, pw.ImageProvider netImage) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      width: double.infinity,
      color: PdfColors.white,
      child: pw.Column(
        children: [
          pw.Row(
            children: [
              pw.Flexible(
                flex: 4,
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Flexible(
                      flex: 1,
                      child: pw.Row(
                        children: [
                          pw.ClipOval(
                            child: pw.SizedBox(
                              height: 70,
                              width: 70,
                              child: (!controller.profilePicState)
                                  ? pw.SizedBox()
                                  : controller.cvImagePath.isNotEmpty
                                      ? pw.Image(netImage, fit: pw.BoxFit.cover)
                                      : pw.Image(pw.MemoryImage(PwAssets.cvDemoImage)),
                            ),
                          )
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 5),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(controller.addressController.text,
                              textAlign: pw.TextAlign.start,
                              style: TextStylesPdf.bodyText12SimpleGrey),
                          pw.SizedBox(height: 5),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text(controller.contactController.text,
                                    textAlign: pw.TextAlign.start,
                                    style: TextStylesPdf.bodyText12SimpleGrey),
                              ),
                              pw.SizedBox(width: 10),
                              pw.Expanded(
                                flex: 5,
                                child: pw.Text(controller.mailController.text,
                                    textAlign: pw.TextAlign.start,
                                    style: TextStylesPdf.bodyText12SimpleGrey),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 10),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Flexible(
                                flex: 5,
                                child: pw.Text('${controller.nameController.text},',
                                    textAlign: pw.TextAlign.start,
                                    style: TextStylesPdf.headingText16w700),
                              ),
                              pw.Flexible(
                                flex: 3,
                                child: pw.Text(controller.designationController.text,
                                    textAlign: pw.TextAlign.start,
                                    style: TextStylesPdf.headingText16w700),
                              ),
                              pw.Flexible(child: pw.SizedBox())
                            ],
                          ),
                          pw.SizedBox(height: 10.0),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Text(controller.personalInformation.text,
                                    textAlign: pw.TextAlign.start,
                                    style: TextStylesPdf.bodyText14w500),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 1,
                child: pw.Text("Skills", style: TextStylesPdf.bodyText11SimpleGrey),
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
                        skill: controller.skills[i].keys.first.text,
                      ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 15),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 1,
                child: pw.Text("Employment History", style: TextStylesPdf.bodyText11SimpleGrey),
              ),
              pw.Expanded(
                flex: 3,
                child: pw.Column(
                  children: [
                    for (int i = 0; i < controller.employmentHistory.length; i++)
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
          pw.SizedBox(height: 8),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 1,
                child: pw.Text("Education", style: TextStylesPdf.bodyText11SimpleGrey),
              ),
              pw.Expanded(
                  flex: 3,
                  child: pw.Column(children: [
                    for (int i = 0; i < controller.education.length; i++)
                      pw.Row(
                        children: [
                          PdfEducationHistoryWidget(
                            instituteName: controller.education[i].instituteName.text,
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
                  ])),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 1,
                child: pw.Text("Projects", style: TextStylesPdf.bodyText11SimpleGrey),
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
          pw.SizedBox(height: 8),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
             if( controller.reference.isNotEmpty)   pw.Expanded(
                flex: 1,
                child: pw.Text("Reference", style: TextStylesPdf.bodyText11SimpleGrey),
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
          pw.SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
