import 'dart:convert';
import 'package:crewdog_cv_lab/routes/app_routes.dart';
import 'package:crewdog_cv_lab/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../custom_widgets/rotating_image.dart';
import '../utils/constants.dart';
import '../utils/functions.dart';
import '../utils/local_db.dart';
import 'controllers/google_signin_controller.dart';
import 'package:crewdog_cv_lab/screens/controllers/apple_sign_in.dart';

import 'controllers/profile_controller.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  bool _validateEmail = false;
  bool _validatePassword = false;
  bool _passwordVisible = false;
  bool _isLoading = false;
  String _emailErrorText = 'Email can\'t be empty';
  String _passwordErrorText = 'Password can\'t be Empty';

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  Future<bool> loginUser(String username, String password) async {
    if (await isInternetConnected()) {
      const apiUrl = '$baseUrl/accounts/api/login/';
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': username,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          print(responseData);
          final String? access = responseData['access'];

          if (access != null) {
            print('Login successful. Access Token: $access');
            storeAccessToken(access);

            var response = await fetchProfile(access);
            print(response);
            var id = response['id'];
            // var email = responseData['email'];
            var profilePic = response['profile_pic'];
            // var firstName = response['first_name'];
            // var lastName = response['last_name'];
            // var avatarUrl = response['avatar_url'];
            storeUserId(id.toString());
            if (profilePic != null) {
              print("Profile Pic Stored");
              storeProfilePic(profilePic);
            }
            return true;
          } else {
            print(' Error: Access token not found in response.');
            return false;
          }
        } else {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          appSnackBar(" Error", " ${errorData['error']}");
          return false;
        }
      } catch (e) {
        print('Error during login: $e');
        return false;
      }
    } else {
      appSnackBar(" Error", "No internet connectivity");
      return false;
    }
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
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_paws.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 50,
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: isLargerScreen
                              ? screenHeight * 0.11
                              : screenHeight * 0.09,
                        ),
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          top: isLargerScreen
                              ? screenHeight * 0.012
                              : screenHeight * 0.012,
                          left: isLargerScreen
                              ? screenWidth * 0.04
                              : screenWidth * 0.07,
                          right: isLargerScreen
                              ? screenWidth * 0.04
                              : screenWidth * 0.07,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFFAFA), // Background color
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25.0)),
                          // Border radius
                          border: Border.fromBorderSide(
                            BorderSide(color: Color(0xFFFFEFEE), width: 1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                screenWidth * 0.04,
                                screenHeight * 0.008,
                                screenWidth * 0.04,
                                0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'Sign in',
                                      style: isLargerScreen
                                          ? kHeadingTextStyle
                                          : kHeadingTextStyleSmallScreen,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                      height: isLargerScreen
                                          ? screenHeight * 0.018
                                          : screenHeight * 0.01),
                                  const Text('Email',
                                      style: kTextFieldTextStyle),
                                  TextField(
                                    controller: _emailTextController,
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {
                                      setState(() {
                                        _validateEmail = false;
                                      });
                                    },
                                    style: kTextFieldTextStyle,
                                    decoration: kTextFieldDecoration.copyWith(
                                      isDense: isLargerScreen ? false : true,
                                      errorText: _validateEmail
                                          ? _emailErrorText
                                          : null,
                                      hintText: 'Enter email address...',
                                      errorStyle: TextStyle(
                                          fontSize: isLargerScreen ? 11 : 10),
                                    ),
                                  ),
                                  SizedBox(
                                      height: isLargerScreen
                                          ? screenHeight * 0.015
                                          : screenHeight * 0.01),
                                  const Text('Password',
                                      style: kTextFieldTextStyle),
                                  TextField(
                                    controller: _passwordTextController,
                                    obscureText: !_passwordVisible,
                                    onChanged: (value) {
                                      setState(() {
                                        _validatePassword = false;
                                        _passwordErrorText =
                                            'Password can\'t be empty'; // Reset the error text
                                      });
                                    },
                                    style: kTextFieldTextStyle,
                                    decoration: kTextFieldDecoration.copyWith(
                                      isDense: isLargerScreen ? false : true,
                                      errorText: _validatePassword
                                          ? _passwordErrorText
                                          : null,
                                      errorStyle: TextStyle(
                                          fontSize: isLargerScreen ? 11 : 10),
                                      hintText: 'Enter password...',
                                      errorMaxLines: 2,
                                      suffixIconConstraints: BoxConstraints(
                                        maxHeight: isLargerScreen ? 40 : 30,
                                        maxWidth: 50,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _passwordVisible
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: const Color(0xFF95969D),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed(AppRoutes.forgetPassword);
                                        },
                                        child: const Text(
                                          'Forgot Password?',
                                          style: kForgetPasswordTextStyle,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      height: isLargerScreen
                                          ? screenHeight * 0.02
                                          : screenHeight * 0.01),
                                  ElevatedButton(
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();

                                      setState(() {
                                        _validateEmail = false;
                                        _validatePassword = false;
                                        _emailErrorText =
                                            'Email can\'t be empty'; // Reset the error text
                                        _passwordErrorText =
                                            'Password can\'t be empty'; // Reset the error text
                                      });

                                      if (_emailTextController.text.isEmpty) {
                                        setState(() {
                                          _validateEmail = true;
                                        });
                                        return;
                                      } else if (!isValidEmail(
                                          _emailTextController.text)) {
                                        setState(() {
                                          _validateEmail = true;
                                          _emailErrorText =
                                              'Invalid email format';
                                        });
                                        return;
                                      }
                                      if (_passwordTextController
                                          .text.isEmpty) {
                                        setState(() {
                                          _validatePassword = true;
                                          _passwordErrorText =
                                              'Password can\'t be empty';
                                        });
                                        return;
                                      } else if (_passwordTextController
                                              .text.length <
                                          6) {
                                        setState(() {
                                          _validatePassword = true;
                                          _passwordErrorText =
                                              'Password must be at least 6 characters';
                                        });
                                        return;
                                      } else if (!passwordContainsAlphabeticAndSpecial
                                          .hasMatch(
                                              _passwordTextController.text)) {
                                        setState(() {
                                          _validatePassword = true;
                                          _passwordErrorText =
                                              'At least one alphabetic and special character';
                                        });
                                        return;
                                      }

                                      setState(() {
                                        _isLoading = true;
                                      });

                                      try {
                                        final loginSuccess = await loginUser(
                                          _emailTextController.text,
                                          _passwordTextController.text,
                                        );

                                        if (loginSuccess) {
                                          Get.offAllNamed(AppRoutes.bottomBar);
                                        }
                                      } finally {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF5E59),
                                      padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.007,
                                          horizontal: screenWidth * 0.008),
                                      minimumSize:
                                          const Size(double.infinity, 0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: const BorderSide(
                                            color: Color(0xFFFF5E59)),
                                      ),
                                    ).copyWith(
                                      elevation: MaterialStateProperty.all(5),
                                      shadowColor: MaterialStateProperty.all(
                                          const Color(0x8096BEE7)),
                                    ),
                                    child: _isLoading
                                        ? RotatingImage(
                                            height: isLargerScreen ? 30 : 22,
                                            width: isLargerScreen ? 30 : 22,
                                          ) // Show loading indicator
                                        : Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Sign in',
                                              style: isLargerScreen
                                                  ? kButtonTextStyle
                                                  : kButtonTextStyleSmallScreen,
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                      height: isLargerScreen
                                          ? screenHeight * 0.04
                                          : screenHeight * 0.02),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Color(0xFF95969D),
                                          thickness: 1,
                                          height: 10,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          'or sign in with',
                                          style: kFont12Grey,
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Color(0xFF95969D),
                                          thickness: 1,
                                          height: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: isLargerScreen
                                          ? screenHeight * 0.03
                                          : screenHeight * 0.017),
                                  getPlatformInfo()
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                googleSignIn();
                                              },
                                              child: Container(
                                                height: screenHeight * 0.045,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Image.asset(
                                                  'assets/images/google.png',
                                                  height: 24,
                                                  width: 24,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: appleSignIn,
                                              child: Container(
                                                // width: 90,
                                                height: screenHeight * 0.045,
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Image.asset(
                                                  'assets/images/apple.png',
                                                  height: 24,
                                                  width: 24,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Center(
                                          child: GestureDetector(
                                            onTap: googleSignIn,
                                            child: Container(
                                              // width: 90,
                                              height: screenHeight * 0.045,
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Image.asset(
                                                'assets/images/google.png',
                                                height: 24,
                                                width: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),

                            // after this all widgets should be at bottom of screen
                            const Expanded(child: SizedBox()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Don\'t have an account? ',
                                  style: isLargerScreen
                                      ? kFont12Grey
                                      : kFont12GreySmallScreen,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.offNamed(AppRoutes.signup);
                                  },
                                  child: Text(
                                    'Sign up',
                                    style: isLargerScreen
                                        ? kFont12.copyWith(
                                            color: kHighlightedColor,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: kHighlightedColor)
                                        : kFont12GreySmallScreen.copyWith(
                                            color: kHighlightedColor,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: kHighlightedColor),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Image.asset(
                                  'assets/images/dog_email_container.png',
                                  height: isLargerScreen
                                      ? screenHeight * 0.14
                                      : screenHeight * 0.1,
                                  width: isLargerScreen
                                      ? screenWidth * 0.2
                                      : screenWidth * 0.15,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: isLargerScreen
                            ? screenHeight * 0.0175
                            : screenHeight * 0.003,
                        left: isLargerScreen
                            ? screenWidth * 0.05
                            : screenWidth * 0.09,
                        child: Image(
                          image: const AssetImage(
                              'assets/images/girl_email_container.png'),
                          height: isLargerScreen
                              ? screenHeight * 0.11
                              : screenHeight * 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
