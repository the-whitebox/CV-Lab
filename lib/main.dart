import 'dart:io';
import 'package:crewdog_cv_lab/utils/app_routes.dart';
import 'package:crewdog_cv_lab/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'utils/local_db.dart';

Future<void> main() async {
  await GetStorage.init();
  bool isIOS = Platform.isIOS;
  storePlatformInfo(isIOS);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CV Lab',
      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.getPages(),
      home: const SplashScreen(),
    );
  }
}
