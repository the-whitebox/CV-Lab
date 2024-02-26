import 'dart:convert';
import 'package:crewdog_cv_lab/routes/app_routes.dart';
import 'package:crewdog_cv_lab/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../custom_widgets/rotating_image.dart';
import '../utils/constants.dart';
import '../utils/functions.dart';
import '../utils/local_db.dart';
import 'controllers/google_signin_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _usernameController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final apiUrl = '$baseUrl/accounts/api/signup/';

  bool _isLoading = false;
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool _validateConfirmPassword = false;
  bool _validateUsername = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String _usernameErrorText = 'Name can\'t be empty';
  String _emailErrorText = 'Email can\'t be empty';
  String _passwordErrorText = 'Password can\'t be empty';
  String _confirmPasswordErrorText = 'Confirm password can\'t be empty';
  bool _registrationSuccessful = false;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  Future<void> registerUser(
    String username,
    String email,
    String password,
  ) async {
    if (await isInternetConnected()) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'first_name': username,
            'email': email,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            _registrationSuccessful = true;
          });
        } else {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          final String? errorMessage = errorData['non_field_errors'];

          if (errorMessage != null) {
            appSnackBar(" Error", errorMessage);
          } else {
            setState(() {
              _registrationSuccessful = false;
            });
            print('Signup failed: ${response.body}');
            appSnackBar(" Error", "Signup failed. Please try again.");
          }
        }
      } catch (e) {
        setState(() {
          _registrationSuccessful = false;
        });
        print('Error during signup: $e');
      }
    } else {
      appSnackBar(" Error", "No internet connectivity");
      _registrationSuccessful = false;
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
                              padding: EdgeInsets.fromLTRB(screenWidth * 0.04,
                                  screenHeight * 0.008, screenWidth * 0.04, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'Sign up',
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
                                  const Text('Name',
                                      style: kTextFieldTextStyle),
                                  TextField(
                                    controller: _usernameController,
                                    keyboardType: TextInputType.name,
                                    onChanged: (value) {
                                      setState(() {
                                        _validateUsername = false;
                                        _usernameErrorText = "";
                                      });
                                    },
                                    style: kTextFieldTextStyle,
                                    decoration: kTextFieldDecoration.copyWith(
                                      errorStyle: TextStyle(
                                          fontSize: isLargerScreen ? 11 : 10),
                                      isDense: isLargerScreen ? false : true,
                                      errorText: _validateUsername
                                          ? _usernameErrorText
                                          : null,
                                      hintText: 'Enter name...',
                                    ),
                                  ),
                                  SizedBox(
                                      height: isLargerScreen
                                          ? screenHeight * 0.011
                                          : screenHeight * 0.008),
                                  const Text('Email',
                                      style: kTextFieldTextStyle),
                                  TextField(
                                    controller: _emailTextController,
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {
                                      setState(() {
                                        _validateEmail = false;
                                        _emailErrorText =
                                            'Email can\'t be empty';
                                      });
                                    },
                                    style: kTextFieldTextStyle,
                                    decoration: kTextFieldDecoration.copyWith(
                                      errorStyle: TextStyle(
                                          fontSize: isLargerScreen ? 11 : 10),
                                      isDense: isLargerScreen ? false : true,
                                      errorText: _validateEmail
                                          ? _emailErrorText
                                          : null,
                                      hintText: 'Enter email address...',
                                    ),
                                  ),
                                  SizedBox(
                                      height: isLargerScreen
                                          ? screenHeight * 0.011
                                          : screenHeight * 0.008),
                                  const Text('Password',
                                      style: kTextFieldTextStyle),
                                  TextField(
                                    controller: _passwordTextController,
                                    obscureText: !_passwordVisible,
                                    onChanged: (value) {
                                      setState(() {
                                        _validatePassword = false;
                                        _passwordErrorText =
                                            'Password can\'t be empty';
                                      });
                                    },
                                    style: kTextFieldTextStyle,
                                    decoration: kTextFieldDecoration.copyWith(
                                      errorStyle: TextStyle(
                                          fontSize: isLargerScreen ? 11 : 10),
                                      isDense: isLargerScreen ? false : true,
                                      suffixIconConstraints: BoxConstraints(
                                          maxHeight: isLargerScreen ? 40 : 30,
                                          maxWidth: 50),
                                      errorText: _validatePassword
                                          ? _passwordErrorText
                                          : null,
                                      errorMaxLines: 5,
                                      hintText: 'Enter password...',
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
                                  SizedBox(
                                      height: isLargerScreen
                                          ? screenHeight * 0.011
                                          : screenHeight * 0.008),
                                  const Text('Confirm password',
                                      style: kTextFieldTextStyle),
                                  TextField(
                                    controller: _confirmPasswordTextController,
                                    obscureText: !_confirmPasswordVisible,
                                    onChanged: (value) {
                                      setState(() {
                                        _validateConfirmPassword = false;
                                        _confirmPasswordErrorText =
                                            ''; // Reset error text when the value changes
                                      });
                                    },
                                    style: kTextFieldTextStyle,
                                    decoration: kTextFieldDecoration.copyWith(
                                      errorStyle: TextStyle(
                                          fontSize: isLargerScreen ? 11 : 10),
                                      isDense: isLargerScreen ? false : true,
                                      suffixIconConstraints: BoxConstraints(
                                          maxHeight: isLargerScreen ? 40 : 30,
                                          maxWidth: 50),
                                      errorText: _validateConfirmPassword
                                          ? _confirmPasswordErrorText
                                          : null,
                                      hintText: 'Confirm password...',
                                      errorMaxLines: 5,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _confirmPasswordVisible
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: const Color(0xFF95969D),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _confirmPasswordVisible =
                                                !_confirmPasswordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height: isLargerScreen
                                          ? screenHeight * 0.017
                                          : screenHeight * 0.009),
                                  ElevatedButton(
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        _validateUsername = false;
                                        _validateEmail = false;
                                        _validatePassword = false;
                                        _validateConfirmPassword = false;
                                        _usernameErrorText =
                                            'Name can\'t be empty';
                                        _emailErrorText =
                                            'Email can\'t be empty';
                                        _passwordErrorText =
                                            'Password can\'t be empty';
                                      });

                                      // Validation logic
                                      if (_usernameController.text.isEmpty) {
                                        setState(() {
                                          _validateUsername = true;
                                          _usernameErrorText =
                                              'Name can\'t be empty';
                                        });
                                      } else if (_usernameController
                                              .text.length <
                                          3) {
                                        setState(() {
                                          _validateUsername = true;
                                          _usernameErrorText =
                                              'Name must be at least 3 characters';
                                        });
                                      } else if (!isNameValid(
                                          _usernameController.text)) {
                                        setState(() {
                                          _validateUsername = true;
                                          _usernameErrorText =
                                              'Name must be only characters';
                                        });
                                      } else if (_emailTextController
                                          .text.isEmpty) {
                                        setState(() {
                                          _validateEmail = true;
                                          _emailErrorText =
                                              'Email can\'t be empty';
                                        });
                                      } else if (!isValidEmail(
                                          _emailTextController.text)) {
                                        setState(() {
                                          _validateEmail = true;
                                          _emailErrorText =
                                              'Invalid email format';
                                        });
                                      } else if (_emailTextController.text
                                              .split('.')
                                              .last
                                              .length >
                                          3) {
                                        setState(() {
                                          _validateEmail = true;
                                          _emailErrorText =
                                              'Invalid email format';
                                        });
                                      } else if (!isValidEmail(
                                          _emailTextController.text)) {
                                        setState(() {
                                          _validateEmail = true;
                                          _emailErrorText =
                                              'Invalid email format';
                                        });
                                      } else if (_passwordTextController
                                          .text.isEmpty) {
                                        setState(() {
                                          _validatePassword = true;
                                          _passwordErrorText =
                                              'Password can\'t be empty';
                                        });
                                      } else if (_passwordTextController
                                              .text.length <
                                          6) {
                                        setState(() {
                                          _validatePassword = true;
                                          _passwordErrorText =
                                              'Password must be at least 6 characters';
                                        });
                                      } else if (!passwordContainsAlphabeticAndSpecial
                                          .hasMatch(
                                              _passwordTextController.text)) {
                                        setState(() {
                                          _validatePassword = true;
                                          _passwordErrorText =
                                              'At least one alphabetic and special character';
                                        });
                                      } else if (_confirmPasswordTextController
                                          .text.isEmpty) {
                                        setState(() {
                                          _validateConfirmPassword = true;
                                          _confirmPasswordErrorText =
                                              'Confirm password can\'t be empty';
                                        });
                                      } else if (_passwordTextController.text !=
                                          _confirmPasswordTextController.text) {
                                        setState(() {
                                          _validateConfirmPassword = true;
                                          _confirmPasswordErrorText =
                                              'Password must match';
                                        });
                                      } else {
                                        // All fields are filled, proceed with registration
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        try {
                                          await registerUser(
                                            _usernameController.text,
                                            _emailTextController.text,
                                            _passwordTextController.text,
                                          );

                                          if (_registrationSuccessful) {
                                            Get.offAllNamed(AppRoutes.signin);
                                            appSuccessSnackBar(
                                              "Success",
                                              'Signup Successfully. Please login now.',
                                            );
                                          }
                                        } finally {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
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
                                          )
                                        : Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Sign up',
                                              style: isLargerScreen
                                                  ? kButtonTextStyle
                                                  : kButtonTextStyleSmallScreen,
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                      height: isLargerScreen
                                          ? screenHeight * 0.017
                                          : screenHeight * 0.012),
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
                                          'or sign up with',
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
                                          ? screenHeight * 0.012
                                          : screenHeight * 0.012),
                                  getPlatformInfo()
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: googleSignIn,
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
                                                  'assets/images/google.png',
                                                  height: 24,
                                                  width: 24,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                /// DONE: implement Apple log-in
                                                final credentials =
                                                    await SignInWithApple
                                                        .getAppleIDCredential(
                                                            scopes: [
                                                      AppleIDAuthorizationScopes
                                                          .email,
                                                      AppleIDAuthorizationScopes
                                                          .fullName,
                                                    ]);
                                                print(
                                                    'IdToken: ${credentials.identityToken}');

                                                // Send the identity token to server
                                                final response =
                                                    await http.post(
                                                  Uri.parse(
                                                      '$baseUrl/accounts/social/apple/login/'),
                                                  body: {
                                                    'token': credentials
                                                        .identityToken
                                                  },
                                                );

                                                // Handle the server response
                                                if (response.statusCode ==
                                                    200) {
                                                  // Authentication successful on the server side
                                                  print(
                                                      '***Server Response: ${response.body}');
                                                } else {
                                                  // Handle errors
                                                  print(
                                                      'Server Error: ${response.statusCode}');
                                                  print(
                                                      'Server Response: ${response.body}');
                                                }
                                              },
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
                                  'Already have an account! ',
                                  style: isLargerScreen
                                      ? kFont12Grey
                                      : kFont12GreySmallScreen,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.offNamed(AppRoutes.signin);
                                  },
                                  child: Text(
                                    'Sign in',
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
