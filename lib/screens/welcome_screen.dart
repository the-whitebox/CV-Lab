import 'dart:ui';
import 'package:crewdog_cv_lab/utils/app_routes.dart';
import 'package:crewdog_cv_lab/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/sso_auth/get_code_sso.dart';
import '../custom_widgets/rotating_image.dart';
import '../utils/consts/constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isBusy = false;

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
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/welcome.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Colors.white70,
                        Colors.transparent,
                        Colors.white38,
                        Colors.white
                      ])),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.07,
                    vertical: screenHeight * 0.00,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Image.asset(
                        'assets/images/crewDog_beta.png',
                        height: isLargerScreen
                            ? screenHeight * 0.075
                            : screenHeight * 0.078,
                        width: double.infinity,
                      ),

                      const Spacer(
                        flex: 5,
                      ), // Pushes the button to the bottom
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: loginTapped,
                            style: kElevatedButtonStyle.copyWith(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.007,
                                    horizontal: screenWidth * 0.008),
                              ),
                            ),
                            child: Text(
                              'Sign in',
                              style: isLargerScreen
                                  ? kButtonTextStyle
                                  : kButtonTextStyleSmallScreen,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isBusy)
            BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: const Center(
                    child: RotatingImage(
                  height: 100,
                  width: 100,
                ))),
        ],
      )),
    );
  }

  Future loginTapped() async {
    setState(() {
      isBusy = true;
    });
    final isValidToken = await signInWithSso();
    if (isValidToken) {
      Get.offAllNamed(AppRoutes.bottomBar);
      isBusy = false;
    } else {
      setState(() {
        isBusy = false;
      });
      appSnackBar("Login Failed", "Something went wrong.");
    }
  }
}
