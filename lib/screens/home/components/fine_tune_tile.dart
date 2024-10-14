import 'package:flutter/material.dart';
import '../../../utils/consts/const_images.dart';
import '../../../utils/consts/constants.dart';

Widget fineTuneTile(screenWidth) {
  return Stack(children: [
    Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                decoration: BoxDecoration(color: kLightPurple, borderRadius: BorderRadius.circular(12)),
                child: Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.2),
                    child: const Text('Let\'s fine-tune your CV for a new role.\nPlease choose:', style: kFont10Black))))),
    Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Align(
            alignment: Alignment.topLeft,
            child: Padding(padding: const EdgeInsets.only(left: 4, top: 4), child: Image.asset(AppImages.dogDp, height: 25, width: 25))))
  ]);
}
