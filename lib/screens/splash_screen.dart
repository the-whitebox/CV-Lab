import 'package:crewdog_cv_lab/utils/app_routes.dart';
import 'package:crewdog_cv_lab/utils/local_db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? token = getAccessToken();
    await Future.delayed(const Duration(seconds: 3));
    if (token.isEmpty) {
      Get.offAllNamed(AppRoutes.welcome);
    } else if (token.isNotEmpty) {
      Get.offAllNamed(AppRoutes.bottomBar);
      var responseData = await retrieveProfile(token);
      var profilePic = responseData['profile_pic'];
      if (profilePic != null) {
        storeProfilePic(profilePic);
      }
      var userId = responseData['id'];
      if(userId!=null){
        storeUserId(userId.toString());
      }
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
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_paws.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            const SizedBox(),
            Image.asset('assets/images/cv_lab.png',
                width:
                    isLargerScreen ? screenWidth * 0.65 : screenWidth * 0.55),
            Image.asset('assets/images/dog_email_container.png',
                height:
                    isLargerScreen ? screenHeight * 0.18 : screenHeight * 0.15),
          ],
        ),
      ),
    ));
  }
}
