import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'consts/constants.dart';

appSnackBar (String? title, String message){
  return Get.snackbar(
      snackPosition: SnackPosition.BOTTOM,
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      margin: const EdgeInsets.only(bottom: 5,left: 5,right: 5),
      borderRadius: 10,borderWidth: 1,
      borderColor: kHighlightedColor,
      title??" Error",message,
      backgroundColor:
      kHighlightedColor.withOpacity(0.2));
}


appSuccessSnackBar (String? title, String message){
  return Get.snackbar(
      snackPosition: SnackPosition.BOTTOM,
    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
    margin: const EdgeInsets.only(bottom: 5,left: 5,right: 5),
      borderRadius: 10,borderWidth: 1,
      borderColor: kPurple,
      title?? " Success", message,
      backgroundColor: kPurple.withOpacity(0.3),
  );
}

