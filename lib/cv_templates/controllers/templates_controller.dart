import 'dart:convert';
import 'dart:io';
import 'package:crewdog_cv_lab/cv_templates/functions/fetch_and_upload_image.dart';
import 'package:crewdog_cv_lab/screens/home/home_controller.dart';
import 'package:crewdog_cv_lab/utils/app_snackbar.dart';
import 'package:crewdog_cv_lab/utils/local_db.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../screens/home/components/change_description_dialog.dart';
import '../../utils/app_functions.dart';
import '../../utils/consts/api_consts.dart';
import 'package:crewdog_cv_lab/models/models.dart';

String token = getAccessToken();
String userId = getUserId();
String profileImage = "";

class TempController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    refreshController();
    profileImage = getProfilePic();
  }

  int saveCvId = 0;
  File cvImage = File('');
  String cvImagePath = profileImage;
  bool isChatData = false;
  bool profilePicState = true;
  bool isSsoUrl = true;
  bool isAuthImage = true;
  bool imageAvailable = getProfilePic().isNotEmpty;
  TextEditingController nameController = TextEditingController(text: 'Lorem Ipsum');
  TextEditingController designationController = TextEditingController(text: 'Manager');
  TextEditingController addressController = TextEditingController(text: '2980 Smith Street, Massachusetts, USA');
  TextEditingController contactController = TextEditingController(text: '+1 508-831-1827');
  TextEditingController mailController = TextEditingController(text: 'lorem@gmail.com');
  TextEditingController personalInformation = TextEditingController(
      text:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.');
  final List<Projects> projects = [];
  final List<Map<TextEditingController, double>> skills = [
    {TextEditingController(text: 'Your Skill'): 1},
    {TextEditingController(text: 'Your Skill'): 0.9},
    {TextEditingController(text: 'Your Skill'): 0.7},
    {TextEditingController(text: 'Your Skill'): 0.3}
  ];
  final List<References> reference = [
    References(
        personName: TextEditingController(text: "Lorem Ipsum"),
        contactNumber: TextEditingController(text: "+92 3123456789"),
        referenceText: TextEditingController(text: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry is simply dummy text'),
        keyController: GlobalKey())
  ];

  final List<EmploymentHistory> employmentHistory = [
    EmploymentHistory(
        jobTitle: TextEditingController(text: 'Lorem Ipsum'),
        description: TextEditingController(
            text:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type'),
        endDate: TextEditingController(text: 'November 2015'),
        startDate: TextEditingController(text: 'September 2019'),
        city: TextEditingController(text: 'Lorem Ipsum'),
        country: TextEditingController(text: 'Lorem Ipsum'),
        companyName: TextEditingController(text: 'Lorem Ipsum'),
        keyController: GlobalKey())
  ];

  final List<EducationHistory> education = [
    EducationHistory(
      fieldOfStudy: TextEditingController(text: 'Lorem Ipsum'),
      description: TextEditingController(
          text:
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type'),
      endDate: TextEditingController(text: 'November 2015'),
      startDate: TextEditingController(text: 'September 2019'),
      city: TextEditingController(text: 'Lorem Ipsum'),
      country: TextEditingController(text: 'Lorem Ipsum'),
      instituteName: TextEditingController(text: 'Lorem Ipsum'),
      keyController: GlobalKey(),
    )
  ];

  List<Map<String, dynamic>> _prepareSkillsData() {
    return skills.map((skill) {
      final TextEditingController skillController = skill.keys.first;
      final double skillLevel = skill.values.first;
      return {
        'name': skillController.text,
        'level': skillLevel,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _prepareHistoryData(List<EmploymentHistory> historyList) {
    return historyList.map((history) {
      final Map<String, dynamic> historyData = {
        'company_name': history.companyName.text,
        'job_title': history.jobTitle.text,
        'city': history.city.text,
        'country': history.country.text,
        'start_date': history.startDate.text,
        'end_date': history.endDate.text,
        'description': history.description.text,
      };

      return historyData;
    }).toList();
  }

  List<Map<String, dynamic>> _prepareEducationHistoryData(List<EducationHistory> historyList) {
    return historyList.map((history) {
      final Map<String, dynamic> historyData = {
        'field_of_study': history.fieldOfStudy.text,
        'institute_name': history.instituteName.text,
        'city': history.city.text,
        'country': history.country.text,
        'start_date': history.startDate.text,
        'end_date': history.endDate.text,
        'description': history.description.text
      };

      return historyData;
    }).toList();
  }

  List<Map<String, dynamic>> _prepareReferenceData(List<References> referenceList) {
    return referenceList.map((history) {
      final Map<String, dynamic> referenceList = {
        'person_name': history.personName.text,
        'contact_number': history.contactNumber.text,
        'reference_text': history.referenceText.text,
      };

      return referenceList;
    }).toList();
  }

  List<Map<String, dynamic>> _prepareProjectsData(List<Projects> projectsList) {
    return projectsList.map((history) {
      final Map<String, dynamic> projectsList = {
        'project_name': history.title.text,
        'description': history.description.text,
      };
      return projectsList;
    }).toList();
  }

  Future<void> saveCv(String templateId) async {
    try {
      if (isAuthImage && imageAvailable) {
        String imageFetchedByUrl = await fetchAndUploadImage(token: token, templateId: templateId, userId: userId, cvImagePath: cvImagePath);
        cvImagePath = imageFetchedByUrl;
      }
      final Map<String, dynamic> payload = {
        'cv_data': {
          'personal_information': {
            'name': nameController.text,
            'email': mailController.text,
            'number': contactController.text,
            'address': addressController.text,
            'job_title': designationController.text,
            'summary': personalInformation.text,
            'profile_pic': cvImagePath,
          },
          'education': _prepareEducationHistoryData(education),
          'projects': _prepareProjectsData(projects),
          'employment_history': _prepareHistoryData(employmentHistory),
          'skills': _prepareSkillsData(),
          'reference': _prepareReferenceData(reference),
        },
        'name': nameController.text,
        'template_id': templateId,
        'profile_pic_state': profilePicState,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/api/save/cv/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        appSuccessSnackBar('Success', 'CV saved successfully');
      } else {
        customLog('Response: ${response.body}');
      }
    } catch (e) {
      customLog('Error saving CV: $e');
    }
  }

  Future<void> updateCv(String templateId, int savedCvId) async {
    try {
      if (isAuthImage&& imageAvailable) {
        String imageFetchedByUrl = await fetchAndUploadImage(token: token, templateId: templateId, userId: userId, cvImagePath: cvImagePath);
        cvImagePath = imageFetchedByUrl;
        customLog("CV IMage Updated in Upadte CV $cvImagePath");
      }
      final Map<String, dynamic> payload = {
        'cv_data': {
          'personal_information': {
            'name': nameController.text,
            'email': mailController.text,
            'number': contactController.text,
            'address': addressController.text,
            'job_title': designationController.text,
            'summary': personalInformation.text,
            'profile_pic': cvImagePath,
          },
          'education': _prepareEducationHistoryData(education),
          'projects': _prepareProjectsData(projects),
          'employment_history': _prepareHistoryData(employmentHistory),
          'skills': _prepareSkillsData(),
          'reference': _prepareReferenceData(reference),
        },
        'username': nameController.text,
        'template_id': templateId,
        'cv_id': savedCvId,
        'profile_pic_state': profilePicState,
      };

      final response = await http.put(
        Uri.parse('$baseUrl/api/updateCV/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        appSuccessSnackBar('Success', 'CV Updated successfully');
      } else {
        customLog('Failed to Update CV. Status code: ${response.statusCode}');
        customLog('Response: ${response.body}');
      }
    } catch (e) {
      customLog('Error Updating CV: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchCvObjectFromBackend(String cvId, String jobDescription, BuildContext context) async {
    final HomeController controller = Get.find();
    try {
      final payload = {
        "cv_id": cvId,
        "job_description": jobDescription,
      };
      final response = await http.post(
        Uri.parse('$baseUrl/api/getCv/'),
        body: payload,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if ( responseData['result'] != null) {
          String resultMessage = responseData['result'];
          if (resultMessage.contains("not relevent to job description")) {
            changeDescriptionDialog(context);
            isChatData = false;
            return null;
          }
          isChatData = false;
          return null;
        }
       else{
          isChatData = false;
          refreshController();
          final Map<String, dynamic> cvData = responseData['cv_obj']['cv']['cv'];
          customLog('CV Object updated with data from backend');
          controller.chatCvObj = cvData;
          return cvData;
        }
      } else {
        customLog('Status code: ${response.statusCode} Response: ${response.body}');
        return null;
      }
    } catch (e) {
      customLog('Error fetching data: $e');
    }
    return null;
  }

  Future<void> fillControllerFromCvObject(Map<String, dynamic> cvData) async {
    final Map<String, dynamic> personalData = cvData['personal_information'];
    nameController.text = personalData['name'] ?? '';
    mailController.text = personalData['email'] ?? '';
    contactController.text = personalData['number'] ?? '';
    addressController.text = personalData['address'] ?? '';
    designationController.text = personalData['job_title'] ?? '';
    personalInformation.text = personalData['summary'] ?? '';
    cvImagePath = personalData['profile_pic'] ?? getProfilePic();
    isChatData = true;
    isAuthImage = personalData['profile_pic'] != null ? false : true;
    isSsoUrl = personalData['profile_pic'] != null ? false : true;

    final List<dynamic> skillsDataList = cvData['skills'] ?? [];
    skills.clear();
    for (var skill in skillsDataList) {
      final TextEditingController controller = TextEditingController(text: skill['name'] ?? '');
      final double level = skill['level'] ?? 0;
      skills.add({controller: level});
    }

    final List<dynamic> referenceDataList = cvData['reference'] ?? [];
    reference.clear();
    for (var ref in referenceDataList) {
      final TextEditingController personNameController = TextEditingController(text: ref['person_name'] ?? '');
      final TextEditingController contactNumberController = TextEditingController(text: ref['contact_number'] ?? '');
      final TextEditingController referenceTextController = TextEditingController(text: ref['reference_text'] ?? '');
      final GlobalKey key = GlobalKey();
      reference.add(References(
        personName: personNameController,
        contactNumber: contactNumberController,
        referenceText: referenceTextController,
        keyController: key,
      ));
    }

    final List<dynamic> projectsDataList = cvData['projects'] ?? [];
    projects.clear();
    for (var pro in projectsDataList) {
      final TextEditingController title = TextEditingController(text: pro['project_name'] ?? '');
      final TextEditingController description = TextEditingController(text: pro['description'] ?? '');
      final GlobalKey key = GlobalKey();
      projects.add(Projects(title: title, description: description, keyController: key));
    }

    final List<dynamic> educationDataList = cvData['education'] ?? [];
    education.clear();
    for (var edu in educationDataList) {
      final TextEditingController fieldOfStudyController = TextEditingController(text: edu['field_of_study'] ?? '');
      final TextEditingController descriptionController = TextEditingController(text: edu['description'] ?? '');
      final TextEditingController endDateController = TextEditingController(text: edu['end_date'] ?? '');
      final TextEditingController startDateController = TextEditingController(text: edu['start_date'] ?? '');
      final TextEditingController cityController = TextEditingController(text: edu['city'] ?? '');
      final TextEditingController countryController = TextEditingController(text: edu['country'] ?? '');
      final TextEditingController instituteNameController = TextEditingController(text: edu['institute_name'] ?? '');
      final GlobalKey key = GlobalKey();
      education.add(EducationHistory(
        fieldOfStudy: fieldOfStudyController,
        description: descriptionController,
        endDate: endDateController,
        startDate: startDateController,
        city: cityController,
        country: countryController,
        instituteName: instituteNameController,
        keyController: key,
      ));
    }

    final List<dynamic> employmentDataList = cvData['employment_history'] ?? [];
    employmentHistory.clear();
    for (var employment in employmentDataList) {
      final TextEditingController jobTitleController = TextEditingController(text: employment['job_title'] ?? '');
      final TextEditingController descriptionController = TextEditingController(text: employment['description'] ?? '');
      final TextEditingController endDateController = TextEditingController(text: employment['end_date'] ?? '');
      final TextEditingController startDateController = TextEditingController(text: employment['start_date'] ?? '');
      final TextEditingController cityController = TextEditingController(text: employment['city'] ?? '');
      final TextEditingController countryController = TextEditingController(text: employment['country'] ?? '');
      final TextEditingController companyNameController = TextEditingController(text: employment['company_name'] ?? '');
      final GlobalKey key = GlobalKey();
      employmentHistory.add(EmploymentHistory(
        jobTitle: jobTitleController,
        description: descriptionController,
        endDate: endDateController,
        startDate: startDateController,
        city: cityController,
        country: countryController,
        companyName: companyNameController,
        keyController: key,
      ));
    }

    update();
    customLog("CV IMAGE $cvImagePath");
  }

  Future<void> fetchDataFromBackend(int cvId, String templateId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/getCv/?cv_id=$cvId&template_id=$templateId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        isChatData = false;

        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> cvData = responseData['cv']['cv'];
        final Map<String, dynamic> personalData = cvData['personal_information'];
        nameController.text = personalData['name'] ?? '';
        mailController.text = personalData['email'] ?? '';
        contactController.text = personalData['number'] ?? '';
        addressController.text = personalData['address'] ?? '';
        designationController.text = personalData['job_title'] ?? '';
        personalInformation.text = personalData['summary'] ?? '';
        cvImagePath = personalData['profile_pic'] ?? '';
        if (cvImagePath.contains("cv_pictures")) {
          isSsoUrl = false;
          isAuthImage = false;
        }
        profilePicState = responseData['cv']['profile_pic_state'] ?? true;
        saveCvId = cvId;

        final List<dynamic> skillsDataList = cvData['skills'] ?? [];
        skills.clear();
        for (var skill in skillsDataList) {
          final TextEditingController controller = TextEditingController(text: skill['name'] ?? '');
          final double level = skill['level'] ?? 0;
          skills.add({controller: level});
        }

        final List<dynamic> referenceDataList = cvData['reference'] ?? [];
        reference.clear();
        for (var ref in referenceDataList) {
          final TextEditingController personNameController = TextEditingController(text: ref['person_name'] ?? '');
          final TextEditingController contactNumberController = TextEditingController(text: ref['contact_number'] ?? '');
          final TextEditingController referenceTextController = TextEditingController(text: ref['reference_text'] ?? '');
          final GlobalKey key = GlobalKey();
          reference.add(References(
            personName: personNameController,
            contactNumber: contactNumberController,
            referenceText: referenceTextController,
            keyController: key,
          ));
        }

        final List<dynamic> projectsDataList = cvData['projects'] ?? [];
        projects.clear();
        for (var pro in projectsDataList) {
          final TextEditingController title = TextEditingController(text: pro['project_name'] ?? '');
          final TextEditingController description = TextEditingController(text: pro['description'] ?? '');
          final GlobalKey key = GlobalKey();
          projects.add(Projects(title: title, description: description, keyController: key));
        }

        final List<dynamic> educationDataList = cvData['education'] ?? [];
        education.clear();
        for (var edu in educationDataList) {
          final TextEditingController fieldOfStudyController = TextEditingController(text: edu['field_of_study'] ?? '');
          final TextEditingController descriptionController = TextEditingController(text: edu['description'] ?? '');
          final TextEditingController endDateController = TextEditingController(text: edu['end_date'] ?? '');
          final TextEditingController startDateController = TextEditingController(text: edu['start_date'] ?? '');
          final TextEditingController cityController = TextEditingController(text: edu['city'] ?? '');
          final TextEditingController countryController = TextEditingController(text: edu['country'] ?? '');
          final TextEditingController instituteNameController = TextEditingController(text: edu['institute_name'] ?? '');
          final GlobalKey key = GlobalKey();
          education.add(EducationHistory(
            fieldOfStudy: fieldOfStudyController,
            description: descriptionController,
            endDate: endDateController,
            startDate: startDateController,
            city: cityController,
            country: countryController,
            instituteName: instituteNameController,
            keyController: key,
          ));
        }

        final List<dynamic> employmentDataList = cvData['employment_history'] ?? [];
        employmentHistory.clear();
        for (var employment in employmentDataList) {
          final TextEditingController jobTitleController = TextEditingController(text: employment['job_title'] ?? '');
          final TextEditingController descriptionController = TextEditingController(text: employment['description'] ?? '');
          final TextEditingController endDateController = TextEditingController(text: employment['end_date'] ?? '');
          final TextEditingController startDateController = TextEditingController(text: employment['start_date'] ?? '');
          final TextEditingController cityController = TextEditingController(text: employment['city'] ?? '');
          final TextEditingController countryController = TextEditingController(text: employment['country'] ?? '');
          final TextEditingController companyNameController = TextEditingController(text: employment['company_name'] ?? '');
          final GlobalKey key = GlobalKey();
          employmentHistory.add(EmploymentHistory(
            jobTitle: jobTitleController,
            description: descriptionController,
            endDate: endDateController,
            startDate: startDateController,
            city: cityController,
            country: countryController,
            companyName: companyNameController,
            keyController: key,
          ));
        }

        update();

        customLog('Controller variables updated with data from backend');
      } else {
        customLog('Failed to fetch data. Status code: ${response.statusCode}');
        customLog('Response: ${response.body}');
      }
    } catch (e) {
      customLog('Error fetching data: $e');
    }
  }

  void refreshController() {
    HomeController homeController = Get.find();
    if (homeController.chatCvObj.isNotEmpty) {
      print("Filling from CV Object which is not empty");
      fillControllerFromCvObject(homeController.chatCvObj);
    } else {
      customLog("Controller Refreshed");
      isAuthImage = true;
      isSsoUrl = true;
      profilePicState = true;
      isChatData = false;
      profileImage = getProfilePic();
      nameController.text = 'Lorem Ipsum';
      designationController.text = 'Manager';
      addressController.text = '2980 Smith Street, Massachusetts, USA';
      contactController.text = '+1 508-831-1827';
      mailController.text = 'lorem@gmail.com';
      cvImagePath = profileImage;
      saveCvId = 0;
      personalInformation.text =
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.';

      // Refresh skills
      skills.clear();
      skills.addAll([
        {TextEditingController(text: 'Your Skill'): 1},
        {TextEditingController(text: 'Your Skill'): 0.9},
        {TextEditingController(text: 'Your Skill'): 0.7},
        {TextEditingController(text: 'Your Skill'): 0.3},
      ]);

      projects.clear();
      projects.addAll([
        Projects(
            keyController: GlobalKey(),
            title: TextEditingController(text: 'Lorem Ipsum'),
            description: TextEditingController(
                text:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type'))
      ]);

      // Refresh education
      education.clear();
      education.addAll([
        EducationHistory(
            fieldOfStudy: TextEditingController(text: 'Lorem Ipsum'),
            description: TextEditingController(
                text:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type'),
            endDate: TextEditingController(text: 'November 2015'),
            startDate: TextEditingController(text: 'September 2019'),
            city: TextEditingController(text: 'Lorem Ipsum'),
            country: TextEditingController(text: 'Lorem Ipsum'),
            instituteName: TextEditingController(text: 'Lorem Ipsum'),
            keyController: GlobalKey())
      ]);

      // Refresh employment history
      employmentHistory.clear();
      employmentHistory.addAll([
        EmploymentHistory(
            jobTitle: TextEditingController(text: 'Lorem Ipsum'),
            description: TextEditingController(
                text:
                    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type'),
            endDate: TextEditingController(text: 'November 2015'),
            startDate: TextEditingController(text: 'September 2019'),
            city: TextEditingController(text: 'Lorem Ipsum'),
            country: TextEditingController(text: 'Lorem Ipsum'),
            companyName: TextEditingController(text: 'Lorem Ipsum'),
            keyController: GlobalKey())
      ]);

      reference.clear();
      reference.addAll([
        References(
            personName: TextEditingController(text: 'Lorem Ipsum'),
            contactNumber: TextEditingController(text: '+92 3123456789'),
            referenceText: TextEditingController(text: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry is simply dummy text'),
            keyController: GlobalKey())
      ]);
    }
  }
}
