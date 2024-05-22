import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';
import '../../custom_widgets/custom_editable_text.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../pdf_custom_widgets/pdf_skill_widget.dart';
import '../../pdf_custom_widgets/pw_assets.dart';
import '../../utils/constants.dart';
import '../../utils/app_functions.dart';
import '../../controllers/profile_controller.dart';
import 'controllers/templates_controller.dart';
import '../../custom_widgets/custom_button_row.dart';
import '../../custom_widgets/cv_add_button.dart';
import '../../custom_widgets/project_history_widget.dart';
import '../../custom_widgets/reference_widget.dart';
import '../../custom_widgets/skill_custom_widget.dart';
import '../../pdf_custom_widgets/pdf_project_widget.dart';
import '../../pdf_custom_widgets/pdf_reference_widget.dart';

class V105 extends StatefulWidget {
  const V105({super.key});

  @override
  State<V105> createState() => _V105State();
}

class _V105State extends State<V105> {
  final controller = Get.put(TempController());
  File? selectedImage;
  bool isCanPop=true;


  void openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String cvImagePath = await uploadDataAndImage(
        pickedFile,
        token,
        'v105',
        userId,
      );
      setState(() {
        selectedImage = File(pickedFile.path);
        controller.cvImage = File(pickedFile.path);
        controller.cvImagePath = '/media/$cvImagePath';
        controller.isSsoUrl=false;
      });
    }
  }


  // @override
  // void initState() {
  //   super.initState();
  //   controller.cvImagePath = getProfilePic();
  //   if (controller.cvImagePath.contains("https://cvlab-staging-backend.crewdog.ai")) {
  //     controller.cvImagePath = controller.cvImagePath.substring(40);
  //   }
  // }

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
                child: Container(
                  decoration: BoxDecoration(color: const Color(0XFFFFFFff), boxShadow: [
                    BoxShadow(color: Colors.lightBlue.shade100, spreadRadius: 0.1, blurRadius: 20),
                  ]),
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                          child: SizedBox(
                            height: 46,
                            width: 46,
                            child: ClipOval(
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
                        Row(
                          children: [
                            Expanded(
                                child: CustomEditableText(
                                  controller: controller.nameController,
                                  textAlign: TextAlign.end,
                                  rightMargin: 0,
                                  horizontalPadding: 0,
                                  style: const TextStyle(
                                    color: Color(0XFF4E4949),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                  ),
                                )),
                            const Text(
                              ', ',
                              style: TextStyle(
                                color: Color(0XFF4E4949),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Expanded(
                                child: CustomEditableText(
                                  controller: controller.designationController,
                                  textAlign: TextAlign.start,
                                  horizontalPadding: 0,
                                  style: const TextStyle(
                                    color: Color(0XFF4E4949),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Inter',
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex:3,
                              child: CustomEditableText(
                                controller: controller.addressController,
                                rightMargin: 0,
                                horizontalPadding: 1,
                                style: const TextStyle(
                                  color: Color(0XFF4E4949),
                                  fontSize: 7,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            const Text(
                              ',  ',
                              style: TextStyle(
                                color: Color(0XFF4E4949),
                                fontSize: 7,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Flexible(

                              child: CustomEditableText(
                                textAlign: TextAlign.center,
                                controller: controller.contactController,
                                rightMargin: 0,
                                horizontalPadding: 1,
                                style: const TextStyle(
                                  color: Color(0XFF4E4949),
                                  fontSize: 7,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            const Text(
                              ',  ',
                              style: TextStyle(
                                color: Color(0XFF4E4949),
                                fontSize: 7,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Inter',
                              ),
                            ),
                            Flexible(
                              child: CustomEditableText(
                                textAlign: TextAlign.end,
                                controller: controller.mailController,
                                rightMargin: 0,
                                horizontalPadding: 1,
                                style: const TextStyle(
                                  color: Color(0XFF4E4949),
                                  fontSize: 7,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 20,
                          color: Color(0XFF4E4949),
                        ),
                        Row(
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 1,
                              child: Text(
                                'Profile',
                                style: TextStyle(
                                  color: Color(0XFF4E4949),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
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
                        const Divider(
                          height: 20,
                          color: Color(0XFF4E4949),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Employment History',
                                  style: TextStyle(
                                    color: Color(0XFF4E4949),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                const Spacer(),
                                CvAddButton(
                                  onTap: () {
                                    setState(() {
                                      controller.employmentHistory.add(
                                        EmploymentHistory(
                                          keyController: GlobalKey(),
                                          jobTitle: TextEditingController(text: 'Lorem Ipsum'),
                                          description: TextEditingController(
                                              text:
                                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type'),
                                          endDate: TextEditingController(text: 'November 2015'),
                                          startDate: TextEditingController(text: 'September 2019'),
                                          city: TextEditingController(text: 'Lorem Ipsum'),
                                          country: TextEditingController(text: 'Lorem Ipsum'),
                                          companyName: TextEditingController(text: 'Lorem Ipsum'),
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            for (int i = 0; i < controller.employmentHistory.length; i++)
                              Row(
                                textBaseline: TextBaseline.alphabetic,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  EmploymentHistory6(
                                    isRemovable: controller.employmentHistory.length>1,                                    description: controller.employmentHistory[i].description,
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
                            const Divider(
                              height: 20,
                              color: Color(0XFF4E4949),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Education',
                                  style: TextStyle(
                                    color: Color(0XFF4E4949),
                                    fontSize: 10,
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
                                          keyController: GlobalKey(),
                                          fieldOfStudy:
                                          TextEditingController(text: "Computer Science"),
                                          city: TextEditingController(text: "Lorem Ipsum"),
                                          country: TextEditingController(text: "Lorem Ipsum"),
                                          instituteName: TextEditingController(
                                              text: "Your Education History Title"),
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
                            const SizedBox(height: 10),
                            for (int i = 0; i < controller.education.length; i++)
                              Row(
                                textBaseline: TextBaseline.alphabetic,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  EducationHistory6(
                                    isRemovable: controller.education.length>1,
                                    description: controller.education[i].description,
                                    title: controller.education[i].fieldOfStudy,
                                    from: controller.education[i].startDate,
                                    till: controller.education[i].endDate,
                                    country: controller.education[i].country,
                                    city: controller.education[i].city,
                                    instituteName: controller.education[i].instituteName,
                                    onRemoveTap: () {
                                      setState(() {
                                        controller.education.removeAt(i);
                                      });
                                    },
                                  )
                                ],
                              ),
                            const Divider(
                              height: 20,
                              color: Color(0XFF4E4949),
                            ),
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
                                        'Skills',
                                        style: TextStyle(
                                          color: Color(0XFF4E4949),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      CvAddButton(
                                        onTap: () {
                                          setState(() {
                                            controller.skills.add(
                                                {TextEditingController(text: "Your Skill"): 0.7});
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: GridView.builder(
                                    itemCount: controller.skills.length,
                                    shrinkWrap: true,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 2.5,
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 2
                                    ),
                                    itemBuilder: (context, index) {
                                      return SkillCircullarWidget(
                                        isRemovable: controller.skills.length>1,
                                        leftPadding: 0,
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

                            if(controller.projects.isNotEmpty)
                              const Divider(
                              height: 20,
                              color: Color(0XFF4E4949),
                            ),
                            if(controller.projects.isNotEmpty)
                              Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Projects',
                                        style: TextStyle(
                                          color: Color(0XFF4E4949),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
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
                                  flex: 2,
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
                                )
                              ],
                            ),

                            if(controller.reference.isNotEmpty)     const Divider(
                              height: 20,
                              color: Color(0XFF4E4949),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if(controller.reference.isNotEmpty)      const Text(
                                        'Reference',
                                        style: TextStyle(
                                          color: Color(0XFF4E4949),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      const SizedBox(height: 5),
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
                                ),
                                Flexible(
                                  flex: 2,
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
                                )
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
                isUpdateCV: controller.saveCvId!=0,
                onSavePressed: () async {
                  if(controller.saveCvId!=0) {
                    await controller.updateCv(('v105'), controller.saveCvId);
                  }else{
                    await controller.saveCv('v105');
                  }
                },
                onDownloadPressed: () async {
                  await PwAssets.initializeAssets();
                  await PwFonts.initializeFonts();
                  pw.ImageProvider   netImage= await networkImage('https://cvlab.crewdog.ai/static/media/profilepic.1854a1d1129a7d85e324.png');
                  if(controller.cvImagePath.isNotEmpty){
                    netImage =controller.isSsoUrl? await networkImage('$ssoUrl${controller.cvImagePath}'): await networkImage('$baseUrl${controller.cvImagePath}');
                  }
                  await makePdf(buildTemplate6Pdf(controller,netImage), controller.nameController.text);
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }

 List< pw.Widget> buildTemplate6Pdf(TempController controller,  pw.ImageProvider netImage,) {
   List<pw.Widget> widgets = [
     pw.Center(
         child: pw.SizedBox(
           height: 50,width: 50,
           child: pw.ClipOval(
             child: (!controller.profilePicState)
                 ? pw.SizedBox()
                 : controller.cvImagePath.isNotEmpty
                 ? pw.Image(netImage, fit: pw.BoxFit.cover)
                 : pw.Image(pw.MemoryImage(PwAssets.cvDemoImage)),
           ),
         )
     ),
     pw.SizedBox(
         height: 10
     ),
     pw.Row(
       mainAxisAlignment: pw.MainAxisAlignment.center,
       children: [
         pw.Text(
             textAlign: pw.TextAlign.end,
             '${controller.nameController.text}, ',
             style: TextStylesPdf.headingText20w700),
         pw.Text(
             textAlign: pw.TextAlign.start,
             controller.designationController.text,
             style: TextStylesPdf.headingText20w700),
       ],
     ),
     pw.SizedBox(height: 15.0),
     pw.Row(
       mainAxisAlignment: pw.MainAxisAlignment.center,
       children: [
         pw.Text(
             textAlign: pw.TextAlign.start,
             '${controller.addressController.text}, ',
             style: TextStylesPdf.bodyText11Simple),
         pw.Text('${controller.contactController.text}, ',
             style: TextStylesPdf.bodyText11Simple),
         pw.Text(controller.mailController.text, style: TextStylesPdf.bodyText11Simple),
       ],
     ),
     pw.Divider(
       height: 20,
     ),
     pw.Row(
       crossAxisAlignment: pw.CrossAxisAlignment.start,
       children: [
         pw.Expanded(
           flex: 1,
           child: pw.Text('Profile', style: TextStylesPdf.headingText15w600),
         ),
         pw.Expanded(
           fit: pw.FlexFit.tight,
           flex: 2,
           child: pw.Text(
             controller.personalInformation.text,
             style: TextStylesPdf.bodyText11Simple,
           ),
         ),
       ],
     ),
     pw.Divider(
       height: 20,
       color: AppPdfColor.pdfGreyColorE49,
     ),
     pw.Text('Employment History', style: TextStylesPdf.headingText15w600),
     pw.SizedBox(height: 10),
     for (int i = 0; i < controller.employmentHistory.length; i++)
       pw.Row(
         children: [
           PdfEmploymentHistory6(
             country: controller.employmentHistory[i].country.text,
             companyName: controller.employmentHistory[i].companyName.text,
             title: controller.employmentHistory[i].jobTitle.text,
             from: controller.employmentHistory[i].startDate.text,
             till: controller.employmentHistory[i].endDate.text,
             description: controller.employmentHistory[i].description.text,
             city: controller.employmentHistory[i].city.text,
           ),
         ],
       ),
     pw.Divider(
       height: 20,
     ),
     pw.Text('Education', style: TextStylesPdf.headingText15w600),
     pw.SizedBox(height: 10),
     for (int i = 0; i < controller.education.length; i++)
       pw.Row(
         children: [
           PdfEducationHistory6(
             instituteName: controller.education[i].instituteName.text,
             country: controller.education[i].country.text,
             title: controller.education[i].fieldOfStudy.text,
             from: controller.education[i].startDate.text,
             till: controller.education[i].endDate.text,
             description: controller.education[i].description.text,
             city: controller.education[i].city.text,
           ),
         ],
       ),
     pw.Divider(
       height: 20,
     ),
     pw.Row(
       children: [
         pw.Expanded(
           flex: 1,
           child: pw.Row(
             children: [
               pw.Text('Skills', style: TextStylesPdf.headingText15w600),
             ],
           ),
         ),
         pw.Flexible(
           flex: 2,
           child: pw.Wrap(
             runSpacing: 10,
             spacing: 20,
             alignment: pw.WrapAlignment.spaceBetween,
             verticalDirection: pw.VerticalDirection.down,
             direction: pw.Axis.horizontal,
             children: [
               for (int i = 0; i < controller.skills.length; i++)
                 PdfSkillCircullarWidget(leftPadding: 0,
                   skill: controller.skills[i].keys.first.text,
                 ),
             ],
           ),
         ),
       ],
     ),

     if(controller.projects.isNotEmpty)
       pw.Divider(
       height: 20,
       //color: Color(0XFF4E4949),
     ),
     if(controller.projects.isNotEmpty)
       pw.Row(
       crossAxisAlignment: pw.CrossAxisAlignment.start,
       children: [
         pw.Expanded(
           flex: 1,
           child: pw.Text('Projects', style: TextStylesPdf.headingText15w600),
         ),
         pw.Expanded(
             flex: 2,
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
     if(controller.reference.isNotEmpty)    pw.Divider(
       height: 20,
       //color: Color(0XFF4E4949),
     ),
     pw.Row(
       crossAxisAlignment: pw.CrossAxisAlignment.start,
       children: [
         if(controller.reference.isNotEmpty)   pw.Expanded(
           flex: 1,
           child: pw.Text('Reference', style: TextStylesPdf.headingText15w600),
         ),
         pw.Expanded(
             flex: 2,
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

class EmploymentHistory6 extends StatelessWidget {
  final TextEditingController title;
  final TextEditingController from;
  final TextEditingController till;
  final TextEditingController city;
  final TextEditingController description;
  final TextEditingController country;
  final TextEditingController companyName;
  final VoidCallback onRemoveTap;
  final bool isRemovable;


  const EmploymentHistory6({
    super.key,
    required this.title,
    required this.from,
    required this.till,
    required this.description,
    required this.city,
    required this.onRemoveTap,
    required this.country,
    required this.companyName,
    this.isRemovable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 5,
                      child: CustomEditableText(
                        controller: from,
                        rightMargin: 0,
                        horizontalPadding: 2,
                        style: const TextStyle(
                            color: Color(0xFF4E4949),
                            fontSize: 6,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Text(
                        '_',
                        style: TextStyle(
                          color: Color(0xFF4E4949),
                          fontSize: 6,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: CustomEditableText(
                        controller: till,
                        rightMargin: 0,
                        horizontalPadding: 2,
                        style: const TextStyle(
                            color: Color(0xFF4E4949),
                            fontSize: 6,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      controller: title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color(0xFF4E4949),
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      " at ",
                      style: TextStyle(
                        color: Color(0xFF4E4949),
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      controller: companyName,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color(0xFF4E4949),
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      ", ",
                      style: TextStyle(
                        color: Color(0xFF4E4949),
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      controller: city,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color(0xFF4E4949),
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      ", ",
                      style: TextStyle(
                        color: Color(0xFF4E4949),
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomEditableText(
                      controller: country,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color(0xFF4E4949),
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 4,
                  child:isRemovable? GestureDetector(
                    onTap: onRemoveTap,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Row(
                        children: [
                          Text("Remove",
                              style: TextStyle(
                                color: Color(0XFFFF5E59),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(width: 5),
                          Icon(
                            Icons.remove_circle_outline,
                            color: Color(0XFFFF5E59),
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ): const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Row(
                      children: [
                        Text("Remove",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(width: 5),
                        Icon(
                          Icons.remove_circle_outline,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ],
                    ),
                  )
              ),
              Flexible(
                flex: 8,
                child: CustomEditableText(
                  controller: description,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Color(0xFF4E4949),
                    fontSize: 7,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class EducationHistory6 extends StatelessWidget {
  final TextEditingController title;
  final TextEditingController from;
  final TextEditingController till;
  final TextEditingController description;
  final TextEditingController city;
  final TextEditingController country;
  final TextEditingController instituteName;
  final VoidCallback onRemoveTap;
  final bool isRemovable;


  const EducationHistory6({
    super.key,
    required this.title,
    required this.from,
    required this.till,
    required this.description,
    required this.city,
    required this.onRemoveTap,
    required this.country,
    required this.instituteName,
    this.isRemovable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 5,
                      child: CustomEditableText(
                        controller: from,
                        rightMargin: 0,
                        horizontalPadding: 2,
                        style: const TextStyle(
                            color: Color(0xFF4E4949),
                            fontSize: 6,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Text(
                        '_',
                        style: TextStyle(
                          color: Color(0xFF4E4949),
                          fontSize: 6,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: CustomEditableText(
                        controller: till,
                        rightMargin: 0,
                        horizontalPadding: 2,
                        style: const TextStyle(
                            color: Color(0xFF4E4949),
                            fontSize: 6,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      controller: title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color(0xFF4E4949),
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      " from ",
                      style: TextStyle(
                        color: Color(0xFF4E4949),
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      controller: instituteName,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color(0xFF4E4949),
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      ", ",
                      style: TextStyle(
                        color: Color(0xFF4E4949),
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      controller: city,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color(0xFF4E4949),
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      ", ",
                      style: TextStyle(
                        color: Color(0xFF4E4949),
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomEditableText(
                      horizontalPadding: 0,
                      rightMargin: 0,
                      controller: country,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color(0xFF4E4949),
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 4,
                  child:isRemovable? GestureDetector(
                    onTap: onRemoveTap,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Row(
                        children: [
                          Text("Remove",
                              style: TextStyle(
                                color: Color(0XFFFF5E59),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(width: 5),
                          Icon(
                            Icons.remove_circle_outline,
                            color: Color(0XFFFF5E59),
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ): const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Row(
                      children: [
                        Text("Remove",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(width: 5),
                        Icon(
                          Icons.remove_circle_outline,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ],
                    ),
                  )),
              Flexible(
                flex: 8,
                child: CustomEditableText(
                  controller: description,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Color(0xFF4E4949),
                    fontSize: 7,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class PdfEmploymentHistory6 extends pw.StatelessWidget {
  final String title;
  final String companyName;
  final String country;
  final String city;
  final String from;
  final String till;
  final String description;

  PdfEmploymentHistory6({
    required this.title,
    required this.from,
    required this.till,
    required this.description,
    required this.city,
    required this.companyName,
    required this.country,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
        width: 480,
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(from, style: TextStylesPdf.bodyText10Simple),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text("  -  ", style: TextStylesPdf.bodyText10Simple),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(till, style: TextStylesPdf.bodyText10Simple),
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Wrap(children: [
                    pw.Text("$title at ", style: TextStylesPdf.bodyText12w600),
                    pw.Text("$companyName, ", style: TextStylesPdf.bodyText12w600),
                    pw.Text("$city, ", style: TextStylesPdf.bodyText12w600),
                    pw.Text(country, style: TextStylesPdf.bodyText12w600),
                  ]),
                ),
              ],
            ),
            pw.SizedBox(height: 8.0),
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Expanded(flex: 1, child: pw.SizedBox()),
              pw.Expanded(
                  fit: pw.FlexFit.tight,
                  flex: 2,
                  child: pw.Text(description, style: TextStylesPdf.bodyText10SimpleBlack))
            ]),
            pw.SizedBox(height: 10),
          ],
        ));
  }
}

class PdfEducationHistory6 extends pw.StatelessWidget {
  final String title;
  final String instituteName;
  final String country;
  final String city;
  final String from;
  final String till;
  final String description;

  PdfEducationHistory6({
    required this.title,
    required this.from,
    required this.till,
    required this.description,
    required this.city,
    required this.instituteName,
    required this.country,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
        width: 480,
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(from, style: TextStylesPdf.bodyText10Simple),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text("  -  ", style: TextStylesPdf.bodyText10Simple),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(till, style: TextStylesPdf.bodyText10Simple),
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Wrap(children: [
                    pw.Text("$title from ", style: TextStylesPdf.bodyText12w600),
                    pw.Text("$instituteName, ", style: TextStylesPdf.bodyText12w600),
                    pw.Text("$city, ", style: TextStylesPdf.bodyText12w600),
                    pw.Text(country, style: TextStylesPdf.bodyText12w600),
                  ]),
                ),
              ],
            ),
            pw.SizedBox(height: 8.0),
            pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Expanded(flex: 1, child: pw.SizedBox()),
              pw.Expanded(
                  fit: pw.FlexFit.tight,
                  flex: 2,
                  child: pw.Text(description, style: TextStylesPdf.bodyText10SimpleBlack))
            ]),
            pw.SizedBox(height: 10),
          ],
        ));
  }
}
