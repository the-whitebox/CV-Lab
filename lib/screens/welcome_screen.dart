import 'package:crewdog_cv_lab/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight=MediaQuery.of(context).size.height;
    final screenWidth =MediaQuery.of(context).size.width;
    bool isLargerScreen = false;
    if (screenHeight < 600) {
      isLargerScreen = false;
    } else {
      isLargerScreen = true;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
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
                  gradient: LinearGradient(begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white70,Colors.transparent,Colors.white38,Colors.white])
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth*0.07,vertical: screenHeight*0.00,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Image.asset(
                      'assets/images/crewDog_beta.png',
                      height: isLargerScreen?screenHeight*0.06:screenHeight*0.078,
                      width: double.infinity,
                    ),

                    const Spacer(
                      flex: 5,
                    ), // Pushes the button to the bottom
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        ElevatedButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.signin);
                          },
                          style: kElevatedButtonStyle.copyWith(
                            padding:MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: screenHeight*0.007, horizontal:screenWidth*0.008),
                            ),
                          ),
                          child:  Text(
                            'Sign in',
                            style: isLargerScreen
                                ? kButtonTextStyle
                                : kButtonTextStyleSmallScreen,
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(top:isLargerScreen? screenHeight*0.01:0),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.toNamed(AppRoutes.signup);
                            },
                            style: kElevatedButtonWithWhiteColor.copyWith(
                              padding:MaterialStateProperty.all(
                                EdgeInsets.symmetric(vertical: screenHeight*0.007, horizontal:screenWidth*0.008),
                              ),
                            ),
                            child: Text(
                              'Sign up',
                              style: isLargerScreen
                                  ? kButtonTextStyle.copyWith(
                                  color: const Color(0xFFFF5E59))
                                  : kButtonTextStyleSmallScreen.copyWith(
                                  color: const Color(0xFFFF5E59)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight*0.07,)

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
