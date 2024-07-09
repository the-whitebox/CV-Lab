import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../custom_widgets/custom_editable_text.dart';
import '../../pdf_custom_widgets/pdf_skill_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../pdf_custom_widgets/pw_assets.dart';
import '../utils/consts/api_consts.dart';
import '../utils/consts/constants.dart';
import '../../utils/app_functions.dart';
import 'controllers/templates_controller.dart';
import '../../custom_widgets/custom_button_row.dart';
import '../../custom_widgets/cv_add_button.dart';
import '../../custom_widgets/education_history_widget.dart';
import '../../custom_widgets/employment_history_widget.dart';
import '../../custom_widgets/project_history_widget.dart';
import '../../custom_widgets/reference_widget.dart';
import '../../custom_widgets/skill_custom_widget.dart';
import '../../pdf_custom_widgets/pdf_education_history.dart';
import '../../pdf_custom_widgets/pdf_employment_history.dart';
import '../../pdf_custom_widgets/pdf_project_widget.dart';
import '../../pdf_custom_widgets/pdf_reference_widget.dart';
import 'controllers/upload_data_and_image.dart';

class V104 extends StatefulWidget {
  const V104({super.key});

  @override
  State<V104> createState() => _V104State();
}

class _V104State extends State<V104> {
  final controller = Get.put(TempController());
  bool isCanPop=true;
  File? selectedImage;



