import 'dart:convert';
import 'dart:io';
import 'package:crewdog_cv_lab/routes/app_routes.dart';
import 'package:crewdog_cv_lab/utils/app_snackbar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../custom_widgets/rotating_image.dart';
import '../utils/constants.dart';
import '../utils/app_functions.dart';

enum ResetPasswordResult {
  successful,
  failed,
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final apiUrl = '$baseUrl/accounts/api/sendOTP/';

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final _textEditingController = TextEditingController();
  String _resetPasswordToken = '';
  String _resetPasswordUserId = '';
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _validateConfirmPassword = false;
  bool _isForgotPassword = true;
  bool _is4Digit = false;
  bool _isPasswordReset = false;
  bool _otpSentSuccessfully = false;
  bool _verifyOtp = false;
  String _emailErrorText = 'Email can\'t be empty';
  String _passwordErrorText = 'Password can\'t be empty';
  String _confirmPasswordErrorText = 'Confirm password can\'t be empty';
  bool _isLoading = false;
  bool _validatePin = false;
  String _pinErrorText = '';

  Future<void> sendOTP(String email) async {
    const sendOTPApiUrl = '$baseUrl/accounts/api/sendOTP/';
    if (await isInternetConnected()) {
      try {
        final response = await http.post(
          Uri.parse(sendOTPApiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            _otpSentSuccessfully = true;
          });
          appSuccessSnackBar('Success', 'OTP sent successfully');
        } else {
          setState(() {
            _otpSentSuccessfully = false;
          });
          final responseBody = response.body;
          if (responseBody.contains('User does not exist')) {
            appSnackBar(' Error', 'User does not exist');
          } else {
            appSnackBar(' Error', 'Failed to send OTP: $responseBody');
          }
        }
      } catch (e) {
        setState(() {
          _otpSentSuccessfully = false;
        });
        print('Error $e');
      }
    } else {
      appSnackBar(" Error", "No internet connectivity");

      _otpSentSuccessfully = false;
    }
  }


  Future<void> resendOTP(String email) async {
    const sendOTPApiUrl = '$baseUrl/accounts/api/sendOTP/';
    if (await isInternetConnected()) {
      try {
        final response = await http.post(
          Uri.parse(sendOTPApiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
          }),
        );

        if (response.statusCode == 200) {
          setState(() {
            _otpSentSuccessfully = true;
          });
          appSuccessSnackBar('Success', 'OTP resend successfully');
        } else {
          setState(() {
            _otpSentSuccessfully = false;
          });
            appSnackBar(' Error', 'Failed to resend OTP: $response.body');
        }
      } catch (e) {
        setState(() {
          _otpSentSuccessfully = false;
        });
        print('Error $e');
      }
    } else {
      appSnackBar(" Error", "No internet connectivity");

      _otpSentSuccessfully = false;
    }
  }

  Future<void> verifyOTP(String email, String otp) async {
    const verifyOTPapiUrl = '$baseUrl/accounts/api/verifyOTP/';
    if (await isInternetConnected()) {
      try {
        final response = await http.post(
          Uri.parse(verifyOTPapiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'otp': otp,
          }),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          setState(() {
            _resetPasswordToken = responseData['token'];
            _resetPasswordUserId = responseData['uid'];
            _verifyOtp = true;
          });
        } else {
          _verifyOtp = false;

          final Map<String, dynamic> errorData = jsonDecode(response.body);
          appSnackBar(' Error', "${errorData['message']}");

          print('Failed to verify OTP: ${response.body}');
        }
      } catch (e) {
        _verifyOtp = false;
        print('Error verifying OTP: $e');
      }
    } else {
      appSnackBar(" Error", "No internet connectivity");
      _verifyOtp = false;
    }
  }

  Future<ResetPasswordResult> resetPassword(
    String newPassword,
    String token,
    String uid,
  ) async {
    const resetPasswordApiUrl = '$baseUrl/accounts/api/resetPassword/';
    if (await isInternetConnected()) {
      try {
        final response = await http.post(
          Uri.parse(resetPasswordApiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'password': newPassword,
            'token': token,
            'uidb64': uid,
          }),
        );
        if (response.statusCode == 200) {
          appSuccessSnackBar("Success", "Password has been reset successfully");
          return ResetPasswordResult.successful;
        } else {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          final String errorMessage = errorData['detail'] ?? 'Unknown error';
          appSnackBar('Error', errorMessage);

          return ResetPasswordResult.failed;
        }
      } catch (e) {
        print('Error resetting password: $e');
        return ResetPasswordResult.failed;
      }
    } else {
      appSnackBar(" Error", "No internet connectivity");
      return ResetPasswordResult.failed;
    }
  }

  @override
  void dispose() {
    super.dispose();
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left:0,
                        child: Image(
                          image:
                          const AssetImage('assets/images/boy_forgot_password_container.png'),
                          height: isLargerScreen ? screenHeight * 0.15 : screenHeight * 0.15,
                          width: isLargerScreen ? screenWidth * 0.4 : screenWidth * 0.3,
                        ),
                      ),
                      Visibility(
                        visible: _isForgotPassword,
                        child: buildForgotPasswordContainer(
                            context, screenHeight, screenWidth, isLargerScreen),
                      ),
                      Visibility(
                        visible: _is4Digit,
                        child:
                            buildOTPContainer(context, screenHeight, screenWidth, isLargerScreen),
                      ),
                      Visibility(
                        visible: _isPasswordReset,
                        child: buildPasswordResetContainer(
                            context, screenHeight, screenWidth, isLargerScreen),
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

  Container buildForgotPasswordContainer(
      BuildContext context, double screenHeight, double screenWidth, bool isLargerScreen) {
    return Container(
      margin: EdgeInsets.only(top: isLargerScreen ? screenHeight * 0.133 : screenHeight * 0.13),
      width: double.infinity,
      padding: EdgeInsets.only(
        top: isLargerScreen ? screenHeight * 0.02 : screenHeight * 0.01,
        left: isLargerScreen ? screenWidth * 0.04:screenWidth * 0.07,
        right: isLargerScreen ? screenWidth * 0.04:screenWidth * 0.07,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFAFA), // Background color
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        // Border radius
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFFFFEFEE), width: 1),
        ),
      ),
      child: Padding(
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
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Forgot password',
                  style: isLargerScreen ? kHeadingTextStyle : kHeadingTextStyleSmallScreen,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                'Enter your email for the verification process.',
                style: isLargerScreen ? kFont12Grey : kFont12GreySmallScreen,
              ),
            ),
            SizedBox(height: isLargerScreen ? screenHeight * 0.025 : screenHeight * 0.015),
            const Text('Email', style: kTextFieldTextStyle),
            SizedBox(height: isLargerScreen ? screenHeight * 0.01 : screenHeight * 0.005),
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
                errorStyle: TextStyle(fontSize: isLargerScreen ? 11 : 10),
                isDense: isLargerScreen ? false : true,
                errorText: _validateEmail ? _emailErrorText : null,
                hintText: 'Enter email address...',
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                setState(() {
                  _validateEmail = false; // Reset email validation error
                });

                // Check if email is empty
                if (_emailTextController.text.isEmpty) {
                  setState(() {
                    _validateEmail = true;
                    _emailErrorText = 'Email can\'t be empty';
                  });
                  return;
                }

                // Check if email is in valid format
                if (!isValidEmail(_emailTextController.text)) {
                  setState(() {
                    _validateEmail = true;
                    _emailErrorText = 'Invalid email format';
                  });
                  return;
                }
                setState(() {
                  _isLoading = true;
                });
                try {
                  await sendOTP(_emailTextController.text);

                  if (_otpSentSuccessfully) {
                    setState(() {
                      _isForgotPassword = false;
                      _isPasswordReset = false;
                      _is4Digit = true;
                    });
                  } else {
                    print('Failed to send OTP');
                  }
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              style: kElevatedButtonStyle.copyWith(
    padding:MaterialStateProperty.all(
    EdgeInsets.symmetric(vertical: screenHeight*0.007, horizontal:screenWidth*0.008),
    ),
    ),
              child: _isLoading
                  ?  RotatingImage(
                      height:isLargerScreen? 30:22,
                      width: isLargerScreen? 30:22,
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Send',
                        style: isLargerScreen ? kButtonTextStyle : kButtonTextStyleSmallScreen,
                      ),
                    ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Back to? ',
                      style: kFont12.copyWith(color: kLightGrey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offNamed(AppRoutes.signin);
                      },
                      child: Text(
                        'Sign in',
                        style: kFont12.copyWith(
                            color: kHighlightedColor,
                            decoration: TextDecoration.underline,
                            decorationColor: kHighlightedColor),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/dog_email_container.png',
                  height: isLargerScreen ? screenHeight * 0.14 : screenHeight * 0.1,
                  width: isLargerScreen ? screenWidth * 0.2 : screenWidth * 0.15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildOTPContainer(
      BuildContext context, double screenHeight, double screenWidth, bool isLargerScreen) {
    return Container(
      margin: EdgeInsets.only(top: isLargerScreen ? screenHeight * 0.133 : screenHeight * 0.13),
      width: double.infinity,
      padding: EdgeInsets.only(
        top: isLargerScreen ? screenHeight * 0.02 : screenHeight * 0.01,
        left: isLargerScreen ? screenWidth * 0.04:screenWidth * 0.07,
        right: isLargerScreen ? screenWidth * 0.04:screenWidth * 0.07,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFAFA), // Background color
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        // Border radius
        border: Border.fromBorderSide(
          BorderSide(color: Color(0xFFFFEFEE), width: 1),
        ),
      ),
      child: Column(
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
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Enter 4 digit code',
                      style: isLargerScreen ? kHeadingTextStyle : kHeadingTextStyleSmallScreen,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Enter the 4 digit code that you received on your email.',
                    style: isLargerScreen ? kFont12Grey : kFont12GreySmallScreen,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: isLargerScreen ? screenHeight * 0.06 : screenHeight * 0.03),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: true,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      activeColor: const Color(0xFFF1F1F1),
                      inactiveColor: const Color(0xFFF1F1F1),
                      selectedColor: Colors.black,
                      errorBorderColor: Colors.red,
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 45,
                      fieldWidth: 45,
                      activeFillColor: Colors.white,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    controller: _textEditingController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Visibility(
                      visible: _validatePin,
                      child: Text(
                        _pinErrorText,
                        style: kFont12.copyWith(
                          color: Colors.red.shade900,
                        ),
                      )),
                ),
                SizedBox(height: screenHeight * 0.03),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _validatePin = false;
                      _pinErrorText = '';
                    });

                    if (_textEditingController.text.isEmpty) {
                      setState(() {
                        _validatePin = true;
                        _pinErrorText = 'Please enter 4 digit code';
                      });
                    } else if (_textEditingController.text.length < 4) {
                      _validatePin = true;
                      _pinErrorText = 'Please enter 4 digit code';
                    } else {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        await verifyOTP(_emailTextController.text, _textEditingController.text);
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                      if (_verifyOtp) {
                        setState(() {
                          _is4Digit = false;
                          _isForgotPassword = false;
                          _isPasswordReset = true;
                        });
                      }
                    }
                  },
                  style: kElevatedButtonStyle.copyWith(
                    padding:MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: screenHeight*0.007, horizontal:screenWidth*0.008),
                    ),
                  ),
                  child: _isLoading
                      ?  RotatingImage(
                    height:isLargerScreen? 30:22,
                    width: isLargerScreen? 30:22,
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Send',
                            style: isLargerScreen ? kButtonTextStyle : kButtonTextStyleSmallScreen,
                          ),
                        ),
                ),
                SizedBox(height: isLargerScreen ? screenHeight * 0.015 : screenHeight * 0.0075),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'If you didn\'t receive code? ',
                        style: kFont12.copyWith(color: kLightGrey),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await resendOTP(_emailTextController.text);
                          // Get.back();
                        },
                        child: Text(
                          'Resend',
                          style: kFont12.copyWith(
                              color: kHighlightedColor,
                              decoration: TextDecoration.underline,
                              decorationColor: kHighlightedColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Back to? ',
                    style: kFont12.copyWith(color: kLightGrey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offNamed(AppRoutes.signin);
                    },
                    child: Text(
                      'Sign in',
                      style: kFont12.copyWith(
                          color: kHighlightedColor,
                          decoration: TextDecoration.underline,
                          decorationColor: kHighlightedColor),
                    ),
                  ),
                ],
              ),
              Image.asset(
                'assets/images/dog_email_container.png',
                height: isLargerScreen ? screenHeight * 0.14 : screenHeight * 0.1,
                width: isLargerScreen ? screenWidth * 0.2 : screenWidth * 0.15,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildPasswordResetContainer(
      BuildContext context, double screenHeight, double screenWidth, bool isLargerScreen) {
    return Container(
      margin: EdgeInsets.only(top: isLargerScreen ? screenHeight * 0.133 : screenHeight * 0.13),
      width: double.infinity,
      padding: EdgeInsets.only(
        top: isLargerScreen ? screenHeight * 0.02 : screenHeight * 0.01,
        left: isLargerScreen ? screenWidth * 0.04:screenWidth * 0.07,
        right: isLargerScreen ? screenWidth * 0.04:screenWidth * 0.07,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFAFA), // Background color
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
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
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'New password',
                        style: isLargerScreen ? kHeadingTextStyle : kHeadingTextStyleSmallScreen,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Set the new password for your account',
                      style: isLargerScreen ? kFont12Grey : kFont12GreySmallScreen,
                    ),
                  ),
                  SizedBox(height: isLargerScreen ? screenHeight * 0.025 : screenHeight * 0.015),
                  const Text('Password', style: kTextFieldTextStyle),
                  TextField(
                    controller: _passwordTextController,
                    obscureText: !_passwordVisible,
                    onChanged: (value) {
                      setState(() {
                        _validatePassword = false;
                      });
                    },
                    style: kTextFieldTextStyle,
                    decoration: kTextFieldDecoration.copyWith(
                      errorStyle: TextStyle(fontSize: isLargerScreen ? 11 : 10),
                      isDense: isLargerScreen ? false : true,
                      suffixIconConstraints: BoxConstraints(
                        maxHeight: isLargerScreen ? 40 : 30,
                        maxWidth: 50,
                      ),
                      errorText: _validatePassword ? _passwordErrorText : null,
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
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: isLargerScreen ? screenHeight * 0.025 : screenHeight * 0.015),
                  const Text('Confirm password', style: kTextFieldTextStyle),
                  TextField(
                    controller: _confirmPasswordTextController,
                    obscureText: !_confirmPasswordVisible,
                    onChanged: (value) {
                      setState(() {
                        _validateConfirmPassword = false;
                      });
                    },
                    style: kTextFieldTextStyle,
                    decoration: kTextFieldDecoration.copyWith(
                      errorStyle: TextStyle(fontSize: isLargerScreen ? 11 : 10),
                      suffixIconConstraints: BoxConstraints(
                        maxHeight: isLargerScreen ? 40 : 30,
                        maxWidth: 50,
                      ),
                      isDense: isLargerScreen ? false : true,
                      errorText: _validateConfirmPassword ? _confirmPasswordErrorText : null,
                      hintText: 'Confirm password...',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF95969D),
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: isLargerScreen ? screenHeight * 0.035 : screenHeight * 0.022),
                  ElevatedButton(
                    onPressed: () async {
                      // Reset error messages
                      setState(() {
                        _validatePassword = false;
                        _validateConfirmPassword = false;
                        _passwordErrorText = 'Password can\'t be empty';
                        _confirmPasswordErrorText = 'Confirm password can\'t be empty';
                      });

                      // Check if password is empty
                      if (_passwordTextController.text.isEmpty) {
                        setState(() {
                          _validatePassword = true;
                          _passwordErrorText = 'Password can\'t be empty';
                        });
                        return;
                      } else if (_passwordTextController.text.length < 6) {
                        // Check if password is less than 6 characters
                        setState(() {
                          _validatePassword = true;
                          _passwordErrorText = 'Password must be at least 6 characters';
                        });
                        return;
                      } else if (!isPasswordValid(_passwordTextController.text)) {
                        // Check if password contains one alphabetic and special character
                        setState(() {
                          _validatePassword = true;
                          _passwordErrorText = 'At least one alphabetic and special character';
                        });
                        return;
                      }

                      if (_confirmPasswordTextController.text.isEmpty) {
                        setState(() {
                          _validateConfirmPassword = true;
                          _confirmPasswordErrorText = 'Confirm password can\'t be empty';
                        });
                        return;
                      } else if (_confirmPasswordTextController.text !=
                          _passwordTextController.text) {
                        // Check if confirm password matches password
                        setState(() {
                          _validateConfirmPassword = true;
                          _confirmPasswordErrorText = 'Password must match';
                        });
                        return;
                      }
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        final resetResult = await resetPassword(
                          _passwordTextController.text,
                          _resetPasswordToken,
                          _resetPasswordUserId,
                        );
                        if (resetResult == ResetPasswordResult.successful) {
                          Get.offAllNamed(AppRoutes.signin);
                        }
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    style: kElevatedButtonStyle.copyWith(
                      padding:MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: screenHeight*0.007, horizontal:screenWidth*0.008),
                      ),
                    ),
                    child: _isLoading
                        ? RotatingImage(
                      height:isLargerScreen? 30:22,
                      width: isLargerScreen? 30:22,
                          ) // Show loading indicator

                        : Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Reset password',
                              style:
                                  isLargerScreen ? kButtonTextStyle : kButtonTextStyleSmallScreen,
                            ),
                          ),
                  ),
                ],
              )),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/images/dog_email_container.png',
                height: isLargerScreen ? screenHeight * 0.14 : screenHeight * 0.1,
                width: isLargerScreen ? screenWidth * 0.2 : screenWidth * 0.15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
