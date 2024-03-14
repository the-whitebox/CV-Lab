import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../../custom_widgets/custom_widgets.dart';
import 'package:get/get.dart';
import '../../custom_widgets/pdf_custom_widgets.dart';
import 'package:image_picker/image_picker.dart';
import '../../custom_widgets/pw_assets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../utils/app_snackbar.dart';
import '../../utils/constants.dart';
import '../../utils/app_functions.dart';
import '../controllers/profile_controller.dart';
import 'controllers/temp_controller.dart';

class V106 extends StatefulWidget {
  const V106({Key? key}) : super(key: key);

  @override
  State<V106> createState() => _V106State();
}

class _V106State extends State<V106> {
  File? selectedImage;
  final GlobalKey profileContainerKey = GlobalKey();
  final GlobalKey employmentHistory1Key = GlobalKey();
  final GlobalKey employmentHistory2Key = GlobalKey();
  final GlobalKey educationHistory1Key = GlobalKey();
  final GlobalKey educationHistory2Key = GlobalKey();
  final GlobalKey referenceKey = GlobalKey();
  double containerHeight = 0.0;
  final storage = GetStorage();
  final controller = Get.put(TempController());
  bool isCanPop=true;



  @override
  Widget build(BuildContext context) {
    void openGallery() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        String cvImagePath = await uploadDataAndImage(
          pickedFile,
          token,
          'v106',
          userId,
        );
        setState(() {
          selectedImage = File(pickedFile.path);
          controller.cvImage = File(pickedFile.path);
          controller.cvImagePath = '/media/$cvImagePath';
        });
      }
    }

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
      backgroundColor: Colors.white,
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
                      children: [
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
                                  height: 50,
                                  width: 50,
                                  child: Image(
                                    image: controller.cvImagePath.isNotEmpty
                                        ? NetworkImage('$baseUrl${controller.cvImagePath}')
                                        : const AssetImage('assets/images/icon-profile.png')
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
                        CustomEditableText(
                            controller: controller.nameController,
                            style: const TextStyle(
                              color: Color(0xFF4E4949),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center),
                        CustomEditableText(
                          controller: controller.designationController,
                          style: kFont7.copyWith(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const ShapeDecoration(
                                          shape: OvalBorder(
                                            side: BorderSide(
                                              width: 1,
                                              color: Color(0xFF4E4949),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      const Text(
                                        'Details',
                                        style: TextStyle(
                                          color: Color(0xFF4E4949),
                                          fontSize: 10,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const ShapeDecoration(
                                          shape: OvalBorder(
                                            side: BorderSide(
                                              width: 1,
                                              color: Color(0xFF4E4949),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  CustomEditableText(
                                    controller: controller.addressController,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF4E4949),
                                      fontSize: 6,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  CustomEditableText(
                                    controller: controller.contactController,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF4E4949),
                                      fontSize: 6,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  CustomEditableText(
                                    controller: controller.mailController,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF4E4949),
                                      fontSize: 6,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const ShapeDecoration(
                                          shape: OvalBorder(
                                            side: BorderSide(
                                              width: 1,
                                              color: Color(0xFF4E4949),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      const Text(
                                        'Skills',
                                        style: TextStyle(
                                          color: Color(0xFF4E4949),
                                          fontSize: 10,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: const ShapeDecoration(
                                          shape: OvalBorder(
                                            side: BorderSide(
                                              width: 1,
                                              color: Color(0xFF4E4949),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
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
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CvAddButton(
                                        onTap: () {
                                          setState(() {
                                            controller.skills.add(
                                                {TextEditingController(text: "Your Skill"): 0.7});
                                          });
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.person, size: 15),
                                      SizedBox(
                                        width: 2.0,
                                      ),
                                      Text(
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
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    height: 10,
                                                    width: 10,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: const Color(0XFF4E4949),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      key: profileContainerKey,
                                                      width: 2,
                                                      color: const Color(0XFF4E4949),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: CustomEditableText(
                                                  controller: controller.personalInformation,
                                                  textAlign: TextAlign.left,
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
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Image.asset('assets/images/bag.png', width: 12, height: 12),
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
                                                jobTitle:
                                                TextEditingController(text: 'Lorem Ipsum'),
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
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  for (int i = 0; i < controller.employmentHistory.length; i++)
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: IntrinsicHeight(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: const Color(0XFF4E4949),
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        key: controller
                                                            .employmentHistory[i].keyController,
                                                        width: 2,
                                                        color: const Color(0XFF4E4949),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 5),
                                                EmploymentHistoryWidget(
                                                  isRemovable: controller.employmentHistory.length>1,
                                                  durationFontSize: 6,
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Image.asset('assets/images/hat.png', width: 12, height: 12),
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
                                                fieldOfStudy:
                                                TextEditingController(text: 'Lorem Ipsum'),
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
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  for (int i = 0; i < controller.education.length; i++)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: const Color(0XFF4E4949),
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        key: controller.education[i].keyController,
                                                        width: 2,
                                                        color: const Color(0XFF4E4949),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 5),
                                                EducationHistoryWidget(
                                                  isRemovable: controller.education.length>1,
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
                                          ),
                                        ),
                                      ],
                                    ),

                                  const SizedBox(height: 5),
                                  if(controller.projects.isNotEmpty)
                                    Row(
                                    children: [
                                      Image.asset('assets/images/hat.png', width: 12, height: 12),
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
                                            controller.projects.add(
                                              Projects(
                                                title: TextEditingController(
                                                    text: "Your project title"),
                                                description: TextEditingController(
                                                    text:
                                                    "Write your project description here"),
                                                keyController: GlobalKey(),
                                              ),);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  if(controller.projects.isNotEmpty)
                                    const SizedBox(
                                    height: 5.0,
                                  ),
                                  for (int i = 0; i < controller.projects.length; i++)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: const Color(0XFF4E4949),
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        key: controller.projects[i].keyController,
                                                        width: 2,
                                                        color: const Color(0XFF4E4949),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.symmetric(vertical: 4),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        ProjectWidget(
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
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      if(controller.reference.isNotEmpty)    Row(
                                        children: [
                                          Image.asset('assets/images/speaker.png',
                                              width: 12, height: 12),
                                          const SizedBox(
                                            width: 2.0,
                                          ),
                                          const Text(
                                            'References',
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
                                            controller.reference.add(References(
                                              personName:
                                              TextEditingController(text: "Reference Name"),
                                              contactNumber:
                                              TextEditingController(text: "Contact Number"),
                                              referenceText:
                                              TextEditingController(text: "Reference Text"),
                                              keyController: GlobalKey(),
                                            ));
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  for (int i = 0; i < controller.reference.length; i++)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: const Color(0XFF4E4949),
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        key: controller.reference[i].keyController,
                                                        width: 2,
                                                        color: const Color(0XFF4E4949),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.symmetric(vertical: 4),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        ReferenceWidget(
                                                          personName:
                                                          controller.reference[i].personName,
                                                          contactNumber:
                                                          controller.reference[i].contactNumber,
                                                          referenceText:
                                                          controller.reference[i].referenceText,
                                                          onRemoveTap: () {
                                                            setState(() {
                                                              controller.reference.removeAt(i);
                                                            });
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
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
                      await controller.updateCv(('v106'), controller.saveCvId);
                    }else{
                      await controller.saveCv('v106');
                      if(controller.isChatData==false) {
                        controller.refreshController();
                      }
                    }
                  }, onDownloadPressed: () async {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  final RenderBox profileRenderBox =
                  profileContainerKey.currentContext!.findRenderObject() as RenderBox;
                  storage.write("profile", profileRenderBox.size.height);
                  for (int i = 0; i < controller.employmentHistory.length; i++) {
                    final employmentRenderBox = controller
                        .employmentHistory[i].keyController?.currentContext!
                        .findRenderObject() as RenderBox;
                    storage.write("employment$i", employmentRenderBox.size.height*1.2);
                    print("Employment History Height ${employmentRenderBox.size.height*1.2}");
                  }
                  for (int i = 0; i < controller.education.length; i++) {
                    final educationRenderBox =
                    controller.education[i].keyController?.currentContext!.findRenderObject()
                    as RenderBox;
                    storage.write("education$i", educationRenderBox.size.height*1.2);
                    print("Education History Height ${educationRenderBox.size.height*1.2}");
                  }

                  for (int i = 0; i < controller.reference.length; i++) {
                    final referenceRenderBox =
                    controller.reference[i].keyController?.currentContext!.findRenderObject()
                    as RenderBox;
                    storage.write("reference$i", referenceRenderBox.size.height*1.2);
                    print("Reference Height ${referenceRenderBox.size.height*1.2}");
                  }
                  for (int i = 0; i < controller.projects.length; i++) {
                    final projectsRenderBox =
                    controller.projects[i].keyController?.currentContext!.findRenderObject()
                    as RenderBox;
                    storage.write("project$i", projectsRenderBox.size.height*1.2);
                    print("Projects History Height ${projectsRenderBox.size.height*1.2}");
                  }
                  await requestPermissions();
                  await PwAssets.initializeAssets();
                  await PwFonts.initializeFonts();
                  pw.ImageProvider netImage = await networkImage(
                      'https://cvlab.crewdog.ai/static/media/profilepic.1854a1d1129a7d85e324.png');
                  if (controller.cvImagePath.isNotEmpty) {
                    netImage = await networkImage('$baseUrl${controller.cvImagePath}');
                  }
                  await makePdf(
                      buildTemplate1Pdf(controller, netImage), controller.nameController.text);
                  if(controller.isChatData==false) {
                    controller.refreshController();
                  }
                  Get.back();
                  appSuccessSnackBar("Success", 'Your CV has been Downloaded');
                });
              }),
            ],
          ),
        ),
      ),
    ));
  }

  List<pw.Widget> buildTemplate1Pdf(TempController controller, pw.ImageProvider netImage) {
    List<pw.Widget> widgets = [
      pw.Column(
        children: [
          controller.profilePicState
              ? pw.ClipOval(
            child: pw.SizedBox(
              height: 60,
              width: 60,
              child: controller.cvImagePath.isNotEmpty
                  ? pw.Image(netImage, fit: pw.BoxFit.cover)
                  : pw.Image(pw.MemoryImage(PwAssets.cvDemoImage)),
            ),
          )
              : pw.SizedBox(),
          pw.Text(
            controller.nameController.text,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: 20,
              font: PwFonts.ttf500,
              color: AppPdfColor.pdfGreyColorE49,
            ),
          ),
          pw.SizedBox(
            height: 10.0,
          ),
          pw.Center(
            child: pw.Text(
              controller.designationController.text,
              textAlign: pw.TextAlign.start,
              style: TextStylesPdf.bodyText10Simple,
            ),
          ),
        ]
      ),
      pw.SizedBox(
        height: 20.0,
      ),
      pw.Partitions(
        // crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Partition(
            flex: 1,
            child: pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Container(
                      width: 8,
                      height: 8,
                      decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          border: pw.Border.all(
                            color: AppPdfColor.pdfGreyColorE49,
                          )),
                    ),
                    pw.SizedBox(width: 5.0),
                    pw.Text(
                      'Details',
                      style: TextStylesPdf.headingText15w600,
                    ),
                    pw.SizedBox(width: 5.0),
                    pw.Container(
                      width: 8,
                      height: 8,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        border: pw.Border.all(
                          color: AppPdfColor.pdfGreyColorE49,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(
                  height: 10.0,
                ),
                pw.Row(children: [
                  pw.Expanded(
                    child: pw.Text(
                      controller.addressController.text,
                      textAlign: pw.TextAlign.center,
                      style: TextStylesPdf.bodyText10w500,
                    ),
                  )
                ]),
                pw.SizedBox(
                  height: 7.0,
                ),
                pw.Text(controller.contactController.text,
                    textAlign: pw.TextAlign.center, style: TextStylesPdf.bodyText10w500),
                pw.SizedBox(
                  height: 7.0,
                ),
                pw.Text(controller.mailController.text,
                    textAlign: pw.TextAlign.center, style: TextStylesPdf.bodyText10w500),
                pw.SizedBox(
                  height: 10.0,
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Container(
                      width: 8,
                      height: 8,
                      decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          border: pw.Border.all(color: AppPdfColor.pdfGreyColorE49)),
                    ),
                    pw.SizedBox(width: 5.0),
                    pw.Text('Skills', style: TextStylesPdf.headingText15w600),
                    pw.SizedBox(width: 5.0),
                    pw.Container(
                      width: 8,
                      height: 8,
                      decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          border: pw.Border.all(
                            color: AppPdfColor.pdfGreyColorE49,
                          )),
                    ),
                  ],
                ),
                pw.SizedBox(
                  height: 10.0,
                ),
                pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 10),
                    child: pw.Column(
                        children: [
                          for (int i = 0; i < controller.skills.length; i++)
                            PdfSkillCircullarWidget(
                              leftPadding: 0,
                              skill: controller.skills[i].keys.first.text,
                            )
                        ]
                    )
                )
              ],
            ),
          ),
          // pw.SizedBox(width: 5),
          pw.Partition(
            flex: 3,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Image(pw.MemoryImage(PwAssets.personImage), height: 15, width: 15),
                    pw.SizedBox(
                      width: 2.0,
                    ),
                    pw.Text('Profile', style: TextStylesPdf.headingText15w600),
                  ],
                ),
                pw.SizedBox(
                  height: 8.0,
                ),
                DividerBulletPdf(
                  containerName: 'profile',
                  expandAbleWidget: pw.Expanded(
                    child: pw.Row(
                      children: [
                        pw.SizedBox(width: 5),
                        pw.Expanded(
                          child: pw.Text(controller.personalInformation.text,
                              textAlign: pw.TextAlign.left,
                              style: TextStylesPdf.bodyText12Simple),
                        ),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Image(pw.MemoryImage(PwAssets.bagImage), height: 15, width: 15),
                    pw.SizedBox(
                      width: 2.0,
                    ),
                    pw.Text('Employment History', style: TextStylesPdf.headingText15w600),
                  ],
                ),
                pw.SizedBox(
                  height: 8.0,
                ),
                for (int i = 0; i < controller.employmentHistory.length; i++)
                  DividerBulletPdf(
                    containerName: 'employment$i',
                    expandAbleWidget: pw.Expanded(
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(width: 5),
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
                    ),
                  ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Image(pw.MemoryImage(PwAssets.hatImage), height: 15, width: 15),
                    pw.SizedBox(
                      width: 2.0,
                    ),
                    pw.Text('Education', style: TextStylesPdf.headingText15w600),
                  ],
                ),
                pw.SizedBox(
                  height: 8.0,
                ),
                for (int i = 0; i < controller.education.length; i++)
                  DividerBulletPdf(
                    containerName: 'education$i',
                    expandAbleWidget: pw.Expanded(
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(width: 5),
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
                    ),
                  ),
                pw.SizedBox(height: 10),
                if(controller.projects.isNotEmpty)
                  pw.Row(
                  children: [
                    pw.Image(pw.MemoryImage(PwAssets.hatImage), height: 15, width: 15),
                    pw.SizedBox(
                      width: 2.0,
                    ),
                    pw.Text('Projects', style: TextStylesPdf.headingText15w600),
                  ],
                ),
                if(controller.projects.isNotEmpty)
                  pw.SizedBox(
                  height: 8.0,
                ),
                for (int i = 0; i < controller.projects.length; i++)
                  DividerBulletPdf(
                    containerName: 'project$i',
                    expandAbleWidget: pw.Expanded(
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(width: 5),
                          pw.SizedBox(
                              width: 360,
                              child: PdfProjectWidget(
                                title: controller.projects[i].title.text,
                                description: controller.projects[i].description.text,
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                pw.SizedBox(height: 10),
                if(controller.reference.isNotEmpty)    pw.Row(
                  children: [
                    pw.Image(pw.MemoryImage(PwAssets.speakerImage), height: 15, width: 15),
                    pw.SizedBox(
                      width: 2.0,
                    ),
                    pw.Text('Reference', style: TextStylesPdf.headingText15w600),
                  ],
                ),
                pw.SizedBox(
                  height: 8.0,
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < controller.reference.length; i++)
                      DividerBulletPdf(
                        containerName: 'reference$i',
                        expandAbleWidget: pw.Expanded(
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.SizedBox(width: 5),
                              pw.SizedBox(
                                  width:360,
                                  child: PdfReferenceWidget(
                                      personName: controller.reference[i].personName.text,
                                      contactNumber: controller.reference[i].contactNumber.text,
                                      referenceText:
                                      controller.reference[i].referenceText.text))
                            ],
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ];


    return widgets;
  }
}

class DividerBulletPdf extends pw.StatelessWidget {
  final pw.Widget expandAbleWidget;
  final String containerName;

  DividerBulletPdf({
    required this.expandAbleWidget,
    required this.containerName,
  });

  @override
  pw.Widget build(pw.Context context) {
    final storage = GetStorage();
    final double storedHeight = storage.read(containerName) ?? 20.0;

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          children: [
            pw.Container(
              height: 7,
              width: 7,
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                shape: pw.BoxShape.circle,
                border: pw.Border.all(
                  color: const PdfColor.fromInt(0XFF4E4949),
                ),
              ),
            ),
            pw.Container(
              width: 1,
              height: storedHeight * 1.3, // Use the stored height
              color: const PdfColor.fromInt(0XFF4E4949),
            ),
          ],
        ),
        pw.SizedBox(width: 5),
        expandAbleWidget,
        // pw.SizedBox(width: 20),
      ],
    );
  }
}