  @override
  Widget build(BuildContext context) {
    return PopScope(

        canPop: isCanPop,
        onPopInvoked: (didPop) {
          if (didPop && controller.isChatData == true) {
            print("Came from Home Screen");
            isCanPop=false;
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
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(color: Colors.lightBlue.shade100, spreadRadius: 0.1, blurRadius: 20),
                  ]),
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      height: 46,
                                      width: 46,
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

                              ],
                            ),
                            const SizedBox(width: 5.0),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomEditableText(
                                    controller: controller.nameController,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: Color(0xFF4E4949),
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  CustomEditableText(
                                    controller: controller.designationController,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: Color(0xFF4E4949),
                                      fontSize: 6,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        controller.profilePicState
                            ? GestureDetector(
                          onTap: () {
                            controller.profilePicState = false;
                            controller.cvImagePath = '';
                            controller.cvImage = File('');
                            selectedImage == null;
                            controller.isSsoUrl=false;
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
                        const SizedBox(height: 10.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Image.asset('assets/images/person.png', width: 10, height: 8),
                                      const SizedBox(
                                        width: 2.0,
                                      ),
                                      const Text(
                                        'Profile',
                                        style: TextStyle(
                                          color: Color(0xFF4E4949),
                                          fontSize: 10,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      // const SizedBox(width: 6),
                                      Expanded(
                                        child: CustomEditableText(
                                          controller: controller.personalInformation,
                                          style: const TextStyle(
                                            color: Color(0xFF4E4949),
                                            fontSize: 8,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Image.asset('assets/images/bag.png', width: 10, height: 8),
                                      const SizedBox(
                                        width: 2.0,
                                      ),
                                      const Text(
                                        'Employment History',
                                        style: TextStyle(
                                          color: Color(0xFF4E4949),
                                          fontSize: 10,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      CvAddButton(
                                        onTap: () {
                                          setState(() {
                                            controller.employmentHistory.add(
                                              EmploymentHistory(
                                                keyController: GlobalKey(),
                                                jobTitle: TextEditingController(
                                                    text:
                                                    'Lorem Ipsum'),
                                                description: TextEditingController(
                                                    text:
                                                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type'),
                                                endDate:
                                                TextEditingController(text: 'November 2015'),
                                                startDate:
                                                TextEditingController(text: 'September 2019'),
                                                city: TextEditingController(text: 'Lorem Ipsum'),
                                                country: TextEditingController(text: 'Lorem Ipsum'),
                                                companyName:
                                                TextEditingController(text: 'Lorem Ipsum'),
                                              ),
                                            );
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  for (int i = 0; i < controller.employmentHistory.length; i++)
                                    Row(
                                      children: [
                                        EmploymentHistoryWidget(
                                          isRemovable: controller.employmentHistory.length>1,
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
                                        )
                                      ],
                                    ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Image.asset('assets/images/hat.png', width: 10, height: 8),
                                      const SizedBox(
                                        width: 2.0,
                                      ),
                                      const Text(
                                        'Education',
                                        style: TextStyle(
                                          color: Color(0xFF4E4949),
                                          fontSize: 10,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      CvAddButton(
                                        onTap: () {
                                          setState(() {
                                            controller.education.add(
                                              EducationHistory(
                                                fieldOfStudy: TextEditingController(
                                                    text:
                                                    'Lorem Ipsum'),
                                                description: TextEditingController(
                                                    text:
                                                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type'),
                                                endDate:
                                                TextEditingController(text: 'November 2015'),
                                                startDate:
                                                TextEditingController(text: 'September 2019'),
                                                city: TextEditingController(text: 'Lorem Ipsum'),
                                                country: TextEditingController(text: 'Lorem Ipsum'),
                                                instituteName:
                                                TextEditingController(text: 'Lorem Ipsum'),
                                                keyController: GlobalKey(),
                                              ),
                                            );
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5.0),
                                  for (int i = 0; i < controller.education.length; i++)
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        EducationHistoryWidget(
                                          isRemovable: controller.education.length>1,
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
                                  const SizedBox(height: 5.0),
                                  if(controller.projects.isNotEmpty)
                                    Row(
                                    children: [
                                      Image.asset('assets/images/hat.png', width: 10, height: 8),
                                      const SizedBox(
                                        width: 2.0,
                                      ),
                                      const Text(
                                        'Projects',
                                        style: TextStyle(
                                          color: Color(0xFF4E4949),
                                          fontSize: 10,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
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
                                  if(controller.projects.isNotEmpty)
                                    const SizedBox(height: 5),
                                  for (int i = 0; i < controller.projects.length; i++)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ProjectWidget(
                                            isRemovable: controller.projects.length > 1,
                                            title: controller.projects[i].title,
                                            description: controller.projects[i].description,
                                            onRemoveTap: () {
                                              setState(() {
                                                controller.projects.removeAt(i);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      if(controller.reference.isNotEmpty)   Row(
                                        children: [
                                          Image.asset('assets/images/speaker.png',
                                              width: 10, height: 8),
                                          const SizedBox(
                                            width: 2.0,
                                          ),
                                          const Text(
                                            'Reference',
                                            style: TextStyle(
                                              color: Color(0xFF4E4949),
                                              fontSize: 10,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      CvAddButton(
                                        buttonText: controller.reference.isNotEmpty ?"Add":"Add Reference",
                                        onTap: () {
                                          setState(() {
                                            controller.reference.add(
                                                References(
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
                                  const SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Expanded(
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
                            const SizedBox(width: 5.0),
                            Flexible(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Details',
                                    style: TextStyle(
                                      color: Color(0xFF4E4949),
                                      fontSize: 10,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  CustomEditableText(
                                    controller: controller.addressController,
                                    style: const TextStyle(
                                      color: Color(0xFF4E4949),
                                      fontSize: 6,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  CustomEditableText(
                                    controller: controller.contactController,
                                    style: const TextStyle(
                                      color: Color(0xFF4E4949),
                                      fontSize: 6,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  CustomEditableText(
                                    controller: controller.mailController,
                                    style: const TextStyle(
                                      color: Color(0xFF4E4949),
                                      fontSize: 6,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Skills',
                                    style: TextStyle(
                                      color: Color(0xFF4E4949),
                                      fontSize: 10,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  for (int i = 0; i < controller.skills.length; i++)
                                    SkillCircullarWidget(
                                      isRemovable: controller.skills.length>1,
                                      leftPadding: 0,
                                      skill: controller.skills[i].keys.first,
                                      onButtonTap: () {
                                        setState(() {
                                          controller.skills.removeAt(i);
                                        });
                                      },
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CvAddButton(
                                      onTap: () {
                                        setState(() {
                                          controller.skills.add(
                                              {TextEditingController(text: "Your Skill"): 0.7});
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
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
                isUpdateCV: controller.saveCvId!=0,
                onSavePressed: () async {
                  if(controller.saveCvId!=0) {
                    await controller.updateCv(('v104'), controller.saveCvId);
                  }else{
                    await controller.saveCv('v104');
                  }
                },
                onDownloadPressed: () async {
                  await PwAssets.initializeAssets();
                  await PwFonts.initializeFonts();
                  pw.ImageProvider   netImage= await networkImage('https://cvlab.crewdog.ai/static/media/profilepic.1854a1d1129a7d85e324.png');
                  if(controller.cvImagePath.isNotEmpty){
                    netImage =controller.isSsoUrl? await networkImage('$ssoUrl${controller.cvImagePath}'): await networkImage('$baseUrl${controller.cvImagePath}');
                  }
                  await makePdf(buildTemplate2Pdf(controller,netImage), controller.nameController.text);
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
        'v104',
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

  List<pw.Widget> buildTemplate2Pdf(TempController controller,pw.ImageProvider netImage) {
    List<pw.Widget> widgets = [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          controller.profilePicState?   pw.ClipOval(
            child: pw.SizedBox(
              height: 60,
              width: 60,
              child: controller.cvImagePath.isNotEmpty
                  ? pw.Image(netImage, fit: pw.BoxFit.cover)
                  : pw.Image(pw.MemoryImage(PwAssets.cvDemoImage)),
            ),
          ):pw.SizedBox(),
          pw.SizedBox(width: 10.0),
          pw.Expanded(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(controller.nameController.text, style: TextStylesPdf.headingText20w500),
                pw.SizedBox(
                  height: 5.0,
                ),
                pw.Text(controller.designationController.text,
                    style: TextStylesPdf.bodyText10Simple),
              ],
            ),
          ),
        ],
      ),
      pw.SizedBox(height: 20.0),
      pw.Partitions(
        // crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Partition(
            flex: 3,
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Image(pw.MemoryImage(PwAssets.personImage), height: 12, width: 14),
                    pw.SizedBox(
                      width: 2.0,
                    ),
                    pw.Text('Profile', style: TextStylesPdf.headingText14w600),
                  ],
                ),
                pw.SizedBox(height: 5.0),
                pw.Row(
                  children: [
                    pw.SizedBox(
                      width: 350,
                      child: pw.Expanded(
                        child: pw.Text(
                          controller.personalInformation.text,
                          style: TextStylesPdf.bodyText12Simple,
                        ),
                      ),
                    )
                    // const SizedBox(width: 18.0),
                  ],
                ),
                pw.SizedBox(height: 10.0),
                pw.Row(
                  children: [
                    pw.Image(pw.MemoryImage(PwAssets.bagImage), height: 12, width: 14),
                    pw.SizedBox(
                      width: 2.0,
                    ),
                    pw.Text('Employment History', style: TextStylesPdf.headingText14w600),
                  ],
                ),
                pw.SizedBox(height: 5.0),
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
                pw.SizedBox(height: 10.0),
                pw.Row(
                  children: [
                    pw.Image(pw.MemoryImage(PwAssets.hatImage), height: 12, width: 14),
                    pw.SizedBox(
                      width: 2.0,
                    ),
                    pw.Text('Education', style: TextStylesPdf.headingText14w600),
                  ],
                ),
                pw.SizedBox(height: 5.0),
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
                if(controller.projects.isNotEmpty)
                  pw.SizedBox(height: 10.0),
                if(controller.projects.isNotEmpty)
                  pw.Row(
                  children: [
                    pw.Image(pw.MemoryImage(PwAssets.hatImage), height: 12, width: 14),
                    pw.SizedBox(
                      width: 2.0,
                    ),
                    pw.Text('Projects', style: TextStylesPdf.headingText14w600),
                  ],
                ),
                pw.SizedBox(height: 5.0),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      for (int i = 0; i < controller.projects.length; i++)
                        pw.SizedBox(
                            width: 360,
                            child:PdfProjectWidget(
                              title: controller.projects[i].title.text,
                              description: controller.projects[i].description.text,
                            )
                        )
                    ],
                  )
                ]),
                pw.SizedBox(height: 10.0),
                if( controller.reference.isNotEmpty)    pw.Row(
                  children: [
                    pw.Image(pw.MemoryImage(PwAssets.speakerImage), height: 12, width: 14),
                    pw.SizedBox(
                      width: 2.0,
                    ),
                    pw.Text('Reference', style: TextStylesPdf.headingText14w600),
                  ],
                ),
                pw.SizedBox(height: 5.0),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.start, children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      for (int i = 0; i < controller.reference.length; i++)
                        pw.SizedBox(
                            width: 360,
                            child:PdfReferenceWidget(
                                personName: controller.reference[i].personName.text,
                                contactNumber: controller.reference[i].contactNumber.text,
                                referenceText: controller.reference[i].referenceText.text)
                        )
                    ],
                  )
                ])
              ],
            ),
          ),
          // pw.SizedBox(width: 5.0),
          pw.Partition(
              flex: 1,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Details', style: TextStylesPdf.headingText14w600),
                  pw.SizedBox(height: 8.0),
                  pw.Text(controller.addressController.text,
                      style: TextStylesPdf.bodyText12w500),
                  pw.SizedBox(height: 5.0),
                  pw.Text(controller.contactController.text,
                      style: TextStylesPdf.bodyText12w500),
                  pw.SizedBox(height: 5.0),
                  pw.Text(controller.mailController.text, style: TextStylesPdf.bodyText12w500),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Text('Skills', style: TextStylesPdf.headingText14w600),
                  pw.SizedBox(height: 8.0),
                  for (int i = 0; i < controller.skills.length; i++)
                    PdfSkillCircullarWidget(
                      leftPadding: 0,
                      skill: controller.skills[i].keys.first.text,
                    ),

                ],
              )),
        ],
      ),
    ];
    return widgets;
  }
}
