import 'dart:convert';
import 'dart:io';
import 'package:crewdog_cv_lab/utils/app_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:crewdog_cv_lab/utils/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import '../services/profile/retrieve_profile.dart';
import '../services/profile/update_profile.dart';
import '../custom_widgets/rotating_image.dart';
import '../utils/constants.dart';
import '../utils/app_functions.dart';
import '../utils/local_db.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _emailTextController = TextEditingController();
  final _currentPasswordTextController = TextEditingController();
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _newPasswordTextController = TextEditingController();
  final _newPasswordConfirmTextController = TextEditingController();
  final token = getAccessToken();
  String _currentPasswordErrorText = 'Current password can\'t be empty';
  String _newPasswordErrorText = 'New password can\'t be empty';
  String _confirmPasswordErrorText = 'Confirm password can\'t be empty';
  String _firstNameErrorText = 'Please enter first name';
  String _lastNameErrorText = 'Please enter last name';
  bool _isLoading = false;
  bool isFirstIndex = true;
  bool isSecondIndex = false;
  bool _newPasswordVisible = false;
  bool _validateConfirmPassword = false;
  bool _validateNewPassword = false;
  bool _validateFirstName = false;
  bool _validateLastName = false;
  bool _validateCurrentPassword = false;
  bool _currentPasswordVisible = false;
  bool _confirmNewPasswordVisible = false;
  bool _rememberMe = false;
  bool _isChangePassword = false;
  bool _isEditProfile = false;
  bool _isMyProfile = true;
  int selectedAvatarIndex = 0;
  File? selectedImage;
  XFile? tempImage;
  String? imageNetwork;
  int avatarIndexNetwork = 0;
  double _progress = 0.0;
  String _fileName = '';
  String _fileSize = '';
  String _timeRemaining = '';
  bool _fileUploaded = false;
  File? tempSelectedImage;

  List<bool> isPictureSelected = [true, false];
  List<String> avatarList = [
    'assets/images/avatars/demo.png',
    'assets/images/avatars/avatar0.png',
    'assets/images/avatars/avatar1.png',
    'assets/images/avatars/avatar2.png',
    'assets/images/avatars/avatar3.png',
    'assets/images/avatars/avatar4.png',
    'assets/images/avatars/avatar5.png',
    'assets/images/avatars/avatar6.png',
    'assets/images/avatars/avatar7.png',
  ];

  late Future<Map<String, dynamic>> _profileFuture;

  Future<void> changePasswordAPI({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (await isInternetConnected()) {
      final apiUrl = Uri.parse('$ssoUrl/api/accounts/password/change/');
      print('old $oldPassword and new $newPassword');
      print('token $token');
      final response = await http.put(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        appSuccessSnackBar("Success", "Password has been changed");
        setState(() {
          _isMyProfile = true;
          _isEditProfile = false;
          _isChangePassword = false;
        });
        resetFields();
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        if (errorData['detail'] != "") {
          appSnackBar(" Error", " ${errorData['detail']}");
        } else {
          appSnackBar(" Error",
              'Failed to change password. Status code: ${response.statusCode}');
        }
      }
    } else {
      appSnackBar("Error", "No internet connectivity");
    }
  }

  @override
  void initState() {
    super.initState();
    _profileFuture = retrieveProfile(token);
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _currentPasswordTextController.dispose();
    super.dispose();
  }

  void resetFields() {
    _currentPasswordTextController.clear();
    _newPasswordTextController.clear();
    _newPasswordConfirmTextController.clear();
    _validateCurrentPassword = false;
    _validateNewPassword = false;
    _validateConfirmPassword = false;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isLargerScreen = false;
    if (screenHeight < 600) {
      isLargerScreen = false;
    } else {
      isLargerScreen = true;
    }

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          if (_isChangePassword) {
            _isChangePassword = false;
            _isMyProfile = true;
            resetFields();
          } else if (_isEditProfile) {
            _isEditProfile = false;
            _isMyProfile = true;
          } else {}
        });
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: FutureBuilder(
            future: _profileFuture,
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: RotatingImage(
                    height: isLargerScreen
                        ? screenHeight * 0.25
                        : screenHeight * 0.20,
                    width:
                        isLargerScreen ? screenWidth * 0.25 : screenWidth * 0.2,
                  ),
                );
              } else if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Expanded(flex: 1, child: SizedBox()),
                    Text(
                      'Something went wrong',
                      style: isLargerScreen ? kFont24 : kFont24SmallScreen,
                    ),
                    const SizedBox(height: 10),
                    snapshot.error.toString().contains("SocketException")
                        ? const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                                "Please Check your internet connection and try again."),
                          )
                        : Text("Error : ${snapshot.error}"),
                    const Expanded(flex: 2, child: SizedBox()),
                    SizedBox(
                      height: screenHeight * 0.2,
                      child: Image.asset(
                        'assets/images/sleepy_dog.png',
                      ),
                    ),
                    const Expanded(flex: 2, child: SizedBox()),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.07,
                          vertical: screenHeight * 0.04),
                      child: ElevatedButton(
                        onPressed: () async {
                          clearUserId();
                          clearProfilePic();
                          clearAccessToken();
                          Get.offAllNamed(AppRoutes.welcome);
                        },
                        style: kElevatedButtonWithWhiteColor.copyWith(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                                vertical: isLargerScreen
                                    ? screenHeight * 0.009
                                    : screenHeight * 0.005,
                                horizontal: isLargerScreen
                                    ? screenWidth * 0.05
                                    : screenWidth * 0.05),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              color: kHighlightedColor,
                              size: isLargerScreen ? 24 : 18,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Log out',
                              style: kButtonTextStyle.copyWith(
                                  color: kHighlightedColor,
                                  fontSize: isLargerScreen ? 20 : 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return SafeArea(
                  child: SingleChildScrollView(
                    physics: isLargerScreen
                        ? const BouncingScrollPhysics()
                        : const BouncingScrollPhysics(),
                    child: Stack(
                      children: [
                        Image.asset('assets/images/bg_paws_with_orange.png'),
                        Padding(
                          padding: const EdgeInsets.all(1),
                          child: Column(
                            children: [
                              SizedBox(
                                height: isLargerScreen
                                    ? screenHeight * 0.02
                                    : screenHeight * 0.06,
                              ),
                              Visibility(
                                visible: _isMyProfile,
                                child: Text(
                                  'My profile',
                                  style: isLargerScreen
                                      ? kFont24
                                      : kFont24SmallScreen,
                                ),
                              ),
                              Visibility(
                                visible: _isEditProfile,
                                child: Text(
                                  'Edit profile',
                                  style: isLargerScreen
                                      ? kFont24
                                      : kFont24SmallScreen,
                                ),
                              ),
                              Visibility(
                                visible: _isChangePassword,
                                child: Text(
                                  'Change password',
                                  style: isLargerScreen
                                      ? kFont24
                                      : kFont24SmallScreen,
                                ),
                              ),
                              Visibility(
                                visible: _isMyProfile,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.025,
                                      horizontal: screenWidth * 0.03),
                                  child: buildProfileContainer(
                                    screenHeight,
                                    screenWidth,
                                    isLargerScreen,
                                    context,
                                    snapshot.data!,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isEditProfile,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.025,
                                      horizontal: screenWidth * 0.03),
                                  child: buildEditProfileContainer(
                                    context,
                                    snapshot.data!,
                                    screenHeight,
                                    screenWidth,
                                    isLargerScreen,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _isChangePassword,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.025,
                                      horizontal: screenWidth * 0.03),
                                  child: buildChangePasswordContainer(
                                    context,
                                    screenHeight,
                                    screenWidth,
                                    isLargerScreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          )),
    );
  }

  Container buildProfileContainer(
    double screenHeight,
    double screenWidth,
    bool isLargerScreen,
    BuildContext context,
    Map<String, dynamic> userData,
  ) {
    if (userData['profile_pic'] != null) {
      imageNetwork = ssoUrl + userData['profile_pic'];
      storeProfilePic(userData['profile_pic']);
    } else if (userData['avatar_url'] != null) {
      avatarIndexNetwork = int.parse(userData['avatar_url']);
      storeProfilePic("");
    }
    return Container(
      padding: EdgeInsets.only(
          top: isLargerScreen ? screenHeight * 0.02 : screenHeight * 0.035),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
            color: const Color(0x4D000000).withOpacity(0.08), width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.015),
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: kPurple, width: 2),
                  ),
                  child: Image.asset(
                    'assets/images/edit.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  _isMyProfile = false;
                  _isEditProfile = true;
                  _firstNameTextController.text = userData['first_name'];
                  _lastNameTextController.text = userData['last_name'];
                });
              },
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: screenHeight * 0.075,
                  backgroundImage: (tempImage != null)
                      ? FileImage(
                          File(tempImage!.path)) // Show tempImage if present
                      : (selectedAvatarIndex != 0)
                          ? AssetImage(avatarList[selectedAvatarIndex])
                              as ImageProvider<Object>
                          : (imageNetwork != null)
                              ? NetworkImage(imageNetwork!)
                              : (avatarIndexNetwork != null)
                                  ? AssetImage(
                                      avatarList[
                                          avatarIndexNetwork!]) as ImageProvider<
                                      Object> // Show avatarIndex image if present
                                  : const AssetImage('fallback_image_path')
                                      as ImageProvider<Object>,
                ),
                Positioned.fill(
                  child: Transform.rotate(
                    angle: 3.14 / 2,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      value: 0.5,
                      color: kPurple,
                      strokeWidth: isLargerScreen ? 14 : 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.025),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Column(
                children: [
                  Text(
                    '${userData['first_name']} ${userData['last_name']}',
                    style: isLargerScreen
                        ? kFont24Username
                        : kFont24Username.copyWith(fontSize: 20),
                  ),
                  Text('${userData['email']}', style: kFont14Black),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Divider(
            color: Color(0xFF95969D),
          ),
          GestureDetector(
            onTap: () {
              // Handle Change Password tap
              setState(() {
                _isEditProfile = false;
                _isMyProfile = false;
                _isChangePassword = true;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.005),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/lock.png',
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    'Change password',
                    style: kFont14Black,
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: Color(0xFF95969D),
          ),
          // GestureDetector(
          //   onTap: () {
          //    Get.toNamed(AppRoutes.paymentScreen);
          //   },
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(
          //         horizontal: screenWidth * 0.05,
          //         vertical: screenHeight * 0.005),
          //     child: Row(
          //       children: [
          //         Image.asset(
          //           'assets/images/lock.png',
          //           height: 20,
          //           width: 20,
          //         ),
          //         const SizedBox(
          //           width: 5,
          //         ),
          //         const Text(
          //           'Payment Details',
          //           style: kFont14Black,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // const Divider(
          //   color: Color(0xFF95969D),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, vertical: screenHeight * 0.005),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/notification.png',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'Notification',
                  style: kFont14Black,
                ),
                const Spacer(),
                Transform.scale(
                  scale: 0.4,
                  child: SizedBox(
                    width: 30,
                    height: 20,
                    child: CupertinoSwitch(
                      activeColor: kHighlightedColor,
                      trackColor: const Color(0xFF4E4949),
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(
                          () {
                            _rememberMe = value;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFF95969D),
          ),
          SizedBox(
              height:
                  isLargerScreen ? screenHeight * 0.18 : screenHeight * 0.05),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.07, vertical: screenHeight * 0.04),
            child: ElevatedButton(
              onPressed: () async {
                clearUserId();
                clearProfilePic();
                clearAccessToken();
                Get.offAllNamed(AppRoutes.welcome);
              },
              style: kElevatedButtonWithWhiteColor.copyWith(
                padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(
                      vertical: isLargerScreen
                          ? screenHeight * 0.009
                          : screenHeight * 0.005,
                      horizontal: isLargerScreen
                          ? screenWidth * 0.05
                          : screenWidth * 0.05),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_outlined,
                    color: kHighlightedColor,
                    size: isLargerScreen ? 24 : 18,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Log out',
                    style: kButtonTextStyle.copyWith(
                        color: kHighlightedColor,
                        fontSize: isLargerScreen ? 20 : 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildEditProfileContainer(
    BuildContext context,
    Map<String, dynamic> userData,
    double screenHeight,
    double screenWidth,
    bool isLargerScreen,
  ) {
    return Container(
      padding: EdgeInsets.only(
        top: isLargerScreen ? screenHeight * 0.057 : screenHeight * 0.0885,
        left: screenWidth * 0.08,
        right: screenWidth * 0.08,
        bottom: isLargerScreen ? screenHeight * 0.05 : screenHeight * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
            color: const Color(0x4D000000).withOpacity(0.08), width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: screenHeight * 0.075,
                      backgroundImage: (tempImage != null)
                          ? FileImage(File(
                              tempImage!.path)) // Show tempImage if present
                          : (selectedAvatarIndex != 0)
                              ? AssetImage(avatarList[selectedAvatarIndex])
                                  as ImageProvider<Object>
                              : (imageNetwork != null)
                                  ? NetworkImage(
                                      imageNetwork!) // Show imageNetwork if present
                                  : (avatarIndexNetwork != null)
                                      ? AssetImage(
                                              avatarList[avatarIndexNetwork!])
                                          as ImageProvider<
                                              Object> // Show avatarIndex image if present
                                      : const AssetImage('fallback_image_path')
                                          as ImageProvider<
                                              Object>, // Provide a fallback image path or handle accordingly
                    ),
                    Positioned.fill(
                      child: Transform.rotate(
                        angle: 3.14 / 2,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          value: 0.5,
                          color: kPurple,
                          strokeWidth: isLargerScreen ? 14 : 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: screenHeight * 0.009,
                right: isLargerScreen ? screenWidth * 0.23 : screenWidth * 0.24,
                child: GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: kPurple, width: 2),
                    ),
                    child: Image.asset(
                      'assets/images/edit.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  onTap: () {
                    _showChangeProfilePictureDialog(
                      context,
                      screenHeight,
                      screenWidth,
                      isLargerScreen,
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.035),
          const Text('First name', style: kFont14Black),
          SizedBox(height: screenHeight * 0.005),
          TextField(
            controller: _firstNameTextController,
            maxLength: 20,
            keyboardType: TextInputType.name,
            onChanged: (value) {
              setState(() {
                _validateFirstName = false;
              });
            },
            style: kTextFieldTextStyle.copyWith(),
            decoration: kTextFieldDecoration.copyWith(
              errorMaxLines: 2,
              errorStyle: const TextStyle(fontSize: 11),
              counterStyle: const TextStyle(fontSize: 9),
              isDense: isLargerScreen ? false : true,
              errorText: _validateFirstName ? _firstNameErrorText : null,
              hintText: 'Enter first name...',
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          const Text('Last name', style: kFont14Black),
          SizedBox(height: screenHeight * 0.005),
          TextField(
            maxLength: 20,
            controller: _lastNameTextController,
            keyboardType: TextInputType.name,
            onChanged: (value) {
              setState(() {
                _validateLastName = false;
              });
            },
            style: kTextFieldTextStyle,
            decoration: kTextFieldDecoration.copyWith(
              counterStyle: const TextStyle(fontSize: 9),
              errorStyle: const TextStyle(fontSize: 11),
              // counterText: "",
              errorMaxLines: 2,
              isDense: isLargerScreen ? false : true,
              errorText: _validateLastName ? _lastNameErrorText : null,
              hintText: 'Enter last name...',
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          const Text('Email', style: kFont14Black),
          TextField(
            enabled: false,
            style: kTextFieldTextStyle,
            decoration: kTextFieldDecoration.copyWith(
              isDense: isLargerScreen ? false : true,
              disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent)),
              hintText: '${userData['email']}',
            ),
          ),
          SizedBox(
              height:
                  isLargerScreen ? screenHeight * 0.03 : screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  tempImage = null;
                  _fileUploaded = false;
                  selectedAvatarIndex = avatarIndexNetwork;
                  setState(() {
                    _isMyProfile = true;
                    _isEditProfile = false;
                    _isChangePassword = false;
                  });
                },
                style: kElevatedButtonWhiteOpacityBG.copyWith(
                  elevation: MaterialStateProperty.all(0.001),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(
                        vertical: 0, horizontal: screenWidth * 0.08),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: kFont14Black.copyWith(fontSize: 16),
                ),
              ),
              SizedBox(width: screenWidth * 0.06),
              ElevatedButton(
                onPressed: () async {
                  if (_firstNameTextController.text.isEmpty) {
                    setState(() {
                      _validateFirstName = true;
                      _firstNameErrorText = 'Please enter first name';
                    });
                  } else if (!isNameValid(
                      _firstNameTextController.text.trim())) {
                    setState(() {
                      _validateFirstName = true;
                      _firstNameErrorText =
                          'Special characters are not allowed';
                    });
                  } else if (_firstNameTextController.text.contains(' ')) {
                    setState(() {
                      _validateFirstName = true;
                      _firstNameErrorText = 'Spaces are not allowed';
                    });
                  }

                  if (_lastNameTextController.text.trim().isNotEmpty &&
                      !isNameValid(_lastNameTextController.text.trim())) {
                    setState(() {
                      _validateLastName = true;
                      _lastNameErrorText = 'Special characters are not allowed';
                    });
                  } else if (_lastNameTextController.text.contains(' ')) {
                    setState(() {
                      _validateLastName = true;
                      _lastNameErrorText = 'Spaces are not allowed';
                    });
                  } else {
                    setState(() {
                      _validateLastName = false;
                      _lastNameErrorText = '';
                    });
                  }

                  if (_validateFirstName || _validateLastName) {
                    return;
                  }

                  if (await isInternetConnected()) {
                    await updateProfile(
                        token,
                        _firstNameTextController.text.trim(),
                        _lastNameTextController.text.trim(),
                        tempImage,
                        selectedAvatarIndex);
                  } else {
                    appSnackBar("Error", "No internet connectivity");
                  }

                  setState(() {
                    _profileFuture = retrieveProfile(token);
                    _isMyProfile = true;
                    _isEditProfile = false;
                    _isChangePassword = false;
                  });
                },
                style: kElevatedButtonWhiteOpacityBG.copyWith(
                  elevation: MaterialStateProperty.all(0.001),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(
                        vertical: 0, horizontal: screenWidth * 0.08),
                  ),
                  backgroundColor:
                      const MaterialStatePropertyAll(kHighlightedColor),
                ),
                child: Text(
                  'Save',
                  style: kFont14.copyWith(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildChangePasswordContainer(
    BuildContext context,
    double screenHeight,
    double screenWidth,
    bool isLargerScreen,
  ) {
    return Container(
      padding: EdgeInsets.only(
        top: isLargerScreen ? screenHeight * 0.02 : screenHeight * 0.02,
        left: screenWidth * 0.08,
        right: screenWidth * 0.08,
        // bottom:isLargerScreen? screenHeight * 0.05: screenHeight * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
            color: const Color(0x4D000000).withOpacity(0.08), width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.01),
          const Text('Current password', style: kFont14Black),
          SizedBox(height: screenHeight * 0.005),
          TextField(
            controller: _currentPasswordTextController,
            obscureText: !_currentPasswordVisible,
            onChanged: (value) {
              setState(
                () {
                  _validateCurrentPassword = false;
                },
              );
            },
            style: kTextFieldTextStyle,
            decoration: kTextFieldDecoration.copyWith(
              errorStyle: const TextStyle(fontSize: 11),
              isDense: isLargerScreen ? false : true,
              suffixIconConstraints: BoxConstraints(
                maxHeight: isLargerScreen ? 40 : 30,
                maxWidth: 50,
              ),
              errorText:
                  _validateCurrentPassword ? _currentPasswordErrorText : null,
              hintText: '**********',
              suffixIcon: IconButton(
                icon: Icon(
                  _currentPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF95969D),
                ),
                onPressed: () {
                  setState(() {
                    _currentPasswordVisible = !_currentPasswordVisible;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          const Text('New password', style: kFont14Black),
          SizedBox(height: screenHeight * 0.005),
          TextField(
            controller: _newPasswordTextController,
            obscureText: !_newPasswordVisible,
            onChanged: (value) {
              setState(() {
                _validateNewPassword = false;
              });
            },
            style: kTextFieldTextStyle,
            decoration: kTextFieldDecoration.copyWith(
              errorStyle: const TextStyle(fontSize: 11),
              isDense: isLargerScreen ? false : true,
              suffixIconConstraints: BoxConstraints(
                maxHeight: isLargerScreen ? 40 : 30,
                maxWidth: 50,
              ),
              errorText: _validateNewPassword ? _newPasswordErrorText : null,
              hintText: 'New password...',
              suffixIcon: IconButton(
                icon: Icon(
                  _newPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF95969D),
                ),
                onPressed: () {
                  setState(() {
                    _newPasswordVisible = !_newPasswordVisible;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          const Text('Confirm new password', style: kFont14Black),
          SizedBox(height: screenHeight * 0.005),
          TextField(
            controller: _newPasswordConfirmTextController,
            obscureText: !_confirmNewPasswordVisible,
            onChanged: (value) {
              setState(() {
                _validateConfirmPassword = false;
              });
            },
            style: kTextFieldTextStyle,
            decoration: kTextFieldDecoration.copyWith(
              errorStyle: const TextStyle(fontSize: 11),
              isDense: isLargerScreen ? false : true,
              suffixIconConstraints: BoxConstraints(
                maxHeight: isLargerScreen ? 40 : 30,
                maxWidth: 50,
              ),
              errorText:
                  _validateConfirmPassword ? _confirmPasswordErrorText : null,
              hintText: 'Confirm password...',
              suffixIcon: IconButton(
                icon: Icon(
                  _confirmNewPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF95969D),
                ),
                onPressed: () {
                  setState(() {
                    _confirmNewPasswordVisible = !_confirmNewPasswordVisible;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
          ElevatedButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              setState(() {
                _validateCurrentPassword = false;
                _validateNewPassword = false;
                _validateConfirmPassword = false;
                _currentPasswordErrorText = '';
                _newPasswordErrorText = '';
                _confirmPasswordErrorText = '';
              });

              if (_currentPasswordTextController.text.isEmpty) {
                setState(() {
                  _validateCurrentPassword = true;
                  _currentPasswordErrorText =
                      'Current password can\'t be empty';
                });
                return;
              }

              if (_newPasswordTextController.text.isEmpty) {
                setState(() {
                  _validateNewPassword = true;
                  _newPasswordErrorText = 'New password can\'t be empty';
                });
                return;
              } else if (_newPasswordTextController.text.length < 6) {
                setState(() {
                  _validateNewPassword = true;
                  _newPasswordErrorText = 'Must contain at least 6 characters';
                });
                return;
              } else if (!passwordContainsAlphabeticAndSpecial
                  .hasMatch(_newPasswordTextController.text)) {
                setState(() {
                  _validateNewPassword = true;
                  _newPasswordErrorText =
                      'One alphabetic and special character';
                });
                return;
              }

              if (_newPasswordConfirmTextController.text.isEmpty) {
                setState(() {
                  _validateConfirmPassword = true;
                  _confirmPasswordErrorText =
                      'Confirm password can\'t be empty';
                });
                return;
              } else if (_newPasswordConfirmTextController.text !=
                  _newPasswordTextController.text) {
                setState(() {
                  _validateConfirmPassword = true;
                  _confirmPasswordErrorText = 'Password must match';
                });
                return;
              }

              // Todo: call change password API
              if (!_validateCurrentPassword && !_validateConfirmPassword) {
                setState(() {
                  _isLoading = true;
                });
                try {
                  await changePasswordAPI(
                    oldPassword: _currentPasswordTextController.text,
                    newPassword: _newPasswordTextController.text,
                  );
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
            style: kElevatedButtonStyle.copyWith(
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(
                    vertical: isLargerScreen
                        ? screenHeight * 0.009
                        : screenHeight * 0.007,
                    horizontal: screenWidth * 0.08),
              ),
            ),
            child: _isLoading
                ? RotatingImage(
                    height: isLargerScreen ? 30 : 22,
                    width: isLargerScreen ? 30 : 22,
                  )
                : Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Change password',
                      style: isLargerScreen
                          ? kButtonTextStyle
                          : kButtonTextStyleSmallScreen,
                    ),
                  ),
          ),
          SizedBox(
            height: isLargerScreen ? screenHeight * 0.325 : screenHeight * 0.25,
          ),
        ],
      ),
    );
  }

  Future<void> _showChangeProfilePictureDialog(
    BuildContext context,
    double screenHeight,
    double screenWidth,
    bool isLargerScreen,
  ) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, state) => AlertDialog(
            insetPadding: EdgeInsets.only(
                left: screenWidth * 0.07, right: screenWidth * 0.07),
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.only(
                left: screenWidth * 0.035, right: screenWidth * 0.035),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      state(() {
                        tempImage = null;
                        _fileUploaded = false;
                      });
                    },
                    child: const Icon(Icons.close_rounded, size: 16),
                  ),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            backgroundColor: Colors.white,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                      color: const Color(0xFF4E4949).withOpacity(0.1),
                    ),
                    child: ToggleButtons(
                      renderBorder: false,
                      isSelected: isPictureSelected,
                      textStyle: dialogButtonTextStyle,
                      onPressed: (int index) {
                        state(() {
                          for (int buttonIndex = 0;
                              buttonIndex < 2;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              isPictureSelected[buttonIndex] = true;

                              selectedAvatarIndex = 0;
                              isFirstIndex = false;
                              isSecondIndex = true;
                            } else {
                              isPictureSelected[buttonIndex] = false;
                              tempImage = null;
                              _fileUploaded = false;
                              isFirstIndex = true;
                              isSecondIndex = false;
                            }
                          }
                        });
                      },
                      splashColor: Colors.transparent,
                      fillColor: Colors.transparent,
                      selectedColor: kHighlightedColor,
                      constraints: BoxConstraints(
                        minHeight: screenHeight * 0.04,
                        minWidth: screenWidth * 0.385,
                        maxHeight: screenHeight * 0.06,
                        maxWidth: screenWidth * 0.41,
                      ),
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.11, vertical: 10),
                          decoration: BoxDecoration(
                              color: isFirstIndex
                                  ? const Color(0xFFFFFFFF)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            "Picture",
                            style: kFont8Black.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: isFirstIndex
                                  ? kHighlightedColor
                                  : Colors.black,
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.12, vertical: 10),
                          decoration: BoxDecoration(
                              color: isSecondIndex
                                  ? const Color(0xFFFFFFFF)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            "Avatar",
                            style: kFont8Black.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: !isFirstIndex
                                  ? kHighlightedColor
                                  : Colors.black,
                            ),
                          ),
                        ),
                        // Text('Avatar'),
                      ],
                    ),
                  ),
                ),
                if (isPictureSelected[1])
                  Column(
                    children: [
                      SizedBox(height: screenHeight * 0.015),
                      Text('Choose avatar',
                          style: kFont8Black.copyWith(
                              fontSize: 17, fontWeight: FontWeight.w500)),
                      SizedBox(height: screenHeight * 0.015),
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                                radius: screenHeight * 0.05,
                                backgroundImage: AssetImage(
                                    avatarList[selectedAvatarIndex])),
                            Positioned.fill(
                              child: Transform.rotate(
                                angle: 3.14 / 2,
                                child: const CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  value: 0.5,
                                  color: kPurple,
                                  strokeWidth: 7,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        children: [
                          Text('Select avatar',
                              style: kFont8Black.copyWith(fontSize: 14)),
                        ],
                      ),
                      const Divider(),
                      SizedBox(height: screenHeight * 0.01),
                      SizedBox(
                        height: screenHeight * 0.17,
                        width: screenWidth * 0.75,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: avatarList.length - 1,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                state(() {
                                  selectedAvatarIndex = index + 1;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(avatarList[index + 1]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                if (isPictureSelected[0])
                  Column(
                    children: [
                      SizedBox(height: screenHeight * 0.015),
                      Text(
                        'Upload picture',
                        style: kFont8Black.copyWith(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      DottedBorder(
                        color: kPurple,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(8),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/upload.png',
                                  height: 35,
                                  width: 42,
                                ),
                                SizedBox(height: screenHeight * 0.008),
                                Text(
                                  'Upload your files here',
                                  style: kFont12.copyWith(color: Colors.black),
                                ),
                                SizedBox(height: screenHeight * 0.005),
                                GestureDetector(
                                    onTap: () async {
                                      final pickedFile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        final file = File(pickedFile.path);
                                        int fileSizeBytes = await file.length();
                                        double fileSizeKB =
                                            fileSizeBytes / 1024;
                                        state(() {
                                          _fileUploaded = true;
                                          tempImage = pickedFile;
                                          _fileName = pickedFile.name;
                                          _fileSize =
                                              '${fileSizeKB.toStringAsFixed(2)} KB';
                                        });
                                        for (int i = 0; i <= 100; i += 10) {
                                          await Future.delayed(const Duration(
                                              milliseconds: 100));
                                          state(() {
                                            _progress = i / 100;
                                            _timeRemaining =
                                                '${(10 - i ~/ 10)} sec';
                                          });
                                        }
                                      } else {
                                        print("Image picking canceled");
                                      }
                                    },
                                    child: Text(
                                      'Browse',
                                      style: kFont8Black.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: kPurple,
                                        decoration: TextDecoration.underline,
                                        decorationColor: kPurple,
                                        decorationThickness: 2.0,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 3.0,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: _fileUploaded
                            ? GestureDetector(
                                onTap: () {
                                  state(() {
                                    tempImage = null;
                                    _fileUploaded = false;
                                  });
                                },
                                child:
                                    const Icon(Icons.cancel_outlined, size: 14),
                              )
                            : const Text(
                                'JPG or PNG',
                                style: kFont8Black,
                              ),
                      ),
                      Visibility(
                        visible: _fileUploaded,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _fileName,
                              style: kFont10.copyWith(color: Colors.black),
                            ),
                            Text(
                              _fileSize,
                              style: kFont8.copyWith(color: Colors.black),
                            ),
                            const SizedBox(height: 2),
                            LinearProgressIndicator(
                              minHeight: 1.5,
                              value: _progress,
                              backgroundColor: kPurple,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  kHighlightedColor),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              'Time remaining: $_timeRemaining',
                              style: kFont7.copyWith(
                                  color: const Color(0xFF4E4949)),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: screenHeight * 0.009),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            tempImage = null;
                            _fileUploaded = false;
                            selectedAvatarIndex = 0;
                          });
                          Navigator.pop(context);
                        },
                        style: kElevatedButtonWhiteOpacityBG,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: kFont12.copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _fileUploaded = false;
                          if (tempImage != null) {
                            print("Avatar Deleted");
                          } else {
                            print(" Image Deleted");
                          }
                          setState(() {
                            _isEditProfile = true;
                            _isMyProfile = false;
                          });
                          Get.back();
                        },
                        style: kElevatedButtonPrimaryBG,
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Submit',
                            style: kFont12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.015,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
